// Camera — Phase 1 mein fixed: poora level ek screen par dikhta hai,
// taake build phase mein poori problem nazar aaye.
// Drive mein follow Phase 2 mein aayega (lambe levels ke liye).
// Phase 4: shake — crash/boost par camera halka hilta hai.
import 'dart:math' as math;

import 'package:flame/camera.dart';
import 'package:flame/components.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';

class CameraManager {
  CameraManager(this.game);

  final TrackBuilderGame game;

  final _random = math.Random();

  /// Shake ki taqat (metre) — 0 matlab koi shake nahi.
  double _shakeAmount = 0;

  /// Shake kitni der aur chale (seconds).
  double _shakeTimeLeft = 0;

  /// Fixed resolution viewport — har screen par duniya ek jaisi dikhe.
  void setupFixedCamera() {
    game.camera.viewport = FixedResolutionViewport(
      resolution: Vector2(WorldSize.width, WorldSize.height),
    );
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2.zero();
  }

  /// Camera hilao — crash par zyada, boost par halka.
  void shake({double amount = EffectsValues.shakeAmountMetres}) {
    _shakeAmount = amount;
    _shakeTimeLeft = EffectsValues.shakeDurationSeconds;
  }

  /// Har frame — shake chal raha ho to viewfinder ko random offset do.
  void update(double dt) {
    if (_shakeTimeLeft <= 0) return;
    _shakeTimeLeft -= dt;
    if (_shakeTimeLeft <= 0) {
      _shakeAmount = 0;
      game.camera.viewfinder.position = Vector2.zero();
      return;
    }
    final fade = _shakeTimeLeft / EffectsValues.shakeDurationSeconds;
    game.camera.viewfinder.position = Vector2(
      (_random.nextDouble() * 2 - 1) * _shakeAmount * fade,
      (_random.nextDouble() * 2 - 1) * _shakeAmount * fade,
    );
  }

  /// Shake chal raha hai ya nahi — test ke liye.
  bool get isShaking => _shakeTimeLeft > 0;
}
