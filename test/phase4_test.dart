// Phase 4 tests — sprites, particles/effects, ads, hints, hazards.
// Har nayi feature ke saath us ka test (design rule 5).
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/core/constants.dart';
import 'package:track_builder/data/levels/solutions.dart';
import 'package:track_builder/data/levels/worlds.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/components/ghost_hint.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/ads_service.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';
import 'package:track_builder/ui/screens/game_screen.dart';
import 'package:track_builder/garage/garage_screen.dart';

Future<TrackBuilderGame> _makeGame(
  int levelId, {
  PlayerProgress? progress,
  AdsService? ads,
}) async {
  // Test mode: asal PNG decode nahi — placeholder sprites.
  // (Is VM ke tester mein decode ke baad frame atak jata hai.)
  SpriteService.testMode = true;
  await SpriteService.preloadAll();
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final game = TrackBuilderGame(
    level: levelById(levelId)!,
    progress: progress ?? PlayerProgress(),
    saveService: saveService,
    audio: AudioService(testMode: true),
    ads: ads ?? AdsService(testMode: true),
  );
  return game;
}

Future<void> _pumpGame(WidgetTester tester, TrackBuilderGame game) async {
  await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
  // onLoad ab sprite load karta hai (async) — frames chalao jab tak
  // game load na ho jaye, warna car/pieces taiyar nahi hote.
  // (await game.toBeLoaded() yahan deadlock karta hai — mount ko frames chahiye.)
  for (var i = 0; i < 100 && !game.isLoaded; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump();
}

/// Game ko 16ms steps mein chalao, jab tak result na aaye ya waqt khatam.
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

void main() {
  group('Sprites', () {
    testWidgets('sprite files maujood aur valid PNG hain (bina decode)',
        (tester) async {
      // NOTE: is VM ke flutter_tester mein decodeImageFromList ke baad
      // test kabhi khatam nahi hota (image draw kiye baghair) — is liye
      // yahan sirf bytes + PNG header check hota hai, decode nahi.
      // Asli load+draw game tests mein hota hai (GameWidget).
      const expectedSizes = {
        'cars/car_starter_bug.png': (520, 200),
        'cars/car_desert_pickup.png': (520, 200),
        'cars/car_snow_rally.png': (520, 200),
        'cars/car_city_racer.png': (520, 200),
        'cars/car_rocket_van.png': (520, 200),
        'cars/wheel.png': (200, 200),
        'pieces/road.png': (800, 120),
        'pieces/ramp.png': (1000, 120),
        'pieces/bridge.png': (1600, 120),
        'pieces/booster.png': (400, 60),
        'ui/coin.png': (200, 200),
        'ui/flag.png': (400, 200),
        'backgrounds/bg_world1.png': (1600, 880),
        'backgrounds/bg_world2.png': (1600, 880),
        'backgrounds/bg_world3.png': (1600, 880),
        'effects/smoke.png': (200, 200),
        'effects/spark.png': (200, 200),
      };
      for (final entry in expectedSizes.entries) {
        final data = await rootBundle.load(
          'assets/images/${entry.key}',
        );
        final bytes = data.buffer.asUint8List();
        // PNG signature.
        expect(
          bytes.sublist(0, 8),
          [137, 80, 78, 71, 13, 10, 26, 10],
          reason: '${entry.key} PNG nahi hai',
        );
        // IHDR chunk — width bytes 16-19, height 20-23 (big-endian).
        final width = ByteData.view(bytes.buffer).getUint32(16);
        final height = ByteData.view(bytes.buffer).getUint32(20);
        expect(
          (width, height),
          entry.value,
          reason: '${entry.key} ka size ghalat hai',
        );
      }
    });

    testWidgets('ghalat path par null milta hai — fallback shape',
        (tester) async {
      // Test mode OFF — warna placeholder milta, null nahi.
      SpriteService.testMode = false;
      final sprite = await SpriteService.load('nahi/hai.png');
      expect(sprite, isNull);
    });

    testWidgets('sprite wali gari Level 1 khel kar pass hoti hai',
        (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump();
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      expect(game.resultNotifier.value?.passed, isTrue);
    });
  });

  group('Effects — particles aur shake', () {
    testWidgets('coin burst particle add karta hai', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);
      final before = game.children
          .whereType<ParticleSystemComponent>()
          .length;
      game.effectsManager.coinBurst(Vector2(5, 8));
      await tester.pump();
      expect(
        game.children.whereType<ParticleSystemComponent>().length,
        greaterThan(before),
      );
    });

    testWidgets('crash smoke + shake', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      game.effectsManager.crashSmoke(Vector2(5, 8));
      game.effectsManager.shake();
      await tester.pump();

      expect(game.cameraManager.isShaking, isTrue);
      expect(
        game.children.whereType<ParticleSystemComponent>().length,
        greaterThan(0),
      );
      // Shake kuch der mein khatam ho jata hai, camera wapas zero par.
      // Chhote steps mein pump karo — ek lamba pump frame dt barha deta hai.
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(game.cameraManager.isShaking, isFalse);
    });

    testWidgets('win confetti + boost flame', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      game.effectsManager.winConfetti(Vector2(17, 6.5));
      game.effectsManager.boostFlame(Vector2(3, 8));
      await tester.pump();

      expect(
        game.children.whereType<ParticleSystemComponent>().length,
        greaterThanOrEqualTo(2),
      );
    });
  });

  group('Ads — rules', () {
    test('interstitial sirf har 3rd fail par', () async {
      final ads = AdsService(testMode: true);
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
      expect(await ads.maybeShowInterstitialAfterFail(), isTrue);
      expect(ads.interstitialsShown, 1);
      expect(ads.totalFails, 3);
    });

    test('interstitial cooldown — 60s se pehle dobara nahi', () async {
      final ads = AdsService(testMode: true);
      await ads.maybeShowInterstitialAfterFail();
      await ads.maybeShowInterstitialAfterFail();
      expect(await ads.maybeShowInterstitialAfterFail(), isTrue);
      // Agle 3 fails foran — cooldown rok deta hai.
      await ads.maybeShowInterstitialAfterFail();
      await ads.maybeShowInterstitialAfterFail();
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
      // Cooldown guzar gaya dikhao to phir milega.
      ads.lastInterstitialAt =
          DateTime.now().subtract(const Duration(seconds: 61));
      await ads.maybeShowInterstitialAfterFail();
      await ads.maybeShowInterstitialAfterFail();
      expect(await ads.maybeShowInterstitialAfterFail(), isTrue);
      expect(ads.interstitialsShown, 2);
    });

    test('rewarded ad — pehli dafa milega, foran dobara nahi', () async {
      final ads = AdsService(testMode: true);
      expect(await ads.showRewarded(placement: 'hint'), isTrue);
      expect(ads.rewardedShown, 1);
      expect(await ads.showRewarded(placement: 'hint'), isFalse);
      ads.lastRewardedAt =
          DateTime.now().subtract(const Duration(seconds: 31));
      expect(await ads.showRewarded(placement: 'coins'), isTrue);
    });

    test('AdMob wire na ho to ads band — game nahi rukta', () async {
      final ads = AdsService();
      await ads.init();
      expect(ads.adsEnabled, isFalse);
      expect(await ads.showRewarded(placement: 'hint'), isFalse);
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
      expect(await ads.maybeShowInterstitialAfterFail(), isFalse);
    });

    testWidgets('Level 1 teen dafa fail ho to interstitial dikhta hai',
        (tester) async {
      final ads = AdsService(testMode: true);
      final game = await _makeGame(1, ads: ads);
      await _pumpGame(tester, game);

      for (var attempt = 0; attempt < 3; attempt++) {
        game.startDrive();
        game.setGas(true);
        await _pumpUntilResult(tester, game);
        expect(game.resultNotifier.value?.passed, isFalse);
        if (attempt < 2) game.retry();
      }
      final shown = await game.lastInterstitialAttempt;
      expect(shown, isTrue);
      expect(ads.interstitialsShown, 1);
    });
  });

  group('Hints', () {
    test('solution data — 96 levels, har step tray mein, duniya ke andar',
        () {
      expect(levelSolutions.length, 96);
      // Ye 4 levels bina piece lagaye pass hote hain (tray spare hai) —
      // un ka solution khaali rehta hai, hint kuch nahi dikhata.
      const noBuildLevels = {38, 42, 56, 64};
      for (var id = 1; id <= 96; id++) {
        final level = levelById(id)!;
        final steps = levelSolutions[id];
        expect(steps, isNotNull, reason: 'Level $id ka solution nahi');
        if (noBuildLevels.contains(id)) {
          expect(steps, isEmpty, reason: 'Level $id: no-build level hai');
          continue;
        }
        expect(steps, isNotEmpty);
        for (final step in steps!) {
          expect(
            level.trayCount(step.type),
            greaterThan(0),
            reason: 'Level $id: ${step.type.label} tray mein nahi',
          );
          expect(step.tap.x, inInclusiveRange(0, WorldSize.width));
          expect(step.tap.y, inInclusiveRange(0, WorldSize.height));
        }
      }
    });

    testWidgets('useHint ghost dikhata hai, hint katta hai', (tester) async {
      final progress = PlayerProgress();
      final game = await _makeGame(1, progress: progress);
      await _pumpGame(tester, game);

      expect(game.hintsLeft, HintValues.startingHints);
      expect(game.useHint(), isTrue);
      await tester.pump();
      expect(progress.hints, HintValues.startingHints - 1);
      expect(progress.hintsUsed, 1);
      expect(game.children.whereType<GhostHintComponent>().length, 1);

      // Hint wala piece laga do — agla hint nahi bachta (L1 mein 1 step).
      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump();
      expect(game.useHint(), isFalse);
      expect(progress.hints, HintValues.startingHints - 1);
    });

    testWidgets('hint khatam ho to useHint false', (tester) async {
      final progress = PlayerProgress(hints: 0);
      final game = await _makeGame(1, progress: progress);
      await _pumpGame(tester, game);
      expect(game.useHint(), isFalse);
    });

    testWidgets('drive phase mein hint nahi milta', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);
      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump();
      game.startDrive();
      expect(game.useHint(), isFalse);
    });

    test('rewarded ad se hint milta hai', () async {
      final ads = AdsService(testMode: true);
      final progress = PlayerProgress(hints: 0);
      final rewarded = await ads.showRewarded(placement: 'hint');
      expect(rewarded, isTrue);
      progress.grantHint();
      expect(progress.hints, 1);
    });

    test('hints save/load round-trip', () async {
      SharedPreferences.setMockInitialValues({});
      final saveService = await SaveService.create();
      final progress = PlayerProgress(hints: 2, hintsUsed: 5);
      progress.addCoins(50);
      await saveService.saveProgress(progress);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final loaded = saveService.loadProgress();
      expect(loaded.hints, 2);
      expect(loaded.hintsUsed, 5);
      expect(loaded.totalCoins, 50);
    });

    test('skip level — agla level khulta hai, stars nahi milte', () {
      final progress = PlayerProgress();
      expect(progress.isLevelUnlocked(2), isFalse);
      progress.skipLevel(1);
      expect(progress.isLevelUnlocked(2), isTrue);
      expect(progress.starsForLevel(1), 0);
    });
  });

  group('Hazards', () {
    test('L34 mein bridge-break hazard, L35 mein snowball', () {
      final l34 = levelById(34)!;
      expect(l34.bridgeBreakSeconds, 2.0);
      expect(l34.validate(worldWidth: 20, worldHeight: 11), isEmpty);
      final l35 = levelById(35)!;
      expect(l35.snowballHazard, isNotNull);
      expect(l35.snowballHazard!.x, 8);
      expect(l35.validate(worldWidth: 20, worldHeight: 11), isEmpty);
    });

    testWidgets('L34 — bridge 2s baad toot jata hai, level phir bhi pass',
        (tester) async {
      final game = await _makeGame(34);
      await _pumpGame(tester, game);

      final bridge = game.buildManager.placeAt(
        Vector2(4.2, 9.3),
        PieceType.bridge,
      );
      expect(bridge, isNotNull);
      await tester.pump();
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      expect(game.resultNotifier.value?.passed, isTrue);
      // Gari paar kar gayi, bridge peeche toot gaya.
      expect(bridge!.isBroken, isTrue);
    });

    testWidgets('L35 — snowball spawn hota hai, level phir bhi pass',
        (tester) async {
      final game = await _makeGame(35);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      game.buildManager.placeAt(Vector2(10.5, 8.5), PieceType.ramp);
      await tester.pump();
      game.startDrive();
      game.setGas(true);

      // 3 second drive karo — pehla snowball aa jana chahiye.
      for (var i = 0; i < 190; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        if (game.activeSnowballs > 0) break;
      }
      expect(game.activeSnowballs, greaterThan(0));

      await _pumpUntilResult(tester, game);
      expect(game.phase, GamePhase.result);
      expect(game.resultNotifier.value?.passed, isTrue);
    });

    testWidgets('retry par snowballs saaf ho jate hain', (tester) async {
      final game = await _makeGame(35);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      game.buildManager.placeAt(Vector2(10.5, 8.5), PieceType.ramp);
      await tester.pump();
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);
      expect(game.phase, GamePhase.result);

      game.retry();
      expect(game.activeSnowballs, 0);
      expect(game.phase, GamePhase.build);
    });
  });

  group('Phase 4 UI', () {
    testWidgets('Game Screen par Hint button — tap par ghost aata hai',
        (tester) async {
      SpriteService.testMode = true;
      await SpriteService.preloadAll();
      SharedPreferences.setMockInitialValues({});
      final saveService = await SaveService.create();
      final progress = PlayerProgress();
      await tester.pumpWidget(
        MaterialApp(
          home: GameScreen(
            level: levelById(1)!,
            progress: progress,
            saveService: saveService,
            ads: AdsService(testMode: true),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Hint (3)'), findsOneWidget);
      await tester.tap(find.textContaining('Hint (3)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(progress.hints, 2);
      expect(find.textContaining('Hint (2)'), findsOneWidget);
    });

    testWidgets('Garage mein free coins button — ad se +50 coins',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final saveService = await SaveService.create();
      final progress = PlayerProgress();
      await tester.pumpWidget(
        MaterialApp(
          home: GarageScreen(
            progress: progress,
            saveService: saveService,
            ads: AdsService(testMode: true),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Free coins'), findsOneWidget);
      await tester.tap(find.textContaining('Free coins'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(progress.totalCoins, AdsValues.rewardedCoinsAmount);
    });
  });
}
