// Progression ke tests — stars, coins, world unlock.
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/data/models/player_progress.dart';

void main() {
  group('Stars aur coins', () {
    test('pehla level clear karne par agla khulta hai', () {
      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 1, coinsCollected: 2);
      expect(progress.isLevelUnlocked(2), isTrue);
      expect(progress.totalStars, 1);
    });

    test('0 stars par agla level nahi khulta', () {
      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 0, coinsCollected: 0);
      expect(progress.isLevelUnlocked(2), isFalse);
    });
  });

  group('World unlock', () {
    test('World 1 hamesha khula hai', () {
      expect(PlayerProgress().isWorldUnlocked(1), isTrue);
    });

    test('World 2 khulta hai jab World 1 mein 20+ stars hon', () {
      final progress = PlayerProgress();
      // World 1 ke 12 levels mein 19 stars — abhi band.
      for (var i = 1; i <= 12; i++) {
        progress.recordLevelResult(
          levelId: i,
          stars: i <= 9 ? 2 : (i == 10 ? 1 : 0),
          coinsCollected: 0,
        );
      }
      expect(progress.totalStars, 19);
      expect(progress.isWorldUnlocked(2), isFalse);

      // Ek aur star — 20 ho gaye, khul gaya.
      progress.recordLevelResult(levelId: 1, stars: 3, coinsCollected: 0);
      expect(progress.totalStars, 20);
      expect(progress.isWorldUnlocked(2), isTrue);
    });

    test('poora World 1 3-star ho to World 2 khula hai', () {
      final progress = PlayerProgress();
      for (var i = 1; i <= 12; i++) {
        progress.recordLevelResult(levelId: i, stars: 3, coinsCollected: 3);
      }
      expect(progress.totalStars, 36);
      expect(progress.isWorldUnlocked(2), isTrue);
      expect(progress.isWorldUnlocked(3), isFalse);
    });
  });
}
