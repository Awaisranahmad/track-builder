// Coin — sensor body: gari guzre to collect ho, physics par asar nahi.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'car.dart';

class CoinComponent extends BodyComponent with ContactCallbacks {
  CoinComponent({required this.x, required this.y, required this.onCollected});

  final double x;
  final double y;

  /// Game ko batana ke coin collect hua.
  final void Function(CoinComponent coin) onCollected;

  bool collected = false;

  final _paint = Paint()..color = GameColors.coin;
  final _edgePaint = Paint()
    ..color = const Color(0xFFFF8F00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.06;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2(x, y),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = PieceValues.coinRadius;
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (collected) return;
    if (other is Car) {
      collected = true;
      onCollected(this);
    }
  }

  /// Retry par coin dobara dikhao.
  void reset() {
    collected = false;
  }

  @override
  void render(Canvas canvas) {
    if (collected) return;
    // Body transform renderTree lagata hai — (0,0) coin ka centre hai.
    canvas.drawCircle(Offset.zero, PieceValues.coinRadius, _paint);
    canvas.drawCircle(Offset.zero, PieceValues.coinRadius, _edgePaint);
    canvas.drawCircle(
      Offset.zero,
      PieceValues.coinRadius * 0.45,
      Paint()..color = const Color(0xFFFFF176),
    );
  }
}
