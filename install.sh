#!/bin/bash

set -e

echo "Устанавливаем зависимости..."
sudo apt install -y alsa-utils wl-clipboard socat

echo "Устанавливаем faster-whisper..."
pip install faster-whisper --break-system-packages

echo "Копируем файлы..."
mkdir -p ~/.local/bin
mkdir -p ~/.config/whisper-clip

cp whisper-clip.sh ~/.local/bin/whisper-clip.sh
cp whisper-daemon.py ~/.local/bin/whisper-daemon.py
chmod +x ~/.local/bin/whisper-clip.sh

if [ ! -f ~/.config/whisper-clip/config ]; then
    cp config.example ~/.config/whisper-clip/config
    echo "Конфиг скопирован → ~/.config/whisper-clip/config"
    echo "Отредактируй AUDIO_DEVICE под своё железо: arecord -l"
fi

echo "Настраиваем автозапуск..."
mkdir -p ~/.config/systemd/user
cp whisper-daemon.service ~/.config/systemd/user/
systemctl --user enable whisper-daemon
systemctl --user start whisper-daemon

echo "Готово. Повесь хоткей на: ~/.local/bin/whisper-clip.sh"
