// Player ka lagaya hua piece — Road, Ramp, Bridge, Booster, Loop,
// Spring, See-Saw ya Magnet.
// Build phase mein ye sirf sensor hota hai (gari se takrata nahi),
// GO dabane par solid ho jata hai. Retry par dobara sensor.
// Booster aur Spring hamesha sensor rehte hain: gari guzre to
// raftaar / bounce milta hai. Magnet bhi sensor hai — zone ke
// andar gravity kam ho jati hai.
// Shakal Phase 4 se sprite hai — load na ho to purani shape drawing.
// Bridge: gari upar ho to halka jhukta hai (visual sag, physics wahi).
// L34 (Thin Ice): bridge 2s baad toot jata hai — hazard, data se aata hai.
// L74 (Hot Bridge): bridge gari ke wazan se ahista neeche dhansta hai.
// Loop: ring ke andar gari poora chakkar lagati hai — is dauran
// flip check rukta hai (Car.setInLoop), bahar nikalte hi angle
// normalize ho jata hai.
// See-Saw: dynamic plank, pivot par revolute joint — gari ka wazan
// use jhukata hai. Build phase mein frozen rehti hai.
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
    this.sinkRate,
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

  /// Bridge dhansne ki raftaar (metre/second) — L74 jaisi levels.
  /// null matlab nahi dhansta. LevelData.hazards se aata hai.
  final double? sinkRate;

  /// Booster ne is drive mein boost de diya — ek drive mein ek dafa.
  bool _boosted = false;

  /// Bridge tootne ka countdown — null matlab timer shuru nahi hua.
  double? _breakTimer;

  /// Bridge toot gaya — sensor ho gaya, fade ho raha hai.
  bool _broken = false;

  /// Tootne ke baad fade — 1 se 0 (0.4 second mein).
  double _breakFade = 1;

  /// Sinking bridge: gari abhi is par hai (contact count).
  int _carTouching = 0;

  /// See-Saw: pivot ka anchor body + joint (sirf seesaw ke liye).
  Body? _seesawAnchor;
  Joint? _seesawJoint;

  /// Phase 4/5 sprite — load na ho to null, phir shape drawing.
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final path = switch (type) {
      PieceType.road => SpritePaths.road,
      PieceType.ramp => SpritePaths.ramp,
      PieceType.bridge => SpritePaths.bridge,
      PieceType.booster => SpritePaths.booster,
      PieceType.loop => SpritePaths.loop,
      PieceType.spring => SpritePaths.spring,
      PieceType.seesaw => SpritePaths.seesaw,
      PieceType.magnet => SpritePaths.magnet,
    };
    _sprite = await SpriteService.load(path);
  }

  /// Is piece ko lagane par kitne grid cells ghere — placement ke liye.
  double get length => type.length;

  /// Bridge toot gaya ya nahi — test ke liye.
  bool get isBroken => _broken;

  /// See-Saw kitni jhuki hai (radians) — test ke liye.
  double get seesawAngle => type == PieceType.seesaw ? body.angle : 0;

  /// Wo fixtures jo GO par solid hote hain — sensor fixtures
  /// (booster/spring/magnet/loop-detector) hamesha sensor rehte hain.
  final List<Fixture> _solidFixtures = [];
  Fixture? _loopEntryRampFixture;

  @override
  Body createBody() {
    switch (type) {
      case PieceType.booster:
      case PieceType.spring:
        return _createSensorPadBody();
      case PieceType.magnet:
        return _createMagnetZoneBody();
      case PieceType.loop:
        return _createLoopBody();
      case PieceType.seesaw:
        return _createSeesawBody();
      case PieceType.road:
      case PieceType.ramp:
      case PieceType.bridge:
        return _createPlankBody();
    }
  }

  /// Booster / Spring — sensor pad (0.8m uncha), gari guzre to effect.
  Body _createSensorPadBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      userData: this,
    );
    final body = world.createBody(bodyDef);
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

  /// Magnet zone — sensor rectangle (2m x 5m), gari andar ho to gravity kam.
  Body _createMagnetZoneBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        MagnetValues.zoneWidth / 2,
        MagnetValues.zoneHeight / 2,
        Vector2.zero(),
        0,
      );
    body.createFixture(FixtureDef(shape, isSensor: true));
    return body;
  }

  /// Loop — entry ramp + circle arc + exit ramp (Phase 5, probe se).
  /// Seedha circle nahi chalta: ChainShape two-sided hoti hai
  /// (forge2d ka collideEdgeAndCircle normal ko circle ki taraf
  /// flip karta hai) — gari ring ki bahar wali face se takra kar
  /// wapas uchhalti aur ulta hoti thi (probe se verify).
  /// Is liye entry ramp (30° trapezoid slab, Ramp piece jaisa)
  /// gari ko zameen se circle ke gap point tak le jata hai:
  /// gari ramp se upar-right uchhalti hai, ring ki ANDAR wali
  /// satah pakar kar poora chakkar lagati hai, aur left gap
  /// point se wapas zameen par utarti hai.
  /// Circle ka centre zameen (y=9.0) se 2.0m upar hona chahiye
  /// (tap y=7.0) — ramp usi hisab se banta hai; centre neeche
  /// ho to ramp chhota par jata hai aur wheel arc se takrata hai.
  /// Plus andar ka sensor circle (flip check ke liye).
  Body _createLoopBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final radius = LoopValues.radius;
    // Circle arc: gap ke bahar (gap neeche 60°-120° hai, y neeche ki taraf).
    // Arc theta=120° se shuru ho kar 420° (=60°) tak jata hai.
    // Arc gapEnd (120 deg) se nahi, arcStartDegrees (150 deg) se shuru:
    // wheel ka rasta ring ko ~134 deg par kaat-ta hai — 120 deg gap mein
    // woh arc se takrata tha (probe). Ramp gapEnd par hi khatam hota hai.
    final arcStart = LoopValues.arcStartDegrees * math.pi / 180;
    final arcSpan = 2 * math.pi -
        (LoopValues.arcStartDegrees - LoopValues.gapStartDegrees) *
            math.pi /
            180;
    final segmentAngle = arcSpan / LoopValues.arcSegments;

    // Circle point (local coords) — theta se.
    Vector2 circlePoint(double theta) {
      return Vector2(radius * math.cos(theta), radius * math.sin(theta));
    }

    // Sirf ENTRY ramp — trapezoid slab, zameen se circle ke left gap
    // point tak. Shuru mein sensor — GO par solid hota hai.
    // Exit ramp NAHI hai: car loop ke baad zameen par ring ke neeche se
    // guzar kar finish jati hai (gap 30°-150° itna khula hai ke gari ki
    // chhat arc ends se neeche rehti hai). Exit ramp solid hota to woh
    // ground path block kar deta.
    // Entry ramp loop enter hote hi GHOST ho jata hai (neeche beginContact
    // mein) — taake car exit ke baad us se guzar kar right ja sake.
    final corners = _loopRampCorners(entry: true);
    final shape = PolygonShape()..set(corners);
    _loopEntryRampFixture = body.createFixture(
      FixtureDef(
        shape,
        friction: SurfaceValues.terrainFriction(surface),
        isSensor: true,
      ),
    );
    _solidFixtures.add(_loopEntryRampFixture!);

    // Circle arc chain (gap ke bahar).
    // Vertex order ulta hai (420° se 120° tak) — taake chain ka
    // normal ring ke ANDAR ki taraf ho: chain sirf andar wali
    // satah se takraye, bahar se gari guzar jaye (gap se dakhil ho).
    // Seedha order (120° se 420°) mein normal bahar ki taraf tha —
    // gari gap par arc ki bahar wali face se takra kar wapas
    // uchhalti thi (probe se verify).
    final vertices = <Vector2>[];
    for (var i = 0; i <= LoopValues.arcSegments; i++) {
      vertices.add(circlePoint(arcStart + arcSpan - i * segmentAngle));
    }
    // Arc sensor hi rehta hai (kabhi solid nahi hota) — "ring jump".
    // Wajah (probe se verify): ChainShape two-sided hoti hai (forge2d),
    // is liye solid arc ki bahar wali face gari ki chassis (1.3m lambi)
    // se entry par takra kar use wapas uchhalti aur ulta karti hai;
    // arc ko do hisson mein split kar ke bhi gari poora loop nahi kar
    // pati (chain ke joint par atak kar speed kho deti hai, phir
    // neeche gir kar ulta ho jati hai). Sensor arc par gari booster se
    // ring ke andar se guzar kar finish tak jati hai — booster baghair
    // raftaar kam hoti hai aur gari exit ramp par atak kar fail hoti hai
    // (design doc: "entry speed above a threshold"). Asli loop-the-loop
    // (poora chakkar) ke liye one-sided arc chahiye — future work.
    final chain = ChainShape()..createChain(vertices);
    body.createFixture(
      FixtureDef(
        chain,
        friction: SurfaceValues.terrainFriction(surface),
        isSensor: true,
      ),
    );
    // Sensor circle — ring se thoda bara, taake gari poora loop
    // is ke andar rahe (top par bhi).
    final sensorShape = CircleShape()
      ..radius = radius + 0.15;
    body.createFixture(FixtureDef(sensorShape, isSensor: true));
    return body;
  }

  /// Loop ke entry/exit ramp ke 4 kone (local coords) — physics
  /// aur render dono yahi istemal karte hain.
  /// Ramp 30° ka hai: zameen (groundLocalY) se circle ke gap point
  /// (theta=120° entry, 60° exit) tak; neeche ka kinara motai
  /// (rampThickness) tak zameen ke andar dhasa hota hai, taake
  /// ramp ke neeche koi khali jagah na rahe.
  List<Vector2> _loopRampCorners({required bool entry}) {
    final radius = LoopValues.radius;
    final groundLocalY = WorldSize.groundTop - pieceCenter.y;
    final gapRadians = LoopValues.gapEndDegrees * math.pi / 180;
    final joinY = radius * math.sin(gapRadians);
    final joinX = radius * math.cos(gapRadians).abs();
    final rampAngle = LoopValues.rampAngleDegrees * math.pi / 180;
    final span = (groundLocalY - joinY) / math.tan(rampAngle);
    final thickness = LoopValues.rampThickness;
    if (entry) {
      // Zameen se gap point tak, upar-right.
      final a = Vector2(-joinX - span, groundLocalY);
      final b = Vector2(-joinX, joinY);
      final normal = Vector2(math.sin(rampAngle), math.cos(rampAngle));
      return [a, b, b + normal * thickness, a + normal * thickness];
    }
    // Gap point se zameen tak, neeche-right (entry ka mirror).
    final c = Vector2(joinX, joinY);
    final d = Vector2(joinX + span, groundLocalY);
    final normal = Vector2(-math.sin(rampAngle), math.cos(rampAngle));
    return [c, d, d + normal * thickness, c + normal * thickness];
  }

  /// See-Saw — dynamic plank + pivot anchor + revolute joint (limits ke saath).
  /// Build phase mein frozen (gravity 0, soyi hui) — GO par activate hoti hai.
  Body _createSeesawBody() {
    // Pivot anchor — static, piece centre par.
    final anchorDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      userData: this,
    );
    _seesawAnchor = world.createBody(anchorDef);

    final plankDef = BodyDef(
      type: BodyType.dynamic,
      position: pieceCenter,
      angularDamping: SeesawValues.angularDamping,
      userData: this,
    );
    final plank = world.createBody(plankDef);
    final shape = PolygonShape()
      ..setAsBox(
        SeesawValues.plankLength / 2,
        SeesawValues.plankThickness / 2,
        Vector2.zero(),
        0,
      );
    final fixture = plank.createFixture(
      FixtureDef(
        shape,
        density: SeesawValues.plankDensity,
        friction: SurfaceValues.terrainFriction(surface),
        isSensor: true,
      ),
    );
    _solidFixtures.add(fixture);

    final jointDef = RevoluteJointDef();
    jointDef.initialize(_seesawAnchor!, plank, pieceCenter);
    jointDef.enableLimit = true;
    jointDef.lowerAngle = -SeesawValues.maxTiltRadians;
    jointDef.upperAngle = SeesawValues.maxTiltRadians;
    final joint = RevoluteJoint(jointDef);
    world.createJoint(joint);
    _seesawJoint = joint;

    // Build phase mein frozen — GO par makeSolid() activate karega.
    plank.gravityScale = Vector2.zero();
    plank.setAwake(false);
    return plank;
  }

  /// Road / Ramp / Bridge — trapezoid plank (Phase 1 se waisa hi).
  Body _createPlankBody() {
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
    final fixture = body.createFixture(
      FixtureDef(
        shape,
        friction: SurfaceValues.terrainFriction(surface),
        isSensor: true,
      ),
    );
    _solidFixtures.add(fixture);
    return body;
  }

  @override
  void onRemove() {
    if (_seesawJoint != null) {
      world.destroyJoint(_seesawJoint!);
      _seesawJoint = null;
    }
    if (_seesawAnchor != null) {
      world.destroyBody(_seesawAnchor!);
      _seesawAnchor = null;
    }
    super.onRemove();
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is! Car) return;
    final isSensorContact =
        contact.fixtureA.isSensor || contact.fixtureB.isSensor;
    switch (type) {
      case PieceType.booster:
        if (_boosted) return;
        _boosted = true;
        other.applyBoost(PhysicsValues.boosterTargetSpeed);
        final game = findGame();
        if (game is TrackBuilderGame && game.phase == GamePhase.drive) {
          game.onBoost(other.position);
        }
        return;
      case PieceType.spring:
        other.launchUp(SpringValues.launchVelocity);
        return;
      case PieceType.magnet:
        other.setInMagnetZone(true);
        return;
      case PieceType.loop:
        // Sirf sensor circle ka contact — arc se takrao nahi.
        if (isSensorContact) {
          other.setInLoop(true);
          // Entry ramp ghost — car exit ke baad us se guzar kar finish jaye.
          _loopEntryRampFixture?.setSensor(true);
        }
        return;
      case PieceType.bridge:
        _carTouching++;
        // Bridge-break hazard — drive mein gari ke pehle touch par timer.
        if (breakAfterSeconds != null &&
            _breakTimer == null &&
            !_broken) {
          final game = findGame();
          if (game is TrackBuilderGame && game.phase == GamePhase.drive) {
            _breakTimer = breakAfterSeconds;
          }
        }
        return;
      default:
        return;
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is! Car) return;
    final isSensorContact =
        contact.fixtureA.isSensor || contact.fixtureB.isSensor;
    switch (type) {
      case PieceType.magnet:
        other.setInMagnetZone(false);
        return;
      case PieceType.loop:
        if (isSensorContact) other.setInLoop(false);
        return;
      case PieceType.bridge:
        if (_carTouching > 0) _carTouching--;
        return;
      default:
        return;
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
    // Sinking bridge — gari upar ho to ahista neeche dhanse.
    // Sirf drive phase mein, aur sirf jab bridge solid ho.
    if (sinkRate != null &&
        _carTouching > 0 &&
        !_broken &&
        _wantSolid &&
        isMounted) {
      final game = findGame();
      if (game is TrackBuilderGame && game.phase == GamePhase.drive) {
        body.setTransform(
          body.position + Vector2(0, sinkRate! * dt),
          body.angle,
        );
      }
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
  /// Booster / Spring / Magnet hamesha sensor rehte hain.
  void makeSolid() {
    if (type == PieceType.booster ||
        type == PieceType.spring ||
        type == PieceType.magnet) {
      return;
    }
    _wantSolid = true;
    _breakTimer = null;
    _broken = false;
    _breakFade = 1;
    if (type == PieceType.seesaw) {
      // Plank activate — gravity on, jag jaye.
      body.gravityScale = Vector2(1, 1);
      body.setAwake(true);
    }
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
    _carTouching = 0;
    if (type == PieceType.seesaw && isMounted) {
      // Plank wapas seedha + frozen.
      body.setTransform(pieceCenter, 0);
      body.linearVelocity = Vector2.zero();
      body.angularVelocity = 0;
      body.gravityScale = Vector2.zero();
      body.setAwake(false);
    }
    if (isMounted) _applyGhost();
  }

  void _applySolid() {
    for (final fixture in _solidFixtures) {
      fixture.setSensor(false);
    }
  }

  void _applyGhost() {
    for (final fixture in _solidFixtures) {
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
    if (type == PieceType.loop) {
      // Ring — centre se radius ke andar (thodi margin ke saath).
      final dist = math.sqrt(dx * dx + dy * dy);
      return dist <= LoopValues.radius + 0.4;
    }
    if (type == PieceType.magnet) {
      // Zone — 2m chauda, 5m uncha rectangle.
      return dx.abs() <= MagnetValues.zoneWidth / 2 + 0.2 &&
          dy.abs() <= MagnetValues.zoneHeight / 2 + 0.2;
    }
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

    if (type == PieceType.spring) {
      if (sprite != null) {
        sprite.render(
          canvas,
          position: Vector2(-0.5, -0.3),
          size: Vector2(1.0, 0.3),
          overridePaint: fadePaint,
        );
        return;
      }
      // Fallback — sabz pad + coil (zigzag).
      canvas.drawRect(
        const Rect.fromLTWH(-0.5, -0.15, 1.0, 0.15),
        paint,
      );
      final coilPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 0.05
        ..style = PaintingStyle.stroke;
      final coil = Path()
        ..moveTo(-0.4, -0.15)
        ..lineTo(-0.2, -0.3)
        ..lineTo(0, -0.15)
        ..lineTo(0.2, -0.3)
        ..lineTo(0.4, -0.15);
      canvas.drawPath(coil, coilPaint);
      return;
    }

    if (type == PieceType.magnet) {
      // Zone — halka neela rectangle + ceiling rail line.
      final zonePaint = Paint()
        ..color = const Color(0x333F51B5)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: MagnetValues.zoneWidth,
          height: MagnetValues.zoneHeight,
        ),
        zonePaint,
      );
      final borderPaint = Paint()
        ..color = const Color(0xFF3F51B5)
        ..strokeWidth = 0.05
        ..style = PaintingStyle.stroke;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: MagnetValues.zoneWidth,
          height: MagnetValues.zoneHeight,
        ),
        borderPaint,
      );
      // Ceiling rail — upar wali line.
      canvas.drawLine(
        Offset(
          -MagnetValues.zoneWidth / 2,
          -MagnetValues.zoneHeight / 2,
        ),
        Offset(
          MagnetValues.zoneWidth / 2,
          -MagnetValues.zoneHeight / 2,
        ),
        Paint()
          ..color = const Color(0xFF3F51B5)
          ..strokeWidth = 0.08,
      );
      return;
    }

    if (type == PieceType.loop) {
      // Entry/exit ramps — shape se (sprite sirf ring hai).
      for (final entry in [true]) {
        final corners = _loopRampCorners(entry: entry);
        canvas.drawPath(
          Path()
            ..moveTo(corners[0].x, corners[0].y)
            ..lineTo(corners[1].x, corners[1].y)
            ..lineTo(corners[2].x, corners[2].y)
            ..lineTo(corners[3].x, corners[3].y)
            ..close(),
          paint,
        );
      }
      if (sprite != null) {
        // Sprite sirf ring hai (diameter 2*radius).
        final ringSize = LoopValues.radius * 2;
        sprite.render(
          canvas,
          position: Vector2(-ringSize / 2, -ringSize / 2),
          size: Vector2(ringSize, ringSize),
          overridePaint: fadePaint,
        );
        return;
      }
      // Fallback — ring, neeche ka gap khula.
      final ringPaint = Paint()
        ..color = type.color
        ..strokeWidth = LoopValues.arcThickness
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset.zero,
          radius: LoopValues.radius,
        ),
        LoopValues.arcStartDegrees * math.pi / 180,
        (360 - (LoopValues.arcStartDegrees - LoopValues.gapStartDegrees)) *
            math.pi /
            180,
        false,
        ringPaint,
      );
      return;
    }

    if (type == PieceType.seesaw) {
      if (sprite != null) {
        sprite.render(
          canvas,
          position: Vector2(-1.5, -0.15),
          size: Vector2(3.0, 0.3),
          overridePaint: fadePaint,
        );
        // Pivot triangle — sprite ke neeche.
        canvas.drawPath(
          Path()
            ..moveTo(-0.25, 0.15)
            ..lineTo(0.25, 0.15)
            ..lineTo(0, 0.6)
            ..close(),
          Paint()..color = const Color(0xFF5D4037),
        );
        return;
      }
      // Fallback — peeli plank + pivot triangle.
      canvas.drawRect(
        const Rect.fromLTWH(-1.5, -0.15, 3.0, 0.3),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(-0.25, 0.15)
          ..lineTo(0.25, 0.15)
          ..lineTo(0, 0.6)
          ..close(),
        Paint()..color = const Color(0xFF5D4037),
      );
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
