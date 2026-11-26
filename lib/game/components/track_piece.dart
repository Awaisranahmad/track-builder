// Player ka lagaya hua piece — Road, Ramp, Bridge ya Booster.
// Build phase mein ye sirf sensor hota hai (gari se takrata nahi),
// GO dabane par solid ho jata hai. Retry par dobara sensor.
// Booster hamesha sensor rehta hai: gari guzre to raftaar milti hai.
// Shakal Phase 4 se sprite hai — load na ho to purani shape drawing.
// Bridge: gari upar ho to halka jhukta hai (visual sag, physics wahi).
// L34 (Thin Ice): bridge 2s baad toot jata hai — hazard, data se aata hai.
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/piece_type.dart';
import '../../services/sprite_service.dart';
import '../track_builder_game.dart';
import 'car.dart';

class TrackPiece extends BodyComponent with ContactCallbacks {
  TrackPiece({
    required this.type,
    required this.pieceCenter,
    this.angleDegrees = 0,
    this.surface = SurfaceType.normal,
    this.breakAfterSeconds,
  }) {
    paint = Paint()..color = type.color;
  }

  final PieceType type;

  /// Piece ka centre (metre, world coords).
  final Vector2 pieceCenter;

  /// Rotation — degree mein. Ramp ka default -30 (upar ki taraf).
  double angleDegrees;

  /// Level ki surface — ice par piece bhi phisalta hai.
  final SurfaceType surface;

  /// Bridge tootne ka timer (seconds) — L34 jaisi hazard levels ke liye.
  /// null matlab kabhi nahi toot-ta. LevelData.hazards se aata hai.
  final double? breakAfterSeconds;

  /// Booster ne is drive mein boost de diya — ek drive mein ek dafa.
  bool _boosted = false;

  /// Bridge tootne ka countdown — null matlab timer shuru nahi hua.
  double? _breakTimer;

  /// Bridge toot gaya — sensor ho gaya, fade ho raha hai.
  bool _broken = false;

  /// Tootne ke baad fade — 1 se 0 (0.4 second mein).
  double _breakFade = 1;

