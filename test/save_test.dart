// Save/load round-trip — SharedPreferences mock ke saath.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';

void main() {
  group('SaveService', () {
    test('save karke load karo — sab kuch waisa ka waisa', () async {
      SharedPreferences.setMockInitialValues({});
      final service = await SaveService.create();

      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 3, coinsCollected: 3);
      progress.recordLevelResult(levelId: 2, stars: 2, coinsCollected: 1);
      await service.saveProgress(progress);

      final loaded = service.loadProgress();
      expect(loaded.starsForLevel(1), 3);
      expect(loaded.starsForLevel(2), 2);
      expect(loaded.totalCoins, 4);
      expect(loaded.isLevelUnlocked(3), isTrue);
    });

    test('pehli dafa khaali progress milti hai', () async {
      SharedPreferences.setMockInitialValues({});
      final service = await SaveService.create();
      final loaded = service.loadProgress();
      expect(loaded.totalStars, 0);
      expect(loaded.isLevelUnlocked(1), isTrue);
    });

    test('kharab data ho to game crash nahi karta', () async {
      SharedPreferences.setMockInitialValues({
        'track_builder_progress_v1': 'ye-json-nahi-hai{{{',
      });
      final service = await SaveService.create();
      final loaded = service.loadProgress();
      expect(loaded.totalStars, 0);
    });

    test('clear karne par progress reset ho jati hai', () async {
      SharedPreferences.setMockInitialValues({});
      final service = await SaveService.create();
      final progress = PlayerProgress();
      progress.recordLevelResult(levelId: 1, stars: 2, coinsCollected: 2);
      await service.saveProgress(progress);
      await service.clearProgress();
      expect(service.loadProgress().totalStars, 0);
    });
  });
}
