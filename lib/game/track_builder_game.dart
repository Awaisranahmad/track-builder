// Track Builder ka main game — Flame + Forge2D.
// Phases: build → drive → result. UI is se ValueNotifier se baat karta hai,
// game UI ko kabhi seedha nahi chhoota (layer rule 4).
// Phase 4: sprites (components mein), EffectsManager (particles + shake),
// AdsService (fail ke baad interstitial, rewarded hint/coins),
// HintManager (ghost solution), hazards (bridge-break, snowball).
import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/models/car_data.dart';
import '../data/models/level_data.dart';
import '../data/models/piece_type.dart';
import '../data/models/player_progress.dart';
import '../data/save_service.dart';
import '../../services/ads_service.dart';
import '../../services/audio_service.dart';
import 'components/background.dart';
import 'components/car.dart';
import 'components/coin.dart';
import 'components/crumble_component.dart';
import 'components/finish_flag.dart';
import 'components/gate_component.dart';
import 'components/geyser_component.dart';
import 'components/ghost_hint.dart';
import 'components/lava_component.dart';
import 'components/lift_component.dart';
import 'components/rock_component.dart';
import 'components/snowball.dart';
import 'components/terrain.dart';
import 'components/track_piece.dart';
import 'components/wind_component.dart';
import 'managers/build_manager.dart';
import 'managers/camera_manager.dart';
import 'managers/drive_manager.dart';
import 'managers/effects_manager.dart';
import 'managers/hint_manager.dart';

enum GamePhase { build, drive, result }

