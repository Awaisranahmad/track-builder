// Lava geyser — zameen se lava ka column cycle par phoot-ta hai.
// Active ho to column sensor hai — gari chhooye to foran fail (lava).
// Inactive ho to column ghayab (sirf chhota sa crater dikhta hai).
// Cycle sirf drive phase mein chalta hai (GO par deterministic).
// Fairness: geyser ki timing cycle se pehle se dikhti hai.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';
import 'car.dart';

class GeyserComponent extends BodyComponent with ContactCallbacks {
  GeyserComponent({
    required this.x,
    required this.groundY,
    this.height = 3.0,
    this.cycleSeconds = 3.0,
    this.activeSeconds = 1.0,
    required this.onCarTouched,
  });

  /// Column ki x position (metre).
  final double x;

  /// Zameen ki satah y (metre) — column yahin se phoot-ta hai.
  final double groundY;

  /// Column ki unchai (metre).
  final double height;

  /// Poora cycle (seconds).
  final double cycleSeconds;

  /// Cycle ke shuru mein kitni der active rehta hai (seconds).
  final double activeSeconds;

  /// Gari active column chhooye — game ko batana (fail).
  final void Function() onCarTouched;

  /// Cycle mein kitna waqt guzra.
  double _elapsed = 0;

  /// Ek active daur mein ek dafa hi fail kare.
  bool _hitDone = false;

  /// Abhi active hai ya nahi — test/UI ke liye.
  bool get isActive {
    final phase = _elapsed % cycleSeconds;
    return phase < activeSeconds;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2(x, groundY - height / 2),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        GeyserValues.columnWidth / 2,
        height / 2,
        Vector2.zero(),
        0,
      );
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Car && isActive && !_hitDone) {
      _hitDone = true;
      onCarTouched();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Cycle sirf drive phase mein — GO par deterministic.
    final game = findGame();
    if (game is! TrackBuilderGame || game.phase != GamePhase.drive) {
      return;
    }
    final wasActive = isActive;
    _elapsed += dt;
    if (!wasActive && isActive) {
      // Naya active daur — hit dobara armed.
      _hitDone = false;
    }
  }

  final _lavaPaint = Paint()..color = const Color(0xFFFF5722);
  final _craterPaint = Paint()..color = const Color(0xFF4E342E);

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) column ka centre hai.
    if (isActive) {
      canvas.drawRect(
        Rect.fromLTWH(
          -GeyserValues.columnWidth / 2,
          -height / 2,
          GeyserValues.columnWidth,
          height,
        ),
        _lavaPaint,
      );
    } else {
      // Crater — chhota sa gadha, geyser yahan se aayega.
      canvas.drawRect(
        Rect.fromLTWH(-0.4, height / 2 - 0.15, 0.8, 0.15),
        _craterPaint,
      );
    }
  }
}
