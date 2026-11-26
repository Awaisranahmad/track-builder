// Wind zone — hawa ka ilaka, gusts par gari ko dhakelti hai.
// Zone ek sensor rectangle hai; gust cycle par on/off hoti hai.
// Gust on ho aur gari zone ke andar ho to game har frame
// applyForce bulata hai (Car.applyForce — chassis par force).
// Flags se timing dikhti hai (render mein jhande + hawa ki lines).
// Cycle sirf drive phase mein chalta hai (GO par deterministic).
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';
import 'car.dart';

class WindComponent extends BodyComponent with ContactCallbacks {
  WindComponent({
    required this.x,
    required this.y,
    required this.width,
    this.height = 5.0,
    this.cycleSeconds = 4.0,
    this.gustSeconds = 2.0,
    this.strength = 1.0,
  });

  /// Zone ka bayein kinara (metre).
  final double x;

  /// Zone ki upar wali y (metre).
  final double y;

  /// Zone ki chaudai (metre).
  final double width;

  /// Zone ki unchai (metre).
  final double height;

  /// Poora cycle (seconds).
  final double cycleSeconds;

  /// Gust ki lambai (seconds) — cycle ke shuru mein.
  final double gustSeconds;

  /// Direction — +1 dahine, -1 bayein.
  final double strength;

  /// Cycle mein kitna waqt guzra.
  double _elapsed = 0;

  /// Gari zone ke andar hai ya nahi.
  bool _carInside = false;

  /// Abhi gust chal rahi hai ya nahi — test/UI ke liye.
  bool get isGusting {
    final phase = _elapsed % cycleSeconds;
    return phase < gustSeconds;
  }

  /// Gari zone ke andar hai — test ke liye.
  bool get carInside => _carInside;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2(x + width / 2, y + height / 2),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(width / 2, height / 2, Vector2.zero(), 0);
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Car) _carInside = true;
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is Car) _carInside = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Cycle sirf drive phase mein — GO par deterministic.
    final game = findGame();
    if (game is! TrackBuilderGame || game.phase != GamePhase.drive) {
      return;
    }
    _elapsed += dt;
    // Gust on ho aur gari andar ho to dhakka do.
    if (_carInside && isGusting) {
      game.car.applyForce(
        Vector2(WindValues.pushForce * strength, 0),
      );
    }
  }

  final _zonePaint = Paint()..color = const Color(0x1A2196F3);
  final _flagPaint = Paint()..color = const Color(0xFFFF5722);

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) zone ka centre hai.
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: width,
        height: height,
      ),
      _zonePaint,
    );
    // Jhanda — gust ho to seedha, warna latka hua.
    final flagAngle = isGusting ? 0.0 : 0.6;
    canvas.save();
    canvas.translate(-width / 2 + 0.2, -height / 2 + 0.2);
    canvas.rotate(flagAngle * strength);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 0.5, 0.08),
      _flagPaint,
    );
    canvas.restore();
    // Hawa ki lines — gust ho to dikhen.
    if (isGusting) {
      final linePaint = Paint()
        ..color = const Color(0xFF2196F3)
        ..strokeWidth = 0.05;
      for (var i = 0; i < 3; i++) {
        final y = -height / 4 + i * height / 4;
        canvas.drawLine(
          Offset(-width / 2 + 0.3, y),
          Offset(width / 2 - 0.3, y),
          linePaint,
        );
      }
    }
  }
}
