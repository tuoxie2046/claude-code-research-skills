#!/usr/bin/env python3
"""Minimal OpenAI-compatible /v1/chat/completions shim that backends to
`openclaw infer model run --model openai/gpt-5.5` (Codex subscription, no API key).
Lets AutoFigure-Edit (--provider custom) use gpt-5.5 for the SVG step."""
import json, time, base64, tempfile, subprocess, os, uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

OC_MODEL = os.environ.get("OC_MODEL", "openai/gpt-5.5")
PORT = int(os.environ.get("SHIM_PORT", "8745"))
LOG = open(os.environ.get("SHIM_LOG", "/tmp/autofig_shim.log"), "a")


def log(*a):
    print(time.strftime("%H:%M:%S"), *a, file=LOG, flush=True)


def extract(messages):
    texts, files = [], []
    for m in messages:
        role = m.get("role", "user")
        c = m.get("content")
        if isinstance(c, str):
            if c.strip():
                texts.append(f"[{role}]\n{c}")
        elif isinstance(c, list):
            for part in c:
                t = part.get("type")
                if t == "text" and part.get("text", "").strip():
                    texts.append(f"[{role}]\n{part['text']}")
                elif t == "image_url":
                    url = (part.get("image_url") or {}).get("url", "")
                    if url.startswith("data:") and "," in url:
                        b64 = url.split(",", 1)[1]
                        fd, path = tempfile.mkstemp(suffix=".png", dir="/tmp")
                        with os.fdopen(fd, "wb") as f:
                            f.write(base64.b64decode(b64))
                        files.append(path)
    return "\n\n".join(texts), files


def call_oc(prompt, files):
    cmd = ["openclaw", "infer", "model", "run", "--model", OC_MODEL,
           "--prompt", prompt, "--json"]
    for f in files:
        cmd += ["--file", f]
    log("CALL", len(prompt), "chars", len(files), "imgs")
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
    out = (p.stdout or "").strip()
    try:
        j = json.loads(out)
        text = j["outputs"][0]["text"]
        log("OK", len(text), "chars out")
        return text
    except Exception as e:
        log("PARSE-FAIL", repr(e), "STDOUT:", out[:400], "STDERR:", (p.stderr or "")[:400])
        return out or (p.stderr or "").strip() or ""


class H(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, obj, code=200):
        b = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        if self.path.rstrip("/").endswith("/models"):
            self._send({"object": "list", "data": [
                {"id": "gpt-5.5", "object": "model", "owned_by": "openai"}]})
        else:
            self._send({"ok": True})

    def do_POST(self):
        try:
            n = int(self.headers.get("Content-Length", 0))
            body = json.loads(self.rfile.read(n) or b"{}")
        except Exception as e:
            self._send({"error": {"message": f"bad request: {e}"}}, 400)
            return
        model = body.get("model", "gpt-5.5")
        prompt, files = extract(body.get("messages", []))
        try:
            text = call_oc(prompt, files)
        except Exception as e:
            log("ERR", repr(e))
            self._send({"error": {"message": str(e)}}, 500)
            return
        finally:
            for f in files:
                try:
                    os.remove(f)
                except OSError:
                    pass
        self._send({
            "id": "chatcmpl-" + uuid.uuid4().hex[:12],
            "object": "chat.completion", "created": int(time.time()), "model": model,
            "choices": [{"index": 0, "finish_reason": "stop",
                         "message": {"role": "assistant", "content": text}}],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        })


if __name__ == "__main__":
    log("=== shim up on", PORT, "model", OC_MODEL, "===")
    ThreadingHTTPServer(("127.0.0.1", PORT), H).serve_forever()
