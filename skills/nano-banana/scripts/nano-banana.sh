#!/usr/bin/env bash
# nano-banana.sh — wrapper around `agy` (Google Antigravity CLI) to generate images
# with nano-banana (Gemini image model, exposed to the agent as the `generate_image` tool).
#
# Subcommands:
#   check                              Verify agy is installed + authenticated
#   generate --prompt P [--output F]   Text -> image (PNG)
#   batch    <args...>                 Many prompts -> many images (see below)
#
# batch usage:
#   nano-banana.sh batch --prompts-file prompts.txt [--outdir DIR]
#   nano-banana.sh batch --prompt "p1" --prompt "p2" [--outdir DIR]
#   ... | nano-banana.sh batch --prompts-file -        (read prompts from stdin)
#   Prompt list: one prompt per line; blank lines and lines starting with # skipped.
#   Optional per-image name: "stem<TAB>prompt" sets the output filename stem.
#   Continues on error; writes manifest.tsv in the output dir.
#
# On success, prints one line per produced image:
#   IMAGE\t<path>\t<WxH>
# so the caller can Read the path. All diagnostics go to stderr.
#
# Env overrides:
#   NB_TIMEOUT      agy print-timeout (default 4m)
#   NB_IMAGE_DIR    default output directory (default: current dir)

set -uo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }

# --- ensure agy is on PATH ---
if ! command -v agy >/dev/null 2>&1; then
  for d in "$HOME/.local/bin" /opt/homebrew/bin; do
    [ -x "$d/agy" ] && export PATH="$d:$PATH" && break
  done
fi
command -v agy >/dev/null 2>&1 || \
  die "agy (Antigravity CLI) not found. Install it from https://antigravity.google"

BRAIN="$HOME/.gemini/antigravity-cli/brain"
TIMEOUT="${NB_TIMEOUT:-4m}"
OUTDIR="${NB_IMAGE_DIR:-.}"

# --- WxH of an image file (macOS sips) ---
dims() {
  if command -v sips >/dev/null 2>&1; then
    local w h
    w="$(sips -g pixelWidth  "$1" 2>/dev/null | awk '/pixelWidth/{print $2}')"
    h="$(sips -g pixelHeight "$1" 2>/dev/null | awk '/pixelHeight/{print $2}')"
    case "$w" in ''|*[!0-9]*) w="" ;; esac     # ignore non-numeric (e.g. sips "<nil>")
    case "$h" in ''|*[!0-9]*) h="" ;; esac
    [ -n "$w" ] && [ -n "$h" ] && { echo "${w}x${h}"; return; }
  fi
  echo "?x?"
}