  /// Phase 4 sprite — load na ho to null, phir shape drawing.
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final path = switch (type) {
      PieceType.road => SpritePaths.road,
      PieceType.ramp => SpritePaths.ramp,
      PieceType.bridge => SpritePaths.bridge,
      PieceType.booster => SpritePaths.booster,
      _ => null,
    };
    if (path != null) {
      _sprite = await SpriteService.load(path);
    }
  }

  /// Is piece ko lagane par kitne grid cells ghere — placement ke liye.
  double get length => type.length;

  /// Bridge toot gaya ya nahi — test ke liye.
  bool get isBroken => _broken;

  @override
  Body createBody() {
    final angle = type == PieceType.ramp && angleDegrees == 0
        ? -PieceValues.rampDefaultAngleDegrees * math.pi / 180
        : angleDegrees * math.pi / 180;
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      angle: angle,
      userData: this,
    );
    final body = world.createBody(bodyDef);
    if (type == PieceType.booster) {
      // Booster sensor zameen se upar tak phaila hai (0.8m uncha)
      // taake gari ke wheels us se takrayen — sirf patli pad
      // sensor hoti to wheel us ke upar se guzar jata.
      final shape = PolygonShape()
        ..setAsBox(
          type.length / 2,
          0.4,
          Vector2(0, -0.4),
          0,
        );
      body.createFixture(FixtureDef(shape, isSensor: true));
      return body;
    }
    // Trapezoid — upar ki satah poori lambai (zameen se flush, koi dip nahi),
    // neeche ke kinare andar ki taraf dhalwan: wheel thoda neeche dabe to
    // bhi dhalwan use upar dhakel deti hai, vertical edge se nahi takrata.
    // Winding setAsBox jaisi hai: top-left → top-right → bottom-right → bottom-left.
    final hl = type.length / 2;
    final ht = type.thickness / 2;
    final c = PieceValues.edgeChamfer;
    final shape = PolygonShape()
      ..set([
        Vector2(-hl, -ht),
        Vector2(hl, -ht),
        Vector2(hl - c, ht),
        Vector2(-hl + c, ht),
      ]);
    // Shuru mein sensor — build phase mein gari se takraye baghair.
    body.createFixture(
      FixtureDef(
        shape,
        friction: SurfaceValues.terrainFriction(surface),
        isSensor: true,
      ),
    );
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is! Car) return;
    if (type == PieceType.booster) {
      if (_boosted) return;
      _boosted = true;
      other.applyBoost(PhysicsValues.boosterTargetSpeed);
      final game = findGame();
      if (game is TrackBuilderGame && game.phase == GamePhase.drive) {
        game.onBoost(other.position);
      }
      return;
    }
    // Bridge-break hazard — drive mein gari ke pehle touch par timer.
    if (type == PieceType.bridge &&
        breakAfterSeconds != null &&
        _breakTimer == null &&
        !_broken) {
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
        _breakFade = 1;
        // Sensor ho jaye — makeGhost() nahi, wo _broken wapas false kar dega.
        _wantSolid = false;
        if (isMounted) _applyGhost();
        final game = findGame();
        if (game is TrackBuilderGame) {
          game.onBridgeBroke(this);
        }
      }
    } else if (_broken && _breakFade > 0) {
      _breakFade = (_breakFade - dt / 0.4).clamp(0, 1);
    }
  }

  /// GO dabane par chahiye ya nahi — body async banta hai, is liye
  /// flag mein rakho; body banne par onMount mein lag jayega.
  bool _wantSolid = false;

  @override
  void onMount() {
    super.onMount();
    if (_wantSolid) _applySolid();
  }

  /// GO dabane par — piece solid ho jaye, gari is par chale.
  /// Booster hamesha sensor rehta hai — solid nahi hota.
  void makeSolid() {
    if (type == PieceType.booster) return;
    _wantSolid = true;
    _breakTimer = null;
    _broken = false;
    _breakFade = 1;
    if (isMounted) _applySolid();
  }

  /// Retry / build mein wapas — dobara sensor.
  /// Booster dobara armed ho jata hai (agli drive mein phir boost dega).
  void makeGhost() {
    _boosted = false;
    _wantSolid = false;
    _breakTimer = null;
    _broken = false;
    _breakFade = 1;
    if (isMounted) _applyGhost();
  }

  void _applySolid() {
    for (final fixture in body.fixtures) {
      fixture.setSensor(false);
    }
  }

  void _applyGhost() {
    for (final fixture in body.fixtures) {
      fixture.setSensor(true);
    }
  }

  /// Tap par rotate — 15 degree ke step mein.
  void rotate() {
    angleDegrees += PieceValues.rotateStepDegrees;
    if (angleDegrees > 90) angleDegrees -= 180;
    body.setTransform(
      body.position,
      angleDegrees * math.pi / 180,
    );
  }

  /// Tap point is piece ke andar hai ya nahi — hit test ke liye.
  @override
  bool containsPoint(Vector2 point) {
    final dx = point.x - pieceCenter.x;
    final dy = point.y - pieceCenter.y;
    final angle = angleDegrees * math.pi / 180;
    // Point ko piece ke local frame mein lao (rotation ulta karo).
    final localX = dx * math.cos(angle) + dy * math.sin(angle);
    final localY = -dx * math.sin(angle) + dy * math.cos(angle);
    return localX.abs() <= type.length / 2 + 0.2 &&
        localY.abs() <= type.thickness / 2 + 0.3;
  }

  /// Bridge par gari ho to kitna jhuke (metre) — sirf visual, physics wahi.
  double _bridgeSag() {
    if (type != PieceType.bridge || _broken) return 0;
    final game = findGame();
    if (game is! TrackBuilderGame) return 0;
    try {
      final carPos = game.car.position;
      final hl = type.length / 2;
      final topY = pieceCenter.y - type.thickness / 2;
      final dx = (carPos.x - pieceCenter.x).abs();
      final dy = carPos.y - topY;
      if (dx > hl || dy < -1.0 || dy > 0.5) return 0;
      return 0.12 * (1 - dx / hl);
    } catch (_) {
      return 0;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_broken && _breakFade <= 0) return;
    final sprite = _sprite;
    final fadePaint = Paint()
      ..color = Colors.white.withValues(alpha: _breakFade);

    if (type == PieceType.booster) {
      if (sprite != null) {
        sprite.render(
          canvas,
          position: Vector2(-0.5, -0.15),
          size: Vector2(1.0, 0.15),
          overridePaint: fadePaint,
        );
        return;
      }
      // Fallback — cyan pad + chevrons (purana drawing).
      canvas.drawRect(
        const Rect.fromLTWH(-0.5, -0.15, 1.0, 0.15),
        paint,
      );
      final chevronPaint = Paint()..color = Colors.white;
      for (var i = 0; i < 2; i++) {
        final x = -0.3 + i * 0.3;
        final path = Path()
          ..moveTo(x, -0.13)
          ..lineTo(x + 0.12, -0.075)
          ..lineTo(x, -0.02)
          ..lineTo(x + 0.05, -0.075)
          ..close();
        canvas.drawPath(path, chevronPaint);
      }
      return;
    }

    final sag = _bridgeSag();
    if (sprite != null) {
      if (type == PieceType.bridge && sag > 0.005) {
        _renderBridgeSag(canvas, sprite, sag, fadePaint);
      } else {
        sprite.render(
          canvas,
          position: Vector2(-type.length / 2, -type.thickness / 2),
          size: Vector2(type.length, type.thickness),
          overridePaint: fadePaint,
        );
      }
      return;
    }

    // Fallback — shape drawing (sprite load na ho to).
    if (type == PieceType.bridge && sag > 0.005) {
      _renderBridgeShapeSag(canvas, sag);
      return;
    }
    super.render(canvas);
  }

  /// Bridge sprite — 3 hisso mein, beech wala hissa sag jitna neeche.
  void _renderBridgeSag(
    Canvas canvas,
    Sprite sprite,
    double sag,
    Paint paint,
  ) {
    final image = sprite.image;
    final w = image.width.toDouble();
    final h = image.height.toDouble();
    final third = type.length / 3;
    final ht = type.thickness / 2;
    for (var i = 0; i < 3; i++) {
      final drop = i == 1 ? sag : 0.0;
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(w * i / 3, 0, w / 3, h),
        Rect.fromLTWH(
          -type.length / 2 + third * i,
          -ht + drop,
          third,
          type.thickness,
        ),
        paint,
      );
    }
  }

  /// Bridge shape — upar ki edge curve ke saath (sprite na ho to).
  void _renderBridgeShapeSag(Canvas canvas, double sag) {
    final hl = type.length / 2;
    final ht = type.thickness / 2;
    final c = PieceValues.edgeChamfer;
    final path = Path()
      ..moveTo(-hl, -ht)
      ..quadraticBezierTo(0, -ht + sag * 2, hl, -ht)
      ..lineTo(hl - c, ht)
      ..lineTo(-hl + c, ht)
      ..close();
    canvas.drawPath(path, paint);
  }
}
