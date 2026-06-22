#!/bin/bash
# Convert an SVG to an exact-size, margin-free PDF (for LaTeX \includegraphics).
# usage: svg2pdf.sh <in.svg> <out.pdf> [width_in]   (height auto from the SVG viewBox aspect)
SVG="$1"; OUT="$2"; WIN="${3:-10}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -f "$SVG" ] || { echo "svg not found: $SVG"; exit 1; }
read W H < <(python3 -c "
import re,sys
s=open('$SVG').read()
w=re.search(r'width=\"(\d+(?:\.\d+)?)',s); h=re.search(r'height=\"(\d+(?:\.\d+)?)',s)
vb=re.search(r'viewBox=\"[\d.]+ [\d.]+ ([\d.]+) ([\d.]+)',s)
if w and h: print(float(w.group(1)), float(h.group(1)))
elif vb: print(float(vb.group(1)), float(vb.group(2)))
else: print(1920,1080)")
HIN=$(python3 -c "print(round($WIN*$H/$W,3))")
TMP=$(mktemp /tmp/autofig_wrap_XXXX.html)
python3 -c "
svg=open('$SVG').read()
open('$TMP','w').write('<!doctype html><html><head><meta charset=\"utf-8\"><style>@page{size:${WIN}in ${HIN}in;margin:0;}html,body{margin:0;padding:0;background:#fff;}svg{display:block;width:${WIN}in;height:${HIN}in;}</style></head><body>'+svg+'</body></html>')"
"$CHROME" --headless --disable-gpu --no-sandbox --no-pdf-header-footer --print-to-pdf="$OUT" "file://$TMP" 2>/dev/null
rm -f "$TMP"
echo "wrote $OUT  (${WIN}in x ${HIN}in)"
