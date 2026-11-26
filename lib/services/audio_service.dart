// Audio System — music aur sound effects (design doc §6, system 7).
// Flame Audio (flame_audio) se bajta hai; assets/audio/ mein WAV files
// hain jo tools/generate_audio.py se generate hoti hain.
// Har call try/catch mein hai: audio load na ho (web autoplay,
// test environment) to game rukta nahi — sirf khamoshi rehti hai.
// Tests mein AudioService(testMode: true) istemal hota hai — kuch nahi bajta.
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';

/// App bhar ek hi instance — main.dart mein banata hai.
final AudioService audioService = AudioService();

class AudioService {
  AudioService({this.testMode = false});

  /// true ho to koi audio call nahi hoti (tests ke liye).
  final bool testMode;

  bool _available = true;
  bool musicOn = true;
  bool sfxOn = true;

  AudioPlayer? _musicPlayer;
  AudioPlayer? _enginePlayer;

  /// Assets pehle se load karo — app start par ek dafa.
  Future<void> init() async {
    if (testMode || !_available) return;
    try {
      await FlameAudio.audioCache.loadAll([
        'sfx/click.wav',
        'sfx/coin.wav',
        'sfx/win.wav',
        'sfx/crash.wav',
        'sfx/engine.wav',
        'music/music.wav',
      ]);
    } catch (_) {
      _available = false;
    }
  }

  /// SFX bajao — 'coin', 'click', 'win', 'crash'.
  Future<void> playSfx(String name) async {
    if (testMode || !sfxOn || !_available) return;
    try {
      await FlameAudio.play('sfx/$name.wav');
    } catch (_) {
      _available = false;
    }
  }

  /// Background music loop shuru karo (pehli dafa).
  Future<void> startMusic() async {
    if (testMode || !musicOn || !_available) return;
    if (_musicPlayer != null) return;
    try {
      _musicPlayer = await FlameAudio.loop('music/music.wav', volume: 0.35);
    } catch (_) {
      _available = false;
    }
  }

  /// Music band karo (Settings mein off karne par).
  Future<void> stopMusic() async {
    final player = _musicPlayer;
    _musicPlayer = null;
    try {
      await player?.stop();
    } catch (_) {
      // Pehle se band hai — koi baat nahi.
    }
  }

  /// Settings se music on/off.
  Future<void> setMusicEnabled(bool on) async {
    musicOn = on;
    if (on) {
      await startMusic();
    } else {
      await stopMusic();
    }
  }

  /// Settings se SFX on/off.
  void setSfxEnabled(bool on) {
    sfxOn = on;
  }

  /// Engine ki awaz shuru karo — drive phase mein loop hoti hai.
  Future<void> startEngine() async {
    if (testMode || !sfxOn || !_available) return;
    if (_enginePlayer != null) return;
    try {
      _enginePlayer = await FlameAudio.loop('sfx/engine.wav', volume: 0.05);
    } catch (_) {
      _available = false;
    }
  }

  /// Engine ki awaz raftaar ke saath — 0 (ruka) se 1 (full speed).
  Future<void> setEngineSpeed(double normalized) async {
    final player = _enginePlayer;
    if (player == null) return;
    final volume = 0.05 + normalized.clamp(0, 1) * 0.25;
    try {
      await player.setVolume(volume);
    } catch (_) {
      // Engine player band ho gaya — ignore.
    }
  }

  /// Engine ki awaz band karo — result ya retry par.
  Future<void> stopEngine() async {
    final player = _enginePlayer;
    _enginePlayer = null;
    try {
      await player?.stop();
    } catch (_) {
      // Pehle se band hai — koi baat nahi.
    }
  }
}
