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
    test('road, ramp, bridge aur booster Phase 3 mein implemented hain', () {
      expect(PieceType.road.isImplemented, isTrue);
      expect(PieceType.ramp.isImplemented, isTrue);
      expect(PieceType.bridge.isImplemented, isTrue);
      expect(PieceType.booster.isImplemented, isTrue);
      expect(PieceType.loop.isImplemented, isFalse);
      expect(PieceType.spring.isImplemented, isFalse);
      expect(PieceType.seesaw.isImplemented, isFalse);
      expect(PieceType.magnet.isImplemented, isFalse);
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

    test('buyCar coins kaat kar owned mein dalta hai', () {
      final progress = PlayerProgress(totalCoins: 500);
      // Paise kam hain — Snow Rally (600) nahi khareed sakta.
      expect(
        progress.buyCar(carId: 'snow_rally', priceCoins: 600),
        isFalse,
      );
      expect(progress.totalCoins, 500);
      // Desert Pickup (300) khareed sakta hai.
      expect(
        progress.buyCar(carId: 'desert_pickup', priceCoins: 300),
        isTrue,
      );
      expect(progress.totalCoins, 200);
      expect(progress.ownedCars.contains('desert_pickup'), isTrue);
      // Dobara khareedna nahi — pehle se owned hai.
      expect(
        progress.buyCar(carId: 'desert_pickup', priceCoins: 300),
        isFalse,
      );
      expect(progress.totalCoins, 200);
    });

    test('selectCar sirf owned gari chunta hai', () {
      final progress = PlayerProgress(totalCoins: 500);
      expect(progress.selectCar('desert_pickup'), isFalse);
      progress.buyCar(carId: 'desert_pickup', priceCoins: 300);
      expect(progress.selectCar('desert_pickup'), isTrue);
      expect(progress.selectedCarId, 'desert_pickup');
    });

    test('reset progress saaf kar deta hai', () {
      final progress = PlayerProgress(totalCoins: 500);
      progress.recordLevelResult(levelId: 1, stars: 3, coinsCollected: 3);
      progress.buyCar(carId: 'desert_pickup', priceCoins: 300);
      progress.selectCar('desert_pickup');
      progress.reset();
      expect(progress.totalStars, 0);
      expect(progress.totalCoins, 0);
      expect(progress.isLevelUnlocked(1), isTrue);
      expect(progress.isLevelUnlocked(2), isFalse);
      expect(progress.selectedCarId, 'starter_bug');
      expect(progress.ownedCars, {'starter_bug'});
      expect(progress.musicOn, isTrue);
      expect(progress.sfxOn, isTrue);
    });
  });

  group('CarData', () {
    test('starter gari free aur balanced hai', () {
      expect(starterBug.isFree, isTrue);
      expect(starterBug.speed, 5);
      expect(starterBug.grip, 5);
      expect(starterBug.stability, 5);
    });

    test('5 gariyan hain — design doc ke mutabiq qeematein', () {
      expect(allCars.length, 5);
      expect(carById('desert_pickup')?.priceCoins, 300);
      expect(carById('snow_rally')?.priceCoins, 600);
      expect(carById('city_racer')?.priceCoins, 1000);
      expect(carById('rocket_van')?.priceCoins, 1800);
      expect(carById('nahi_hai'), isNull);
    });

    test('Starter Bug ke multipliers 1.0 hain', () {
      expect(starterBug.motorMultiplier, closeTo(1.0, 0.001));
      expect(starterBug.gripMultiplier, closeTo(1.0, 0.001));
      expect(starterBug.stabilityMultiplier, closeTo(1.0, 0.001));
    });

    test('stats multipliers sahi direction mein hain', () {
      // City Racer tez, grip kam.
      expect(cityRacer.motorMultiplier, greaterThan(1.0));
      expect(cityRacer.gripMultiplier, lessThan(1.0));
      // Snow Rally ki grip sab se zyada.
      expect(snowRally.gripMultiplier, greaterThan(1.0));
      expect(
        snowRally.gripMultiplier,
        greaterThan(desertPickup.gripMultiplier),
      );
      // Desert Pickup sab se stable.
      expect(
        desertPickup.stabilityMultiplier,
        greaterThan(snowRally.stabilityMultiplier),
      );
    });
  });
}
