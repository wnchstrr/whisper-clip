#!/bin/bash

# Читаем конфиг
CONFIG="$HOME/.config/whisper-clip/config"
source "$CONFIG"

PIDFILE=/tmp/whisper-rec.pid
TMPFILE=/tmp/whisper-rec.wav

if [ -f "$PIDFILE" ]; then
    # второе нажатие — останавливаем запись
    kill $(cat "$PIDFILE")
    rm "$PIDFILE"

    # отправляем файл демону, получаем текст, кладём в буфер
    (python3 - "$TMPFILE" << 'PYEOF'
import socket, sys

SOCKET_PATH = "/tmp/whisper.sock"
filepath = sys.argv[1]

client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
client.connect(SOCKET_PATH)
client.sendall(filepath.encode())
client.shutdown(socket.SHUT_WR)
text = b""
while chunk := client.recv(1024):
    text += chunk
client.close()
print(text.decode())
PYEOF
    ) | wl-copy

    rm "$TMPFILE"
else
    # первое нажатие — запускаем запись с параметрами из конфига
    arecord -D "$AUDIO_DEVICE" -f S16_LE -r "$AUDIO_RATE" -c "$AUDIO_CHANNELS" "$TMPFILE" 2>/dev/null &
    echo $! > "$PIDFILE"
fi
