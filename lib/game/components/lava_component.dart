// Lava zone — sensor rectangle; gari chhooye to foran fail.
// Rising lava: satah waqt ke saath upar aati hai (L80).
// Visual: narangi/lal rect, upar ki satah halki chamakti hai.
// Fail game ko callback se batata hai — DriveManager.fail('lava').
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../track_builder_game.dart';
import 'car.dart';

class LavaComponent extends BodyComponent with ContactCallbacks {
  LavaComponent({
    required this.x,
    required this.topY,
    required this.width,
    this.riseRate = 0,
    required this.onCarTouched,
  });

  /// Zone ka bayein kinara (metre).
  final double x;

  /// Satah ki shuru ki y (metre) — neeche ki taraf barhti hai.
  final double topY;

  /// Zone ki chaudai (metre).
  final double width;

  /// Satah kitni tez upar aaye (metre/second) — 0 matlab static lava.
  final double riseRate;

  /// Gari lava chhooye — game ko batana (fail).
  final void Function() onCarTouched;

  /// Abhi ki satah y — rising lava mein waqt ke saath kam hoti hai.
  double _currentTopY = 0;

  /// Kitna waqt guzra (GO ke baad) — rising lava ke liye.
  double _elapsed = 0;

  /// Gari ne chhoo liya — dobara fail nahi.
  bool _touched = false;

  final _lavaPaint = Paint()..color = const Color(0xFFFF5722);
  final _surfacePaint = Paint()..color = const Color(0xFFFFC107);

  @override
  Body createBody() {
    _currentTopY = topY;
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2(x + width / 2, topY + 1),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    // Sensor rect: upar ki satah se 2m neeche tak.
    final shape = PolygonShape()
      ..setAsBox(width / 2, 1, Vector2.zero(), 0);
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  /// Abhi ki satah y — test ke liye.
  double get currentTopY => _currentTopY;

  @override
  void update(double dt) {
    super.update(dt);
    if (riseRate > 0) {
      // Sirf drive phase mein upar aaye — build mein satah waisi hi.
      final game = findGame();
      if (game is! TrackBuilderGame || game.phase != GamePhase.drive) {
        return;
      }
      _elapsed += dt;
      _currentTopY = topY - riseRate * _elapsed;
      body.setTransform(
        Vector2(x + width / 2, _currentTopY + 1),
        0,
      );
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (_touched) return;
    if (other is Car) {
      _touched = true;
      onCarTouched();
    }
  }

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) body centre hai.
    canvas.drawRect(
      Rect.fromLTWH(-width / 2, -1, width, 2),
      _lavaPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(-width / 2, -1, width, 0.15),
      _surfacePaint,
    );
  }
}
