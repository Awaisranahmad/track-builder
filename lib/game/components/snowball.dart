// Snowball — L35 Avalanche Alley ka hazard (Phase 4).
// Dynamic circle body: spawn point se girta hai, dhalwan par ludhakta
// hua raasta kaatta hai. Gari se takraye to dhakka deta hai (fail
// sirf flip/fall/stuck rules se hota hai — snowball khud fail nahi karta).
// Duniya se bahar jaye to khud remove ho jata hai; game naya gola
// spawn karta hai (interval LevelHazard se).
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'car.dart';

class SnowballComponent extends BodyComponent with ContactCallbacks {
  SnowballComponent({
    required this.spawn,
    required this.onHitCar,
    required this.onOutOfBounds,
  });

  /// Spawn point (metre).
  final Vector2 spawn;

  /// Gari se takrao — game ko batana (smoke + shake).
  final void Function(SnowballComponent snowball) onHitCar;

  /// Duniya se bahar — game ko batana (list se hatana).
  final void Function(SnowballComponent snowball) onOutOfBounds;

  /// Ek dafa hi hit kare — dobara dhakka nahi.
  bool _hitDone = false;

  bool _outReported = false;

  static const double radius = 0.5;

  final _paint = Paint()..color = const Color(0xFFF4FAFD);
  final _edgePaint = Paint()
    ..color = const Color(0xFFB9D3E0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.06;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: spawn.clone(),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = radius;
    body.createFixture(
      FixtureDef(shape, density: 1.0, friction: 0.3, restitution: 0.2),
    );
    // Halki si leftward shuruaat — dhalwan par ludhakna shuru kare.
    body.linearVelocity = Vector2(-0.5, 0);
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (_hitDone) return;
    if (other is Car) {
      _hitDone = true;
      other.applyImpulse(Vector2(-1.2, -0.8));
      onHitCar(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_outReported) return;
    final pos = body.position;
    if (pos.y > WorldSize.fallFailY || pos.x > WorldSize.width + 1) {
      _outReported = true;
      onOutOfBounds(this);
    }
  }

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) centre hai.
    canvas.drawCircle(Offset.zero, radius, _paint);
    canvas.drawCircle(Offset.zero, radius, _edgePaint);
    canvas.drawCircle(
      const Offset(-0.15, -0.15),
      0.08,
      Paint()..color = const Color(0xFFB9D3E0),
    );
    canvas.drawCircle(
      const Offset(0.18, 0.12),
      0.06,
      Paint()..color = const Color(0xFFB9D3E0),
    );
  }
}
