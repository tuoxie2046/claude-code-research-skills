#!/usr/bin/env bash
# oc-image.sh — thin, robust wrapper around `openclaw infer image` (model: gpt-image-2)
#
# Subcommands:
#   check                         Preflight: verify openclaw + OpenAI image auth
#   generate <openclaw args...>   Text -> image
#   edit     <openclaw args...>   Image(s) + prompt -> image  (needs --file)
#   describe <openclaw args...>   Image -> text description    (needs --file)
#   batch    <args...>            Many prompts -> many images (see below)
#
# batch usage:
#   oc-image.sh batch --prompts-file prompts.txt [--outdir DIR] [generate passthrough...]
#   oc-image.sh batch --prompt "p1" --prompt "p2" [--outdir DIR] [...]
#   ... | oc-image.sh batch --prompts-file -        (read prompts from stdin)
#   Prompt list: one prompt per line; blank lines and lines starting with # skipped.
#   Optional per-image name: "stem<TAB>prompt" sets the output filename stem.
#   Passthrough flags (--size --output-format --background --aspect-ratio
#   --resolution --model --timeout-ms) apply to every image; --count is ignored
#   (batch is one image per prompt). Continues on error; writes manifest.tsv.
#
# Defaults injected automatically when absent: --model openai/gpt-image-2, --json,
# and (for generate/edit) --output ./oc-image-<timestamp>.png
#
# On success, prints one line per produced image:
#   IMAGE\t<path>\t<WxH>
# so the caller can Read the path. All diagnostics go to stderr.
#
# Env overrides:
#   OC_IMAGE_MODEL   override model (default openai/gpt-image-2)
#   OC_IMAGE_DIR     default output directory (default: current dir)

set -uo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }

# --- ensure openclaw is on PATH (npm global bin lives under homebrew prefix) ---
if ! command -v openclaw >/dev/null 2>&1; then
  NPM_BIN="$(npm prefix -g 2>/dev/null)/bin"
  [ -d "$NPM_BIN" ] && export PATH="$NPM_BIN:$PATH"
fi
command -v openclaw >/dev/null 2>&1 || \
  die "openclaw not found on PATH. Install with: npm install -g openclaw@latest"

MODEL="${OC_IMAGE_MODEL:-openai/gpt-image-2}"
VISION_MODEL="${OC_VISION_MODEL:-openai/gpt-5.5}"   # for `describe` (image understanding)
OUTDIR="${OC_IMAGE_DIR:-.}"

# --- preflight: is the OpenAI image provider authenticated? ---
do_check() {
  echo "openclaw : $(command -v openclaw)"
  echo "model    : $MODEL"
  local prov; prov="$(mktemp)"
  openclaw infer image providers 2>/dev/null >"$prov"
  python3 - "$prov" <<'PY'
import json, sys
configured = False
for line in open(sys.argv[1]):
    line = line.strip()
    if not line:
        continue
    try:
        p = json.loads(line)
    except Exception:
        continue
    if p.get("id") == "openai":
        configured = bool(p.get("configured"))
        print("openai image provider configured: %s" % configured)
        print("available models: %s" % ", ".join(p.get("models", [])))
if not configured:
    sys.stderr.write(
        "WARN: OpenAI image provider not authenticated.\n"
        "      Run: openclaw models auth login --provider openai\n"
        "      (or set OPENAI_API_KEY for API-key access)\n")
    sys.exit(1)
PY
  local rc=$?
  rm -f "$prov"
  return $rc
}

# --- parse openclaw --json output (tolerant of any leading log lines) ---
print_outputs() {
  python3 - "$1" <<'PY'
import json, sys
txt = open(sys.argv[1]).read()
i = txt.find("{")
if i < 0:
    sys.stderr.write("ERROR: no JSON in openclaw output:\n" + txt[:800] + "\n")
    sys.exit(2)
try:
    d = json.loads(txt[i:])
except Exception as e:
    sys.stderr.write("ERROR: could not parse openclaw JSON (%s):\n%s\n" % (e, txt[i:i+800]))
    sys.exit(2)
if not d.get("ok"):
    sys.stderr.write("ERROR: provider returned failure:\n" + json.dumps(d, indent=2)[:1200] + "\n")
    sys.exit(1)
outs = d.get("outputs") or []
if not outs:
    sys.stderr.write("ERROR: no outputs returned:\n" + json.dumps(d, indent=2)[:800] + "\n")
    sys.exit(1)
for o in outs:
    print("IMAGE\t%s\t%sx%s" % (o.get("path", "?"), o.get("width", "?"), o.get("height", "?")))
    rp = o.get("revisedPrompt")
    if rp:
        sys.stderr.write("revisedPrompt: " + rp.replace("\n", " ")[:600] + " ...\n")
PY
}

