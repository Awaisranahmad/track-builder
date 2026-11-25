// Gameplay test — Level 1 ko headless khel kar pass karna.
// Yehi Phase 1 ka "done" hai: build → drive → finish → star → save.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/components/track_piece.dart';
import 'package:track_builder/game/track_builder_game.dart';

/// Game ko 16ms ke steps mein chalao, jab tak result na aaye ya waqt khatam.
Future<void> _pumpUntilResult(
  WidgetTester tester,
  TrackBuilderGame game, {
  int maxSteps = 1200,
}) async {
  for (var i = 0; i < maxSteps; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (game.phase == GamePhase.result) return;
  }
}

Future<TrackBuilderGame> _makeGame(int levelId) async {
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final progress = PlayerProgress();
  final game = TrackBuilderGame(
    level: levelById(levelId)!,
    progress: progress,
    saveService: saveService,
  );
  return game;
}

void main() {
  group('Level 1 — poora loop', () {
    testWidgets('road lagao, GO, gas — gari finish tak pahunchti hai',
        (tester) async {
      final game = await _makeGame(1);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      expect(game.phase, GamePhase.build);

      // Gap par road lagao — tap point (5.2, 9.3) → top-left snap (5, 9).
      final piece = game.buildManager.placeAt(
        Vector2(4.2, 9.3),
        PieceType.road,
      );
      expect(piece, isNotNull);
      await tester.pump(); // piece ka body banne do
      expect(game.buildManager.remainingCount(PieceType.road), 0);

      game.startDrive();
      expect(game.phase, GamePhase.drive);

      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      final result = game.resultNotifier.value;
      expect(result, isNotNull);
      expect(result!.passed, isTrue, reason: 'fail: ${result.failReason}');
      expect(result.stars, greaterThanOrEqualTo(1));
      expect(result.coinsCollected, greaterThanOrEqualTo(1));
    });

    testWidgets('road lagaye baghair gari khaai mein girti hai',
        (tester) async {
      final game = await _makeGame(1);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      await tester.pump(); // gari ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      final result = game.resultNotifier.value;
      expect(result, isNotNull);
      expect(result!.passed, isFalse);
      expect(result.failReason, 'fall');
      expect(result.stars, 0);
    });

    testWidgets('retry par build waisa hi rehta hai', (tester) async {
      final game = await _makeGame(1);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);
      expect(game.phase, GamePhase.result);

      game.retry();
      expect(game.phase, GamePhase.build);
      // Road abhi bhi laga hua hai — dobara lagane ki zaroorat nahi.
      expect(game.buildManager.placedPieces.length, 1);
      expect(game.buildManager.remainingCount(PieceType.road), 0);
    });

    testWidgets('Level 1 pass hone par progress save hoti hai',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final saveService = await SaveService.create();
      final progress = PlayerProgress();
      final game = TrackBuilderGame(
        level: level1,
        progress: progress,
        saveService: saveService,
      );
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.resultNotifier.value?.passed, isTrue);
      // Save async hota hai — thoda waqt do.
      await tester.pump(const Duration(milliseconds: 200));
      final loaded = saveService.loadProgress();
      expect(loaded.starsForLevel(1), greaterThanOrEqualTo(1));
      expect(loaded.isLevelUnlocked(2), isTrue);
    });
  });

  group('Build system', () {
    testWidgets('undo tray mein piece wapas karta hai', (tester) async {
      final game = await _makeGame(2);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      game.buildManager.placeAt(Vector2(10.2, 9.3), PieceType.road);
      await tester.pump(); // pieces ke body banne do
      expect(game.buildManager.remainingCount(PieceType.road), 0);

      expect(game.buildManager.undo(), isTrue);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
      expect(game.buildManager.placedPieces.length, 1);
    });

    testWidgets('tray khaali ho to piece nahi lagta', (tester) async {
      final game = await _makeGame(1);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      final second = game.buildManager.placeAt(
        Vector2(10.2, 9.3),
        PieceType.road,
      );
      expect(second, isNull);
    });

    testWidgets('ramp ka angle upar ki taraf hota hai', (tester) async {
      final game = await _makeGame(1);
      await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
      await tester.pump();

      final ramp = TrackPiece(
        type: PieceType.ramp,
        pieceCenter: Vector2(10, 8),
      );
      game.world.add(ramp);
      await tester.pump();

      // Ramp upar ki taraf — body ka angle negative hona chahiye.
      expect(ramp.body.angle, lessThan(0));
      expect(ramp.body.angle, greaterThan(-1.0));
    });
  });
}
