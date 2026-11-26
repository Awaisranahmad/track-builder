#!/usr/bin/env python3
"""Track Builder ke liye chhote synthesized WAV assets banata hai.

Koi downloaded file nahi — saare tones yahin generate hote hain:
- sfx/click.wav, coin.wav, win.wav, crash.wav, engine.wav (loop)
- music/music.wav (8s loop, chord pad)

Dobara chalana ho to: python3 tools/generate_audio.py
"""
import math
import os
import struct
import wave

SR = 22050
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "audio")


def write_wav(path, samples):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        frames = b"".join(
            struct.pack("<h", max(-32767, min(32767, int(s * 32767))))
            for s in samples
        )
        w.writeframes(frames)
    print(f"{path}: {len(samples) / SR:.2f}s")


def sine(freq, t):
    return math.sin(2 * math.pi * freq * t)


def tone(freqs, dur, vol=0.3, attack=0.005, release=0.05):
    """Ek ya zyada sine notes, attack/release envelope ke saath."""
    n = int(SR * dur)
    out = []
    for i in range(n):
        t = i / SR
        env = 1.0
        if t < attack:
            env = t / attack
        elif t > dur - release:
            env = max(0.0, (dur - t) / release)
        s = sum(sine(f, t) for f in freqs) / max(1, len(freqs))
        out.append(vol * env * s)
    return out


def seq(notes):
    """[(freqs, dur, vol), ...] ko jor kar ek clip banao."""
    out = []
    for freqs, dur, vol in notes:
        out.extend(tone(freqs, dur, vol))
    return out


def noise_burst(dur, vol=0.4):
    import random

    random.seed(7)
    n = int(SR * dur)
    out = []
    for i in range(n):
        t = i / SR
        env = max(0.0, 1 - t / dur) ** 2
        # Low thud (70Hz) + noise.
        s = 0.7 * sine(70, t) + 0.3 * (random.random() * 2 - 1)
        out.append(vol * env * s)
    return out


def main():
    # Click — chhota blip.
    write_wav(
        os.path.join(OUT, "sfx", "click.wav"),
        tone([1200], 0.07, vol=0.25, release=0.06),
    )
    # Coin — do-tone ding.
    write_wav(
        os.path.join(OUT, "sfx", "coin.wav"),
        seq([([987], 0.12, 0.3), ([1318], 0.18, 0.3)]),
    )
    # Win — chaar notes ka arpeggio.
    write_wav(
        os.path.join(OUT, "sfx", "win.wav"),
        seq(
            [
                ([523], 0.2, 0.3),
                ([659], 0.2, 0.3),
                ([784], 0.2, 0.3),
                ([1047], 0.3, 0.35),
            ]
        ),
    )
    # Crash — low thud + noise.
    write_wav(os.path.join(OUT, "sfx", "crash.wav"), noise_burst(0.35))

    # Engine — 1s loop, harmonics integer cycles (55/110/165Hz) taake
    # loop point par click na ho.
    n = SR
    engine = [
        0.22 * sine(55, i / SR) + 0.12 * sine(110, i / SR) + 0.06 * sine(165, i / SR)
        for i in range(n)
    ]
    write_wav(os.path.join(OUT, "sfx", "engine.wav"), engine)

    # Music — 8s loop, C-Am-F-G chord pad. Har chord 2s, 0.2s
    # fade in/out taake chord change aur loop point smooth rahe.
    # Frequencies 1/8 Hz ke multiple par quantize ki hain taake
    # 8s mein poore cycles hon (loop click nahi).
    def q(f):
        return round(f * 8) / 8

    chords = [
        [261.63, 329.63, 392.00],  # C
        [220.00, 261.63, 329.63],  # Am
        [174.61, 220.00, 261.63],  # F
        [196.00, 246.94, 293.66],  # G
    ]
    total = 8 * SR
    music = [0.0] * total
    for ci, chord in enumerate(chords):
        start = ci * 2 * SR
        for i in range(2 * SR):
            t = i / SR
            # 0.2s attack, 0.2s release — hamesha 0 se 0.
            env = 1.0
            if t < 0.2:
                env = t / 0.2
            elif t > 1.8:
                env = (2.0 - t) / 0.2
            s = 0.0
            for f in chord:
                fq = q(f)
                s += 0.11 * sine(fq, t) + 0.04 * sine(q(f * 2), t)
            music[start + i] += env * s
    write_wav(os.path.join(OUT, "music", "music.wav"), music)


if __name__ == "__main__":
    main()