# --- run an infer image subcommand with defaults injected ---
run_infer() {
  local sub="$1"; shift
  local -a args=("$@")
  local has_model=0 has_json=0 has_output=0 out_path="" a prev=""
  for a in ${args[@]+"${args[@]}"}; do
    case "$a" in
      --model)  has_model=1 ;;
      --json)   has_json=1 ;;
      --output) has_output=1 ;;
    esac
    [ "$prev" = "--output" ] && out_path="$a"
    prev="$a"
  done
  # gpt-image-2 is an image model: inject it only for generate/edit.
  # describe needs a vision-capable text model (the image-model default would error).
  if [ "$has_model" -eq 0 ]; then
    if [ "$sub" = describe ]; then
      args+=(--model "$VISION_MODEL")
    else
      args+=(--model "$MODEL")
    fi
  fi
  [ "$has_json" -eq 0 ] && args+=(--json)
  if [ "$has_output" -eq 0 ] && { [ "$sub" = generate ] || [ "$sub" = edit ]; }; then
    local ts; ts="$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$OUTDIR"
    args+=(--output "$OUTDIR/oc-image-$ts.png")
  elif [ -n "$out_path" ]; then
    mkdir -p "$(dirname "$out_path")"
  fi

  local out err attempt rc=1 max=2
  out="$(mktemp)"; err="$(mktemp)"
  for attempt in $(seq 1 "$max"); do
    openclaw infer image "$sub" "${args[@]}" >"$out" 2>"$err"
    rc=$?
    [ "$rc" -eq 0 ] && break
    [ "$attempt" -lt "$max" ] && echo "warn: $sub attempt $attempt failed (rc=$rc), retrying..." >&2 && sleep 2
  done
  if [ "$rc" -ne 0 ]; then
    grep -iE "image auth selected" "$err" >&2 || true
    sed -n '1,40p' "$err" >&2
    sed -n '1,20p' "$out" >&2
    rm -f "$out" "$err"
    die "openclaw infer image $sub failed after $max attempts. If auth-related, run: openclaw models auth login --provider openai"
  fi
  grep -iE "image auth selected" "$err" >&2 || true

  local body_rc=0
  if [ "$sub" = describe ]; then
    python3 - "$out" <<'PY' || body_rc=$?
import json, sys
txt = open(sys.argv[1]).read(); i = txt.find("{")
d = json.loads(txt[i:]) if i >= 0 else {}
outs = d.get("outputs") or []
text = ""
if outs and isinstance(outs[0], dict):
    text = outs[0].get("text") or outs[0].get("description") or ""
text = text or d.get("description") or d.get("text") or ""
if text:
    print(text)
else:
    sys.stderr.write("ERROR: no description text in output:\n" + json.dumps(d, indent=2, ensure_ascii=False)[:800] + "\n")
    sys.exit(1)
PY
  else
    print_outputs "$out" || body_rc=$?
  fi
  rm -f "$out" "$err"
  return "$body_rc"
}

# --- batch: many prompts -> many images, continue-on-error, with manifest ---
do_batch() {
  local prompts_file="" outdir=""
  local -a passthrough=() prompts=()
  while [ $# -gt 0 ]; do
    case "$1" in
      --prompts-file) prompts_file="${2:-}"; if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --outdir)       outdir="${2:-}";       if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --prompt)       prompts+=("${2:-}");   if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      --count)        echo "warn: --count ignored in batch (one image per prompt; use 'generate' for multiples)" >&2
                      if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
      *)
        passthrough+=("$1")
        case "$1" in
          --size|--output-format|--background|--openai-background|--aspect-ratio|--resolution|--timeout-ms|--model)
            if [ $# -ge 2 ]; then passthrough+=("$2"); shift 2; else shift; fi ;;
          *) shift ;;
        esac ;;
    esac
  done

  # read prompts from a file ("-" = stdin)
  if [ -n "$prompts_file" ]; then
    local src="$prompts_file"
    [ "$src" = "-" ] && src="/dev/stdin"
    [ "$src" = "/dev/stdin" ] || [ -f "$src" ] || die "prompts file not found: $prompts_file"
    local line
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ""|\#*) continue ;; esac
      prompts+=("$line")
    done < "$src"
  fi
  [ "${#prompts[@]}" -gt 0 ] || die "no prompts given (use --prompts-file or repeated --prompt)"

  [ -n "$outdir" ] || outdir="$OUTDIR/oc-batch-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$outdir"
  local manifest="$outdir/manifest.tsv"
  printf 'stem\tstatus\tpath\tprompt\n' > "$manifest"

  local total="${#prompts[@]}" ok=0 fail=0 idx p stem prompt outpath
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
    # manifest is TSV: flatten tabs/newlines in the prompt to keep one row per entry
    local prompt_log; prompt_log="$(printf '%s' "$prompt" | tr '\t\r\n' '   ')"
    echo "=== [$((idx + 1))/$total] $stem ===" >&2
    # subshell: run_infer may call die()/exit on hard failure; isolate it so the
    # batch continues to the next prompt instead of aborting the whole script.
    if ( run_infer generate --prompt "$prompt" --output "$outpath" ${passthrough[@]+"${passthrough[@]}"} ); then
      ok=$((ok + 1))
      printf '%s\tok\t%s\t%s\n' "$stem" "$outpath" "$prompt_log" >> "$manifest"
    else
      fail=$((fail + 1))
      echo "FAILED	$stem" >&2
      printf '%s\tfailed\t\t%s\n' "$stem" "$prompt_log" >> "$manifest"
    fi
  done
  echo "batch done: $ok ok, $fail failed -> $outdir (manifest: $manifest)" >&2
  [ "$fail" -eq 0 ]
}

main() {
  local cmd="${1:-}"; shift || true
  case "$cmd" in
    check)            do_check ;;
    generate|edit|describe) run_infer "$cmd" "$@" ;;
    batch)            do_batch "$@" ;;
    ""|-h|--help)
      # print the contiguous header comment block (stops at first non-comment line)
      awk 'NR==1{next} /^#/{line=$0; sub(/^# ?/,"",line); print line; next} {exit}' "$0" ;;
    *)                die "unknown subcommand: $cmd (use: check|generate|edit|describe|batch)" ;;
  esac
}
main "$@"
