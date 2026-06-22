#!/bin/bash
# Generate a STEP-1 raster (the draft figure) for AutoFigure-Edit to vectorize.
# Default backend: gpt-image-2 via the hermes-gpt-image skill (Codex subscription).
# usage: gen.sh "<image prompt>" <output.png> [aspect]   aspect: landscape|square|portrait
PROMPT="$1"; OUT="$2"; ASPECT="${3:-landscape}"
[ -n "$PROMPT" ] && [ -n "$OUT" ] || { echo 'usage: gen.sh "<image prompt>" <output.png> [landscape|square|portrait]'; exit 1; }
HERMES="$HOME/.claude/skills/hermes-gpt-image/scripts/hermes-image.sh"
if [ -x "$HERMES" ]; then
  # default raster backend: gpt-image-2 (OpenAI/Codex) via the hermes-gpt-image skill
  exec "$HERMES" generate --quality high --aspect "$ASPECT" --prompt "$PROMPT" --output "$OUT"
else
  echo "gpt-image-2 backend (hermes-gpt-image skill) not found at: $HERMES" >&2
  echo "Install it, or make the raster another way (e.g. the nano-banana skill) and pass it to afe.sh." >&2
  exit 1
fi
