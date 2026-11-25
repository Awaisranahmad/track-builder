// Game ki tuning — gravity, camera, world settings ek jagah.
import 'package:flame/components.dart';

import 'constants.dart';

/// Game ki poori configuration — ek object, har jagah se istemal hota hai.
class GameConfig {
  const GameConfig({
    this.gravity = const _Gravity(),
    this.viewWidth = WorldSize.width,
    this.viewHeight = WorldSize.height,
    this.goldTimeSlackSeconds = 0.0,
  });

  /// Duniya ki gravity.
  final _Gravity gravity;

  /// Camera viewport ki chaudai (metre).
  final double viewWidth;

  /// Camera viewport ki unchai (metre).
  final double viewHeight;

  /// Gold time mein chhoot — playtest ke baad tune karne ke liye.
  final double goldTimeSlackSeconds;

  /// Default config — poora game isi par chalta hai.
  static const GameConfig def = GameConfig();
}

class _Gravity {
  const _Gravity();

  Vector2 get value => Vector2(0, PhysicsValues.gravityY);
}
