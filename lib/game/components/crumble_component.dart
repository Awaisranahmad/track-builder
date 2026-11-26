// Crumble platform — pathar ka hissa jo gari ke touch ke 1.5s
// baad toot jata hai (World 5, L56) ya lava par tairta hua pathar
// jo 3s baad doob jata hai (World 7, L78 — breakAfterSeconds se waqt).
// Tootne ke baad sensor ho jata hai aur fade ho kar ghayab hota hai.
// Terrain se alag component hai — LevelData.crumblePlatforms se banta hai.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/level_data.dart';
import '../track_builder_game.dart';
import 'car.dart';

class CrumblePlatformComponent extends BodyComponent with ContactCallbacks {
  CrumblePlatformComponent({
    required this.segment,
    this.breakAfterSeconds = CrumbleValues.breakAfterSeconds,
  });

  /// Platform ki geometry (terrain segment jaisi).
  final TerrainSegment segment;

  /// Touch ke baad tootne ka waqt (seconds).
  final double breakAfterSeconds;

  /// Tootne ka countdown — null matlab timer shuru nahi hua.
  double? _breakTimer;

  /// Toot gaya — sensor ho gaya, fade ho raha hai.
  bool _broken = false;

  /// Tootne ke baad fade — 1 se 0.
  double _fade = 1;

  /// Toot gaya ya nahi — test ke liye.
  bool get isBroken => _broken;

  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.static, userData: this);
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        segment.width / 2,
        segment.height / 2,
        Vector2(
          segment.x + segment.width / 2,
          segment.y + segment.height / 2,
        ),
        0,
      );
    body.createFixture(FixtureDef(shape, friction: 0.8));
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is! Car) return;
    if (_breakTimer == null && !_broken) {
      final game = findGame();
      if (game is TrackBuilderGame && game.phase == GamePhase.drive) {
        _breakTimer = breakAfterSeconds;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_breakTimer != null && !_broken) {
      _breakTimer = _breakTimer! - dt;
      if (_breakTimer! <= 0) {
        _breakTimer = null;
        _broken = true;
        for (final fixture in body.fixtures) {
          fixture.setSensor(true);
        }
      }
    } else if (_broken && _fade > 0) {
      _fade = (_fade - dt / CrumbleValues.fadeSeconds).clamp(0, 1);
    }
  }

  final _bodyPaint = Paint()..color = const Color(0xFF8D6E63);
  final _topPaint = Paint()..color = const Color(0xFFA1887F);
  final _crackPaint = Paint()
    ..color = const Color(0xFF4E342E)
    ..strokeWidth = 0.05
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    if (_broken && _fade <= 0) return;
    // Body transform renderTree lagata hai — local coords (body origin) par.
    final paint = Paint()
      ..color = _bodyPaint.color.withValues(alpha: _fade.clamp(0, 1));
    final rect = Rect.fromLTWH(
      segment.x,
      segment.y,
      segment.width,
      segment.height,
    );
    canvas.drawRect(rect, paint);
    canvas.drawRect(
      Rect.fromLTWH(segment.x, segment.y, segment.width, 0.25),
      _topPaint,
    );
    // Darar — tootne wala hai, ye dikhe.
    canvas.drawLine(
      Offset(segment.x + segment.width * 0.3, segment.y),
      Offset(segment.x + segment.width * 0.5, segment.y + segment.height),
      _crackPaint,
    );
  }
}
