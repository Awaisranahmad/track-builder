// Coin — sensor body: gari guzre to collect ho, physics par asar nahi.
// Phase 4: sprite + spin (ghumta hua sikka) — load na ho to purane circles.
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../services/sprite_service.dart';
import 'car.dart';

class CoinComponent extends BodyComponent with ContactCallbacks {
  CoinComponent({required this.x, required this.y, required this.onCollected});

  final double x;
  final double y;

  /// Game ko batana ke coin collect hua.
  final void Function(CoinComponent coin) onCollected;

  bool collected = false;

  /// Spin ka angle — ghumta hua sikka.
  double _spin = 0;

  /// Phase 4 sprite — load na ho to null, phir circles.
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _sprite = await SpriteService.load(SpritePaths.coin);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!collected) _spin += dt * 3;
  }

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
    final sprite = _sprite;
    if (sprite != null) {
      // Spin — x scale cos se, sikka ghumta hua lage.
      final r = PieceValues.coinRadius;
      canvas.save();
      canvas.scale(math.cos(_spin).abs() * 0.9 + 0.1, 1);
      sprite.render(
        canvas,
        position: Vector2(-r, -r),
        size: Vector2(r * 2, r * 2),
      );
      canvas.restore();
      return;
    }
    canvas.drawCircle(Offset.zero, PieceValues.coinRadius, _paint);
    canvas.drawCircle(Offset.zero, PieceValues.coinRadius, _edgePaint);
    canvas.drawCircle(
      Offset.zero,
      PieceValues.coinRadius * 0.45,
      Paint()..color = const Color(0xFFFFF176),
    );
  }
}
