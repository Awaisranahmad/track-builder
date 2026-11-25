// Data models ke unit tests — LevelData, PieceType, PlayerProgress, CarData.
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/core/constants.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/models/car_data.dart';
import 'package:track_builder/data/models/level_data.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';

void main() {
  group('PieceType', () {
    test('road aur ramp Phase 1 mein implemented hain', () {
      expect(PieceType.road.isImplemented, isTrue);
      expect(PieceType.ramp.isImplemented, isTrue);
      expect(PieceType.bridge.isImplemented, isFalse);
    });

    test('unlock levels design doc ke mutabiq hain', () {
      expect(PieceType.road.unlockLevel, 1);
      expect(PieceType.ramp.unlockLevel, 5);
      expect(PieceType.bridge.unlockLevel, 9);
      expect(PieceType.booster.unlockLevel, 27);
    });

    test('road ki lambai 2m hai', () {
      expect(PieceType.road.length, 2.0);
    });
  });

  group('LevelData.validate', () {
    test('Level 1 valid hai', () {
      final errors = level1.validate(
        worldWidth: WorldSize.width,
        worldHeight: WorldSize.height,
      );
      expect(errors, isEmpty);
    });

    test('khaali tray wala level error deta hai', () {
      const bad = LevelData(
        id: 99,
        world: 1,
        levelInWorld: 1,
        name: 'Bad',
        terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
        startX: 2,
        startY: 8.33,
        finishX: 17,
        tray: [],
        coins: [CoinData(5, 8)],
        goldTimeSeconds: 10,
      );
      final errors = bad.validate(
        worldWidth: WorldSize.width,
        worldHeight: WorldSize.height,
      );
      expect(errors, isNotEmpty);
      expect(errors.any((e) => e.contains('tray')), isTrue);
    });

    test('finish start se peeche ho to error', () {
      const bad = LevelData(
        id: 99,
        world: 1,
        levelInWorld: 1,
        name: 'Bad',
        terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
        startX: 10,
        startY: 8.33,
        finishX: 5,
        tray: [TrayEntry(PieceType.road, 1)],
        coins: [CoinData(5, 8)],
        goldTimeSeconds: 10,
      );
      final errors = bad.validate(
        worldWidth: WorldSize.width,
        worldHeight: WorldSize.height,
      );
      expect(errors.any((e) => e.contains('finishX')), isTrue);
    });

    test('start hawa mein ho to error', () {
      const bad = LevelData(
        id: 99,
        world: 1,
        levelInWorld: 1,
        name: 'Bad',
        terrain: [TerrainSegment(x: 0, y: 9, width: 4, height: 2)],
        startX: 10,
        startY: 8.33,
        finishX: 17,
        tray: [TrayEntry(PieceType.road, 1)],
        coins: [CoinData(5, 8)],
        goldTimeSeconds: 10,
      );
      final errors = bad.validate(
        worldWidth: WorldSize.width,
        worldHeight: WorldSize.height,
      );
      expect(errors.any((e) => e.contains('start position')), isTrue);
    });
  });

  group('PlayerProgress', () {
    test('nayi progress mein Level 1 khula, 0 stars', () {
      final progress = PlayerProgress();
      expect(progress.isLevelUnlocked(1), isTrue);
      expect(progress.isLevelUnlocked(2), isFalse);
      expect(progress.totalStars, 0);
      expect(progress.totalCoins, 0);
    });

    test('recordLevelResult behtareen stars rakhta hai', () {
      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 2, coinsCollected: 3);
      expect(progress.starsForLevel(1), 2);
      expect(progress.totalCoins, 3);
      expect(progress.isLevelUnlocked(2), isTrue);

      // Kam stars dobara — behtareen rehta hai, coins phir bhi jama hote hain.
      progress.recordLevelResult(levelId: 1, stars: 1, coinsCollected: 1);
      expect(progress.starsForLevel(1), 2);
      expect(progress.totalCoins, 4);
    });

    test('JSON round-trip', () {
      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 3, coinsCollected: 3);
      progress.recordLevelResult(levelId: 2, stars: 2, coinsCollected: 2);
      final restored = PlayerProgress.fromJson(progress.toJson());
      expect(restored.starsForLevel(1), 3);
      expect(restored.starsForLevel(2), 2);
      expect(restored.totalCoins, 5);
      expect(restored.isLevelUnlocked(3), isTrue);
    });
  });

  group('CarData', () {
    test('starter gari free aur balanced hai', () {
      expect(starterBug.isFree, isTrue);
      expect(starterBug.speed, 5);
      expect(starterBug.grip, 5);
      expect(starterBug.stability, 5);
    });
  });
}