# --- absolutize a path (agy resets cwd; absolute paths are reliable) ---
abspath() { case "$1" in /*) printf '%s' "$1" ;; *) printf '%s/%s' "$(pwd)" "$1" ;; esac; }

do_check() {
  echo "agy     : $(command -v agy)"
  echo "version : $(agy --version 2>/dev/null | head -1)"
  local creds="$HOME/.gemini/oauth_creds.json"
  if [ -f "$creds" ]; then
    echo "auth    : oauth creds present"
    [ -f "$HOME/.gemini/google_accounts.json" ] && \
      echo "account : $(python3 -c 'import json,os;print(json.load(open(os.path.expanduser("~/.gemini/google_accounts.json"))).get("active",""))' 2>/dev/null)"
    echo "note    : tokens can expire — if 'generate' reports auth, run 'agy' once interactively to re-login"
  else
    echo "auth    : NO oauth creds found — run 'agy' once interactively to log in" >&2
    return 1
  fi
}

# --- one generation attempt: drive agy, then verify/recover the output file ---
generate_once() {
  local prompt="$1" output="$2"
  local instr marker out rp newest before after
  instr="Use your image generation tool (nano banana / generate_image) to create this image:
${prompt}

Then save the final image as a PNG file at EXACTLY this absolute path: ${output}
Save only to that path. When finished, print one line exactly: RESULT_PATH=${output}"

  # Record the output's pre-run identity (inode:mtime:size). Success requires the file to be
  # present AND changed this run — so a stale file is never mistaken for success, and (unlike
  # deleting first) we never destroy the user's existing file on failure. Robust to same-tick
  # writes (compares the file to its own prior state, not to a freshly-stamped marker).
  before="$(stat -f '%i:%m:%z' "$output" 2>/dev/null || echo none)"
  marker="$(mktemp)"; out="$(mktemp)"
  agy -p "$instr" --dangerously-skip-permissions --print-timeout "$TIMEOUT" >"$out" 2>&1

  if grep -qiE "Authentication required|authentication timed out|IneligibleTier" "$out"; then
    sed -n '1,20p' "$out" >&2
    rm -f "$marker" "$out"
    echo "ERROR: agy is not authenticated/eligible. Run 'agy' once interactively to log in, then retry." >&2
    exit 3   # distinct code: lets batch abort instead of re-trying every prompt against dead auth
  fi

  # 1) output present AND actually created/changed during this run?
  after="$(stat -f '%i:%m:%z' "$output" 2>/dev/null || echo none)"
  if [ -s "$output" ] && [ "$after" != "$before" ]; then rm -f "$marker" "$out"; return 0; fi

  # 2) agent saved somewhere else -> copy from RESULT_PATH (skip if it points back to output)
  rp="$(grep -aoE 'RESULT_PATH=.*' "$out" | head -1 | sed 's/^RESULT_PATH=//' | tr -d '\r')"
  if [ -n "$rp" ] && [ "$rp" != "$output" ] && [ -s "$rp" ]; then
    if cp "$rp" "$output" 2>/dev/null; then rm -f "$marker" "$out"; return 0; fi
  fi

  # 3) newest image created in the brain dir during this run -> convert to PNG
  #    portable newest-by-mtime (no xargs -r / no ls-batch-split); empty input -> empty
  newest="$(find "$BRAIN" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -newer "$marker" 2>/dev/null \
            | while IFS= read -r f; do stat -f '%m %N' "$f" 2>/dev/null; done | sort -rn | head -1 | cut -d' ' -f2-)"
  if [ -n "$newest" ] && [ -s "$newest" ]; then
    if command -v sips >/dev/null 2>&1; then
      sips -s format png "$newest" --out "$output" >/dev/null 2>&1 && { rm -f "$marker" "$out"; return 0; }
    fi
    cp "$newest" "$output" 2>/dev/null && { rm -f "$marker" "$out"; return 0; }
  fi

  sed -n '1,30p' "$out" >&2
  rm -f "$marker" "$out"
  return 1
}

do_generate() {
  local prompt="" output=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --prompt)     prompt="${2:-}";  if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --output|-o)  output="${2:-}";  if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      *) shift ;;
    esac
  done
  [ -n "$prompt" ] || die "generate needs --prompt"
  if [ -z "$output" ]; then
    mkdir -p "$OUTDIR"; output="$OUTDIR/nb-image-$(date +%Y%m%d-%H%M%S).png"
  fi
  output="$(abspath "$output")"
  mkdir -p "$(dirname "$output")"

  local attempt max=2
  for attempt in $(seq 1 "$max"); do
    if generate_once "$prompt" "$output"; then
      printf 'IMAGE\t%s\t%s\n' "$output" "$(dims "$output")"
      return 0
    fi
    [ "$attempt" -lt "$max" ] && echo "warn: generate attempt $attempt produced no file, retrying..." >&2 && sleep 2
  done
  die "no image produced for prompt after $max attempts (see agy output above)"
}

do_batch() {
  local prompts_file="" outdir=""
  local -a prompts=()
  while [ $# -gt 0 ]; do
    case "$1" in
      --prompts-file) prompts_file="${2:-}"; if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --outdir)       outdir="${2:-}";       if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --prompt)       prompts+=("${2:-}");   if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      *) shift ;;
    esac
  done
  if [ -n "$prompts_file" ]; then
    local src="$prompts_file"; [ "$src" = "-" ] && src="/dev/stdin"
    [ "$src" = "/dev/stdin" ] || [ -f "$src" ] || die "prompts file not found: $prompts_file"
    local line
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ""|\#*) continue ;; esac
      prompts+=("$line")
    done < "$src"
  fi
  [ "${#prompts[@]}" -gt 0 ] || die "no prompts given (use --prompts-file or repeated --prompt)"

  [ -n "$outdir" ] || outdir="$OUTDIR/nb-batch-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$outdir"
  local manifest="$outdir/manifest.tsv"
  printf 'stem\tstatus\tpath\tprompt\n' > "$manifest"

  local total="${#prompts[@]}" ok=0 fail=0 idx p stem prompt outpath prompt_log rc
  echo "batch: $total prompt(s) -> $outdir" >&2
  for idx in "${!prompts[@]}"; do
    p="${prompts[$idx]}"
    case "$p" in
      *"$(printf '\t')"*) stem="${p%%"$(printf '\t')"*}"; prompt="${p#*"$(printf '\t')"}" ;;
      *) stem="$(printf '%03d' $((idx + 1)))"; prompt="$p" ;;
    esac
    stem="$(printf '%s' "$stem" | tr -c 'A-Za-z0-9._-' '_')"
    [ -n "$stem" ] || stem="$(printf '%03d' $((idx + 1)))"
    outpath="$outdir/$stem.png"
    prompt_log="$(printf '%s' "$prompt" | tr '\t\r\n' '   ')"
    echo "=== [$((idx + 1))/$total] $stem ===" >&2
    # subshell isolates do_generate's die()/exit so the batch continues past a single failure
    ( do_generate --prompt "$prompt" --output "$outpath" ); rc=$?
    if [ "$rc" -eq 0 ]; then
      ok=$((ok + 1)); printf '%s\tok\t%s\t%s\n' "$stem" "$outpath" "$prompt_log" >> "$manifest"
    else
      fail=$((fail + 1)); echo "FAILED	$stem" >&2
      printf '%s\tfailed\t\t%s\n' "$stem" "$prompt_log" >> "$manifest"
      if [ "$rc" -eq 3 ]; then
        echo "aborting batch: agy authentication failed — run 'agy' to log in, then retry" >&2
        break
      fi
    fi
  done
  echo "batch done: $ok ok, $fail failed -> $outdir (manifest: $manifest)" >&2
  [ "$fail" -eq 0 ]
}

main() {
  local cmd="${1:-}"; shift || true
  case "$cmd" in
    check)     do_check ;;
    generate)  do_generate "$@" ;;
    batch)     do_batch "$@" ;;
    ""|-h|--help)
      awk 'NR==1{next} /^#/{line=$0; sub(/^# ?/,"",line); print line; next} {exit}' "$0" ;;
    *) die "unknown subcommand: $cmd (use: check|generate|batch)" ;;
  esac
}
main "$@"
