# whisper-clip

Локальная система голосового ввода для Linux (Wayland).  
Нажал хоткей → говоришь → нажал снова → текст в буфере обмена.

## Как работает

- 1-е нажатие хоткея — старт записи
- 2-е нажатие — стоп → распознавание → текст в буфер (`Ctrl+V`)

Распознавание работает локально через [faster-whisper](https://github.com/SYSTRAN/faster-whisper)
на GPU (CUDA) или CPU.  
Демон держит модель в памяти — задержка после записи ~1-2 сек.

## Требования

- Linux + Wayland
- Python 3.10+
- NVIDIA GPU (опционально, без CUDA работает на CPU)

## Установка

```bash
git clone https://github.com/wnchstrr/whisper-clip
cd whisper-clip
bash install.sh
```

После установки отредактируй конфиг:

```bash
nvim ~/.config/whisper-clip/config
```

Найди своё аудиоустройство:

```bash
arecord -l
```

Повесь хоткей в GNOME:  
**Настройки → Клавиатура → Пользовательские → +**  
Команда: `~/.local/bin/whisper-clip.sh`

## Конфиг

```bash
AUDIO_DEVICE="hw:1,0"   # устройство записи (arecord -l)
AUDIO_RATE=44100         # частота дискретизации
AUDIO_CHANNELS=2         # каналы
WHISPER_MODEL="small"    # tiny / base / small / medium / large
WHISPER_DEVICE="cuda"    # cuda / cpu
WHISPER_LANGUAGE="ru"    # ru / en / или убрать для автоопределения
```

## Модели

| Модель | Размер | Точность | Скорость |
|--------|--------|----------|----------|
| tiny   | 75MB   | низкая   | быстро   |
| base   | 145MB  | средняя  | быстро   |
| small  | 488MB  | хорошая  | средне   |
| medium | 1.5GB  | высокая  | медленно |

