// Falling rock — upar se girne wala pathar (World 5/7).
// Dynamic circle: spawn point se seedha neeche girta hai.
// Gari se takraye to dhakka deta hai (snowball jaisa).
// Zameen par girne ke 2.5s baad ghayab ho jata hai;
// duniya se bahar jaye to foran remove.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'car.dart';

class FallingRockComponent extends BodyComponent with ContactCallbacks {
  FallingRockComponent({
    required this.spawn,
    required this.onHitCar,
    required this.onOutOfBounds,
  });

  /// Spawn point (metre).
  final Vector2 spawn;

  /// Gari se takrao — game ko batana (smoke + shake).
  final void Function(FallingRockComponent rock) onHitCar;

  /// Duniya se bahar / waqt khatam — game ko batana (list se hatana).
  final void Function(FallingRockComponent rock) onOutOfBounds;

  /// Ek dafa hi hit kare — dobara dhakka nahi.
  bool _hitDone = false;

  bool _outReported = false;

  /// Zameen par gira ya nahi — girne ke baad despawn timer.
  bool _landed = false;
  double _landedTimer = 0;

  /// Zameen par girne ke baad fade — 0.5 second mein.
  double _fade = 1;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: spawn.clone(),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = RockValues.radius;
    body.createFixture(
      FixtureDef(shape, density: 1.0, friction: 0.3, restitution: 0.2),
    );
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Car) {
      if (!_hitDone) {
        _hitDone = true;
        other.applyImpulse(
          Vector2(RockValues.hitImpulseX, RockValues.hitImpulseY),
        );
        onHitCar(this);
      }
      return;
    }
    // Zameen ya piece se takrao — land ho gaya.
    if (!_landed) {
      _landed = true;
      _landedTimer = RockValues.despawnAfterSeconds;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_outReported) return;
    if (_landed) {
      _landedTimer -= dt;
      if (_landedTimer <= 0) {
        _fade -= dt / 0.5;
        if (_fade <= 0) {
          _outReported = true;
          onOutOfBounds(this);
          return;
        }
      }
    }
    final pos = body.position;
    if (pos.y > WorldSize.fallFailY || pos.x > WorldSize.width + 1) {
      _outReported = true;
      onOutOfBounds(this);
    }
  }

  final _paint = Paint()..color = const Color(0xFF795548);
  final _edgePaint = Paint()
    ..color = const Color(0xFF4E342E)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.06;

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) centre hai.
    final paint = Paint()
      ..color = _paint.color.withValues(alpha: _fade.clamp(0, 1));
    canvas.drawCircle(Offset.zero, RockValues.radius, paint);
    canvas.drawCircle(Offset.zero, RockValues.radius, _edgePaint);
  }
}
