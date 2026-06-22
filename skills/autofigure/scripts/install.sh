#!/bin/bash
# One-time installer for the autofigure skill's heavy backend (AutoFigure-Edit).
# Builds the Python venv, clones the repos, installs SAM3, downloads the SAM3 + RMBG-2.0
# weights, and seeds the HF cache so the pipeline runs fully offline afterwards.
#
# usage:  HF_TOKEN=hf_xxx bash install.sh  [AUTOFIG_HOME]
#   HF_TOKEN is REQUIRED — briaai/RMBG-2.0 is a gated model. Request access at
#   https://huggingface.co/briaai/RMBG-2.0 then create a read token.
#   AUTOFIG_HOME defaults to ~/apps/autofig_work.
#
# Prerequisites you install yourself (NOT handled here): the image/LLM CLIs the skill drives
#   — `hermes` (gpt-image-2), `openclaw` (gpt-5.5) — and Google Chrome (svg->pdf/png).
set -euo pipefail
AUTOFIG_HOME="${1:-${AUTOFIG_HOME:-$HOME/apps/autofig_work}}"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
HF_TOKEN="${HF_TOKEN:-}"

echo "==> autofigure backend install -> $AUTOFIG_HOME"
command -v git >/dev/null || { echo "ERROR: git is required"; exit 1; }
PY="$(command -v python3.11 || command -v python3 || true)"
[ -n "$PY" ] || { echo "ERROR: python3.11 (or python3) is required"; exit 1; }
echo "    python: $("$PY" --version 2>&1)"
[ -n "$HF_TOKEN" ] || { echo "ERROR: set HF_TOKEN (briaai/RMBG-2.0 is gated). See header."; exit 1; }
mkdir -p "$AUTOFIG_HOME"; cd "$AUTOFIG_HOME"

echo "==> 1/5 clone repos"
[ -d AutoFigure-Edit ] || git clone --depth 1 https://github.com/ResearAI/AutoFigure-Edit.git
[ -d AutoFigure ]      || git clone --depth 1 https://github.com/ResearAI/AutoFigure.git || echo "    (AutoFigure optional; skipped)"
[ -d sam3_src ]        || git clone --depth 1 https://github.com/facebookresearch/sam3.git sam3_src

echo "==> 2/5 venv + Python deps (torch, transformers, sam3, cairosvg, huggingface_hub ...)"
[ -d afe_venv ] || "$PY" -m venv afe_venv
VPY="$AUTOFIG_HOME/afe_venv/bin/python"
"$VPY" -m pip install -q --upgrade pip
"$VPY" -m pip install -q -r AutoFigure-Edit/requirements.txt
"$VPY" -m pip install -q cairosvg "huggingface_hub>=0.24"
"$VPY" -m pip install -q -e sam3_src

echo "==> 3/5 write .hf_env"
cat > .hf_env <<EOF
export HF_TOKEN=$HF_TOKEN
export HUGGING_FACE_HUB_TOKEN=$HF_TOKEN
EOF

echo "==> 4/5 download SAM3 checkpoint (facebook/sam3, ~3.4GB) into the HF cache (Xet disabled)"
export HF_HUB_DISABLE_XET=1 HF_TOKEN HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"
SAM3_PT="$("$VPY" - <<'PY' | tail -1
from huggingface_hub import hf_hub_download
print(hf_hub_download(repo_id="facebook/sam3", filename="sam3.pt"))
PY
)"
ln -sf "$SAM3_PT" "$AUTOFIG_HOME/sam3.pt"
echo "    SAM3 checkpoint cached + linked: $AUTOFIG_HOME/sam3.pt"

echo "==> 5/5 download RMBG-2.0 (briaai/RMBG-2.0, gated, ~0.9GB) -> rmbg_local"
"$VPY" - <<PY
import os
from huggingface_hub import snapshot_download
snapshot_download(repo_id="briaai/RMBG-2.0",
                  local_dir=os.path.join("$AUTOFIG_HOME", "rmbg_local"),
                  allow_patterns=["model.safetensors", "config.json", "*.py"],
                  token="$HF_TOKEN")
print("    RMBG-2.0 -> $AUTOFIG_HOME/rmbg_local")
PY

echo "==> install complete. verifying:"
AUTOFIG_HOME="$AUTOFIG_HOME" bash "$SKILL_DIR/doctor.sh"
echo
echo "Done. Generate a figure with:"
echo "  bash $SKILL_DIR/gen.sh \"<prompt>\" /tmp/fig.png && bash $SKILL_DIR/afe.sh /tmp/fig.png /tmp/fig_out"
