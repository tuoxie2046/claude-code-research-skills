#!/bin/bash
# autofigure doctor: verify the local AutoFigure / AutoFigure-Edit install is ready.
AUTOFIG_HOME="${AUTOFIG_HOME:-$HOME/apps/autofig_work}"
ok=0; bad=0
chk() { if eval "$2" >/dev/null 2>&1; then echo "  ✓ $1"; ok=$((ok+1)); else echo "  ✗ $1"; bad=$((bad+1)); fi; }
echo "AUTOFIG_HOME=$AUTOFIG_HOME"
echo "== assets =="
chk "afe_venv python"            "[ -x '$AUTOFIG_HOME/afe_venv/bin/python' ]"
chk "AutoFigure-Edit/autofigure2.py" "[ -f '$AUTOFIG_HOME/AutoFigure-Edit/autofigure2.py' ]"
chk "RMBG-2.0 local weights"     "[ -f '$AUTOFIG_HOME/rmbg_local/model.safetensors' ]"
chk "SAM3 checkpoint (sam3.pt)"  "[ -f '$AUTOFIG_HOME/sam3.pt' ]"
chk "SAM3 seeded in HF cache"    "ls $HOME/.cache/huggingface/hub/models--facebook--sam3/snapshots/*/sam3.pt"
echo "== python imports (torch/sam3/transformers) =="
chk "venv imports"               "'$AUTOFIG_HOME/afe_venv/bin/python' -c 'import torch,sam3,transformers'"
echo "== image-gen backends (for step-1 raster) =="
chk "hermes (gpt-image-2)"       "command -v hermes"
chk "openclaw (gpt-5.5 SVG LLM)" "command -v openclaw"
chk "agy (nano-banana, optional)" "command -v agy"
echo "== render =="
chk "Google Chrome (svg->pdf/png)" "[ -x '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' ]"
echo "== default OpenAI path (gpt-image-2 raster + gpt-5.5 SVG; soft checks) =="
HERMES="$HOME/.claude/skills/hermes-gpt-image/scripts/hermes-image.sh"
if [ -x "$HERMES" ] && bash "$HERMES" check 2>/dev/null | grep -qi 'logged in'; then
  echo "  ✓ gpt-image-2 ready (hermes openai-codex logged in)"
else
  echo "  ⚠ gpt-image-2: Codex not logged in -> run: hermes auth add openai-codex"
fi
if openclaw infer model providers 2>/dev/null | grep -E '"provider":"openai"' | grep -q '"configured":true'; then
  echo "  ✓ gpt-5.5 ready (openclaw openai provider configured)"
else
  echo "  ⚠ gpt-5.5: openclaw openai provider not configured (afe.sh shim needs it; or use SF_API_KEY)"
fi
echo "result: $ok ok, $bad missing (warnings above are soft)"
[ "$bad" -eq 0 ] && echo "READY" || echo "NOT READY — fix the ✗ items (see SKILL.md Setup)"
