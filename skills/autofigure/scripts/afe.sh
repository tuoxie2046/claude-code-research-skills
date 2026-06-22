#!/bin/bash
# AutoFigure-Edit: vectorize a raster figure into a clean EDITABLE SVG.
#   Pipeline: SAM3 segmentation -> RMBG icon extraction -> LLM SVG re-draw.
# usage: afe.sh <input_image> <output_dir> [sam_prompt] [svg_model]
#   Default SVG model:
#     - shim path (no SF_API_KEY): gpt-5.5 via local Codex shim (no API key needed)
#     - SiliconFlow path (SF_API_KEY set): Qwen/Qwen3-VL-32B-Instruct (override with SVG_MODEL or arg 4)
set -e
AUTOFIG_HOME="${AUTOFIG_HOME:-$HOME/apps/autofig_work}"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
IN="$1"; OUT="$2"; SAMP="${3:-icon,box,arrow,text label,diagram}"; ARG_MODEL="$4"
[ -f "$IN" ] || { echo "input image not found: $IN"; exit 1; }
[ -n "$OUT" ] || { echo "usage: afe.sh <input_image> <output_dir> [sam_prompt] [svg_model]"; exit 1; }
mkdir -p "$OUT"
source "$AUTOFIG_HOME/.hf_env" 2>/dev/null || true
export HF_HUB_OFFLINE=1 HF_HUB_DISABLE_XET=1 HF_HUB_DOWNLOAD_TIMEOUT=30 PYTHONUNBUFFERED=1

if [ -n "$SF_API_KEY" ]; then
  # SiliconFlow (or any OpenAI-compatible) provider for the multimodal SVG-generation LLM.
  BASE="${SF_BASE_URL:-https://api.siliconflow.cn/v1}"; KEY="$SF_API_KEY"
  MODEL="${SVG_MODEL:-${ARG_MODEL:-Qwen/Qwen3-VL-32B-Instruct}}"
else
  # default: gpt-5.5 via the local Codex shim (no API key needed).
  BASE="http://127.0.0.1:8745/v1"; KEY="dummy"; MODEL="${ARG_MODEL:-gpt-5.5}"
  if ! curl -s --max-time 3 "$BASE/models" >/dev/null 2>&1; then
    echo "[afe] starting gpt-5.5 shim..."
    nohup python3 "$SKILL_DIR/shim.py" >/tmp/autofig_shim.out 2>&1 &
    up=0
    for i in $(seq 1 12); do curl -s --max-time 2 "$BASE/models" >/dev/null 2>&1 && { up=1; break; }; sleep 1; done
    if [ "$up" != 1 ]; then
      echo "[afe] ERROR: gpt-5.5 shim did not come up (see /tmp/autofig_shim.out)." >&2
      echo "      Verify Codex is reachable:  openclaw infer model run --model openai/gpt-5.5 --prompt hi" >&2
      echo "      or use SiliconFlow instead: SF_API_KEY=sk-... SVG_MODEL=Qwen/Qwen3-VL-32B-Instruct $0 ..." >&2
      echo "      Aborting before SAM3 to avoid wasting compute." >&2
      exit 1
    fi
  fi
fi

echo "[afe] vectorizing $IN  (svg_model=$MODEL, sam='$SAMP')"
cd "$AUTOFIG_HOME/AutoFigure-Edit"
"$AUTOFIG_HOME/afe_venv/bin/python" autofigure2.py \
  --input_figure_path "$IN" --output_dir "$OUT" \
  --provider custom --base_url "$BASE" --api_key "$KEY" --svg_model "$MODEL" \
  --rmbg_model_path "$AUTOFIG_HOME/rmbg_local" \
  --sam_backend local --sam_prompt "$SAMP"
echo "[afe] DONE -> $OUT/final.svg (template.svg = editable layout; icons/ = extracted assets)"