class TrackBuilderGame extends Forge2DGame
    with TapCallbacks, DoubleTapCallbacks {
  TrackBuilderGame({
    required this.level,
    required this.progress,
    required this.saveService,
    AudioService? audio,
    AdsService? ads,
  }) : audio = audio ?? audioService,
       ads = ads ?? adsService,
       super(gravity: Vector2(0, PhysicsValues.gravityY)) {
    // Managers constructor mein banao — GameScreen game load hone se
    // pehle hi build hoti hai, aur use buildManager chahiye hota hai.
    // Callbacks lazy hain (world/car tab tak taiyar ho chuke hote hain).
    buildManager = BuildManager(
      level: level,
      onPieceAdded: (piece) => world.add(piece),
      onPieceRemoved: (piece) => world.remove(piece),
    );
    driveManager = DriveManager(level);
    cameraManager = CameraManager(this);
    effectsManager = EffectsManager(this);
    hintManager = HintManager(level: level, buildManager: buildManager);
  }

  final LevelData level;
  final PlayerProgress progress;
  final SaveService saveService;

  /// Audio — default app ka shared service; tests mein testMode wala do.
  final AudioService audio;

  /// Ads — default app ka shared service; tests mein testMode wala do.
  final AdsService ads;

  late final BuildManager buildManager;
  late final DriveManager driveManager;
  late final CameraManager cameraManager;
  late final EffectsManager effectsManager;
  late final HintManager hintManager;

  late final Car car;
  late final FinishFlagComponent finishFlag;
  final List<CoinComponent> _coins = [];

  /// Snowballs — L35 jaisi hazard levels mein drive ke dauran spawn hote hain.
  final List<SnowballComponent> _snowballs = [];
  double _snowballTimer = 0;

  /// Falling rocks — L52 jaisi hazard levels mein drive ke dauran spawn hote hain.
  final List<FallingRockComponent> _rocks = [];
  double _rockTimer = 0;

  /// Lava / geyser / lift / gate / wind / crumble components — level data se.
  final List<LavaComponent> _lavas = [];
  final List<GateComponent> _gates = [];
  final List<LiftComponent> _lifts = [];
  final List<WindComponent> _winds = [];
  final List<GeyserComponent> _geysers = [];

  /// Aakhri fail ke baad interstitial ki koshish — test isay await kar sakta hai.
  Future<bool>? lastInterstitialAttempt;

  /// Abhi dikh raha hint ghost — naya hint purane ko hata deta hai.
  GhostHintComponent? _hintGhost;

  /// UI is se phase sunta hai.
  final ValueNotifier<GamePhase> phaseNotifier =
      ValueNotifier(GamePhase.build);

  /// UI is se coins sunta hai.
  final ValueNotifier<int> coinsNotifier = ValueNotifier(0);

  /// Result aate hi UI overlay dikhata hai.
  final ValueNotifier<LevelResult?> resultNotifier = ValueNotifier(null);

  GamePhase get phase => phaseNotifier.value;

  double get elapsed => driveManager.elapsed;

  /// Kitne snowballs active hain — test ke liye.
  int get activeSnowballs => _snowballs.length;

  /// Kitne falling rocks active hain — test ke liye.
  int get activeRocks => _rocks.length;

  /// Kitne gates hain — test ke liye.
  int get gateCount => _gates.length;

  /// Kitne lifts hain — test ke liye.
  int get liftCount => _lifts.length;

  /// Kitne lava zones hain — test ke liye.
  int get lavaCount => _lavas.length;

  /// Kitne wind zones hain — test ke liye.
  int get windCount => _winds.length;

  /// Kitne geysers hain — test ke liye.
  int get geyserCount => _geysers.length;

  /// onLoad mukammal hua ya nahi — tests is se load ka intezar karte hain
  /// (sprite load async hai, ek pump kaafi nahi).
  bool isLoaded = false;

  @override
  Color backgroundColor() => GameColors.sky;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    cameraManager.setupFixedCamera();

    await add(BackgroundComponent(world: level.world));
    await world.add(TerrainComponent(level));

    finishFlag = FinishFlagComponent(
      x: level.finishX,
      onFinished: onFinishReached,
    );
    await world.add(finishFlag);

    for (final coinData in level.coins) {
      final coin = CoinComponent(
        x: coinData.x,
        y: coinData.y,
        onCollected: onCoinCollected,
      );
      _coins.add(coin);
      await world.add(coin);
    }

    car = Car(
      startPosition: Vector2(level.startX, level.startY),
      carData: carById(progress.selectedCarId) ?? starterBug,
      surface: level.surface,
    );
    await world.add(car);

    // Phase 5 hazards — level data se components banao.
    for (final platform in level.crumblePlatforms) {
      await world.add(CrumblePlatformComponent(segment: platform));
    }
    for (final hazard in level.hazardsOf(HazardType.lift)) {
      final lift = LiftComponent(
        x: hazard.x,
        bottomY: hazard.y,
        topY: hazard.y2,
        periodSeconds: hazard.periodSeconds,
      );
      _lifts.add(lift);
      await world.add(lift);
    }
    for (final hazard in level.hazardsOf(HazardType.gate)) {
      final gate = GateComponent(
        x: hazard.x,
        groundY: hazard.y,
        cycleSeconds: hazard.cycleSeconds,
        openSeconds: hazard.openSeconds,
      );
      _gates.add(gate);
      await world.add(gate);
    }
    for (final hazard in level.hazardsOf(HazardType.lava)) {
      final lava = LavaComponent(
        x: hazard.x,
        topY: hazard.y,
        width: hazard.width,
        onCarTouched: onLavaTouched,
      );
      _lavas.add(lava);
      await world.add(lava);
    }
    for (final hazard in level.hazardsOf(HazardType.risingLava)) {
      final lava = LavaComponent(
        x: hazard.x,
        topY: hazard.y,
        width: hazard.width,
        riseRate: hazard.rate,
        onCarTouched: onLavaTouched,
      );
      _lavas.add(lava);
      await world.add(lava);
    }
    for (final hazard in level.hazardsOf(HazardType.wind)) {
      final wind = WindComponent(
        x: hazard.x,
        y: hazard.y,
        width: hazard.width,
        height: hazard.height,
        cycleSeconds: hazard.cycleSeconds,
        gustSeconds: hazard.openSeconds,
        strength: hazard.strength,
      );
      _winds.add(wind);
      await world.add(wind);
    }
    for (final hazard in level.hazardsOf(HazardType.geyser)) {
      final geyser = GeyserComponent(
        x: hazard.x,
        groundY: hazard.y,
        height: hazard.height,
        cycleSeconds: hazard.cycleSeconds,
        activeSeconds: hazard.openSeconds,
        onCarTouched: onLavaTouched,
      );
      _geysers.add(geyser);
      await world.add(geyser);
    }

    isLoaded = true;
  }

  // ---- Build phase: tap handling ----
  // Game khud TapCallbacks hai — localPosition world coords mein hoti hai.

  @override
  void onTapDown(TapDownEvent event) {
    if (phase != GamePhase.build) return;
    final worldPos = event.localPosition;

    if (buildManager.selectedPiece != null) {
      buildManager.placeAt(worldPos, buildManager.selectedPiece!);
      return;
    }
    // Kuch nahi chuna — tap kiya hua piece ghumao.
    buildManager.rotateAt(worldPos);
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    if (phase != GamePhase.build) return;
    buildManager.removeAt(event.localPosition);
  }

  /// Tray se piece chunna — UI isay bulata hai.
  void selectPiece(PieceType? type) {
    buildManager.selectedPiece = type;
  }

  bool get canUndo => buildManager.placedPieces.isNotEmpty;

  void undo() => buildManager.undo();

  void clearBuild() => buildManager.clear();

  // ---- Hints ----

  /// Hint istemal karo — build phase mein, ghost solution dikhata hai.
  /// Hint na ho ya koi step na bache to false (hint nahi katta).
  bool useHint() {
    if (phase != GamePhase.build) return false;
    final ghost = hintManager.ghostForNextStep();
    if (ghost == null) return false;
    if (!progress.useHint()) return false;
    _hintGhost?.removeFromParent();
    _hintGhost = ghost;
    add(ghost);
    unawaited(saveService.saveProgress(progress));
    return true;
  }

  /// Kitne hints baaki hain — UI dikhata hai.
  int get hintsLeft => progress.hints;

  // ---- Drive phase ----

  /// GO — physics on, timer start.
  void startDrive() {
    if (phase != GamePhase.build) return;
    _hintGhost?.removeFromParent();
    _hintGhost = null;
    for (final piece in buildManager.placedPieces) {
      piece.makeSolid();
    }
    driveManager.start();
    coinsNotifier.value = 0;
    resultNotifier.value = null;
    car.activate();
    unawaited(audio.startEngine());
    // Snowball hazard — pehla gola timer se aayega.
    final snowball = level.snowballHazard;
    _snowballTimer = snowball?.firstAfterSeconds ?? 0;
    // Rockfall hazard — pehla pathar timer se aayega.
    final rockfalls = level.hazardsOf(HazardType.rockfall);
    _rockTimer = rockfalls.isEmpty ? 0 : rockfalls.first.firstAfterSeconds;
    phaseNotifier.value = GamePhase.drive;
  }

  void setGas(bool on) {
    if (phase == GamePhase.drive) car.setGas(on);
  }

  void setBrake(bool on) {
    if (phase == GamePhase.drive) car.setBrake(on);
  }

  void onCoinCollected(CoinComponent coin) {
    driveManager.onCoinCollected();
    coinsNotifier.value = driveManager.coinsCollected;
    effectsManager.coinBurst(Vector2(coin.x, coin.y));
    unawaited(audio.playSfx('coin'));
  }

  void onFinishReached() {
    if (phase != GamePhase.drive) return;
    driveManager.onFinish();
    effectsManager.winConfetti(Vector2(level.finishX, 6.5));
    unawaited(audio.playSfx('win'));
    unawaited(audio.stopEngine());
    _finishDrive();
  }

  /// Booster se guzre — flame + halka shake.
  void onBoost(Vector2 position) {
    if (phase != GamePhase.drive) return;
    effectsManager.boostFlame(position);
    effectsManager.shake();
  }

  /// Bridge toot gaya (L34) — smoke + shake.
  void onBridgeBroke(TrackPiece piece) {
    effectsManager.crashSmoke(piece.pieceCenter);
    effectsManager.shake(amount: EffectsValues.crashShakeAmountMetres);
  }

  /// Snowball gari se takraya — smoke + shake.
  void onSnowballHit(SnowballComponent snowball) {
    effectsManager.crashSmoke(car.position);
    effectsManager.shake(amount: EffectsValues.crashShakeAmountMetres);
  }

  /// Falling rock gari se takraya — smoke + shake.
  void onRockHit(FallingRockComponent rock) {
    effectsManager.crashSmoke(car.position);
    effectsManager.shake(amount: EffectsValues.crashShakeAmountMetres);
  }

  /// Lava ya geyser chhoo liya — foran fail (design doc: lava is an instant fail).
  void onLavaTouched() {
    if (phase != GamePhase.drive) return;
    driveManager.fail('lava');
    _finishDrive();
  }

  void _spawnSnowball() {
    final hazard = level.snowballHazard;
    if (hazard == null) return;
    if (_snowballs.length >= 2) return;
    final snowball = SnowballComponent(
      spawn: Vector2(hazard.x, hazard.y),
      onHitCar: onSnowballHit,
      onOutOfBounds: (ball) {
        _snowballs.remove(ball);
        ball.removeFromParent();
      },
    );
    _snowballs.add(snowball);
    world.add(snowball);
  }

  void _clearSnowballs() {
    for (final ball in List.of(_snowballs)) {
      ball.removeFromParent();
    }
    _snowballs.clear();
    _snowballTimer = 0;
  }

  void _spawnRock() {
    final rockfalls = level.hazardsOf(HazardType.rockfall);
    if (rockfalls.isEmpty) return;
    if (_rocks.length >= 2) return;
    final hazard = rockfalls.first;
    final rock = FallingRockComponent(
      spawn: Vector2(hazard.x, hazard.y),
      onHitCar: onRockHit,
      onOutOfBounds: (rock) {
        _rocks.remove(rock);
        rock.removeFromParent();
      },
    );
    _rocks.add(rock);
    world.add(rock);
  }

  void _clearRocks() {
    for (final rock in List.of(_rocks)) {
      rock.removeFromParent();
    }
    _rocks.clear();
    _rockTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraManager.update(dt);
    if (phase != GamePhase.drive) return;
    // Snowball spawner — drive mein, interval par.
    if (level.snowballHazard != null) {
      _snowballTimer -= dt;
      if (_snowballTimer <= 0) {
        _spawnSnowball();
        _snowballTimer = level.snowballHazard!.intervalSeconds;
      }
    }
    // Rockfall spawner — drive mein, interval par.
    final rockfalls = level.hazardsOf(HazardType.rockfall);
    if (rockfalls.isNotEmpty) {
      _rockTimer -= dt;
      if (_rockTimer <= 0) {
        _spawnRock();
        _rockTimer = rockfalls.first.intervalSeconds;
      }
    }
    driveManager.update(dt, car);
    unawaited(audio.setEngineSpeed(car.speed / 7.0));
    if (driveManager.failed || driveManager.finished) {
      _finishDrive();
    }
  }

  void _finishDrive() {
    if (phase != GamePhase.drive) return;
    final result = driveManager.buildResult();
    if (result.failed) {
      effectsManager.crashSmoke(car.position);
      effectsManager.shake(amount: EffectsValues.crashShakeAmountMetres);
      unawaited(audio.playSfx('crash'));
      unawaited(audio.stopEngine());
      // Interstitial — sirf fail ke baad, har 3rd fail par, drive se bahar.
      lastInterstitialAttempt = ads.maybeShowInterstitialAfterFail();
    }
    phaseNotifier.value = GamePhase.result;
    resultNotifier.value = result;

    // Progress save karo — behtareen stars + coins.
    progress.recordLevelResult(
      levelId: level.id,
      stars: result.stars,
      coinsCollected: result.coinsCollected,
    );
    unawaited(saveService.saveProgress(progress));
  }

  // ---- Retry / dobara ----

  /// Fail ya result ke baad — build waisa hi rehta hai, sirf gari
  /// aur coins reset hote hain (design doc: retry ek tap hai).
  void retry() {
    unawaited(audio.stopEngine());
    _clearSnowballs();
    _clearRocks();
    _hintGhost?.removeFromParent();
    _hintGhost = null;
    for (final piece in buildManager.placedPieces) {
      piece.makeGhost();
    }
    car.resetToStart();
    finishFlag.reset();
    _resetCoins();
    driveManager.start();
    coinsNotifier.value = 0;
    resultNotifier.value = null;
    phaseNotifier.value = GamePhase.build;
  }

  /// Build saaf kar ke dobara shuru karo.
  void restartLevel() {
    buildManager.clear();
    retry();
  }

  void _resetCoins() {
    for (final coin in _coins) {
      coin.reset();
    }
  }

  void pauseGame() => pauseEngine();

  void resumeGame() => resumeEngine();
}
