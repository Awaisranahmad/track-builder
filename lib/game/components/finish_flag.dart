// Finish flag — sensor zone: gari andar aaye to level complete.
// Chequered flag chhote squares se bana hai (prototype, koi image nahi).
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'car.dart';

class FinishFlagComponent extends BodyComponent with ContactCallbacks {
  FinishFlagComponent({
    required this.x,
    required this.onFinished,
  });

  /// Finish line ki x position (metre).
  final double x;

  final void Function() onFinished;

  bool _triggered = false;

  final _polePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.08;
  final _blackPaint = Paint()..color = GameColors.finish;
  final _whitePaint = Paint()..color = Colors.white;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2(x, WorldSize.groundTop - PieceValues.finishZoneHeight / 2),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        PieceValues.finishZoneWidth / 2,
        PieceValues.finishZoneHeight / 2,
        Vector2.zero(),
        0,
      );
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (_triggered) return;
    if (other is Car) {
      _triggered = true;
      onFinished();
    }
  }

  /// Dobara khelne par flag dobara active karo.
  void reset() {
    _triggered = false;
  }

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) zone ka centre hai.
    const poleHeight = 3.0;
    // Pole — zameen se upar.
    canvas.drawLine(
      const Offset(0, poleHeight / 2),
      const Offset(0, -poleHeight / 2),
      _polePaint,
    );
    // Chequered flag — 4x2 squares, pole ke upar.
    const square = 0.25;
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 4; col++) {
        final paint = (row + col) % 2 == 0 ? _blackPaint : _whitePaint;
        canvas.drawRect(
          Rect.fromLTWH(col * square, -poleHeight / 2 + row * square, square, square),
          paint,
        );
      }
    }
  }
}
