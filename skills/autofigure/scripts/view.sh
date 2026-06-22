#!/bin/bash
# Render an SVG or PDF to a PNG preview (for the assistant to Read and verify).
# usage: view.sh <in.svg|in.pdf> <out.png> [max_width]
IN="$1"; OUT="$2"; W="${3:-1600}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -f "$IN" ] || { echo "not found: $IN"; exit 1; }
case "$IN" in
  *.svg)
    read WW HH < <(python3 -c "
import re;s=open('$IN').read()
w=re.search(r'width=\"(\d+)',s);h=re.search(r'height=\"(\d+)',s)
print(int(w.group(1)) if w else 1920, int(h.group(1)) if h else 1080)")
    "$CHROME" --headless --disable-gpu --no-sandbox --hide-scrollbars --force-device-scale-factor=1 \
      --screenshot="$OUT.full.png" --window-size=${WW},${HH} --default-background-color=FFFFFFFF "file://$IN" 2>/dev/null
    sips -Z "$W" "$OUT.full.png" --out "$OUT" >/dev/null 2>&1; rm -f "$OUT.full.png" ;;
  *.pdf)
    qlmanage -t -s "$W" -o "$(dirname "$OUT")" "$IN" >/dev/null 2>&1
    mv "$(dirname "$OUT")/$(basename "$IN").png" "$OUT" 2>/dev/null ;;
esac
[ -f "$OUT" ] && echo "preview -> $OUT" || echo "render failed"
