// Track Builder ka main game — Flame + Forge2D.
// Phases: build → drive → result. UI is se ValueNotifier se baat karta hai,
// game UI ko kabhi seedha nahi chhoota (layer rule 4).
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/models/level_data.dart';
import '../data/models/piece_type.dart';
import '../data/models/player_progress.dart';
import '../data/save_service.dart';
import 'components/background.dart';
import 'components/car.dart';
import 'components/coin.dart';
import 'components/finish_flag.dart';
import 'components/terrain.dart';
import 'managers/build_manager.dart';
import 'managers/camera_manager.dart';
import 'managers/drive_manager.dart';

enum GamePhase { build, drive, result }

class TrackBuilderGame extends Forge2DGame
    with TapCallbacks, DoubleTapCallbacks {
  TrackBuilderGame({
    required this.level,
    required this.progress,
    required this.saveService,
  }) : super(gravity: Vector2(0, PhysicsValues.gravityY)) {
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
  }

  final LevelData level;
  final PlayerProgress progress;
  final SaveService saveService;

  late final BuildManager buildManager;
  late final DriveManager driveManager;
  late final CameraManager cameraManager;

  late final Car car;
  late final FinishFlagComponent finishFlag;
  final List<CoinComponent> _coins = [];

  /// UI is se phase sunta hai.
  final ValueNotifier<GamePhase> phaseNotifier =
      ValueNotifier(GamePhase.build);

  /// UI is se coins sunta hai.
  final ValueNotifier<int> coinsNotifier = ValueNotifier(0);

  /// Result aate hi UI overlay dikhata hai.
  final ValueNotifier<LevelResult?> resultNotifier = ValueNotifier(null);

  GamePhase get phase => phaseNotifier.value;

  double get elapsed => driveManager.elapsed;

  @override
  Color backgroundColor() => GameColors.sky;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    cameraManager.setupFixedCamera();

    await add(BackgroundComponent());
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

    car = Car(startPosition: Vector2(level.startX, level.startY));
    await world.add(car);
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

  // ---- Drive phase ----

  /// GO — physics on, timer start.
  void startDrive() {
    if (phase != GamePhase.build) return;
    for (final piece in buildManager.placedPieces) {
      piece.makeSolid();
    }
    driveManager.start();
    coinsNotifier.value = 0;
    resultNotifier.value = null;
    car.activate();
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
  }

  void onFinishReached() {
    if (phase != GamePhase.drive) return;
    driveManager.onFinish();
    _finishDrive();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (phase != GamePhase.drive) return;
    driveManager.update(dt, car);
    if (driveManager.failed || driveManager.finished) {
      _finishDrive();
    }
  }

  void _finishDrive() {
    if (phase != GamePhase.drive) return;
    final result = driveManager.buildResult();
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
