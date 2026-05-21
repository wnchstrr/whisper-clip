import socket
import os

CONFIG_PATH = os.path.expanduser("~/.config/whisper-clip/config")
config = {}
with open(CONFIG_PATH) as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith("#"):
            key, _, value = line.partition("=")
            config[key.strip()] = value.strip().strip('"')

SOCKET_PATH = "/tmp/whisper.sock"
MODEL = config.get("WHISPER_MODEL", "small")
DEVICE = config.get("WHISPER_DEVICE", "cuda")
LANGUAGE = config.get("WHISPER_LANGUAGE", "ru")

from faster_whisper import WhisperModel

model = WhisperModel(MODEL, device=DEVICE)
print(f"Модель загружена: {MODEL} on {DEVICE}", flush=True)

if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(SOCKET_PATH)
server.listen(1)

while True:
    conn, _ = server.accept()
    try:
        filepath = conn.recv(1024).decode().strip()
        segments, _ = model.transcribe(filepath, language=LANGUAGE)
        text = " ".join(s.text.strip() for s in segments)
        conn.sendall(text.encode())
    except Exception as e:
        print(f"Ошибка: {e}", flush=True)
    finally:
        conn.close()
