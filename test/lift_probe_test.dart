// Debug probe — lift par gari kya karti hai, step by step.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';

import 'phase5_tuning_test.dart' show liftLevel;

void main() {
  testWidgets('lift probe', (tester) async {
    SpriteService.testMode = true;
    await SpriteService.preloadAll();
    SharedPreferences.setMockInitialValues({});
    final saveService = await SaveService.create();
    final game = TrackBuilderGame(
      level: liftLevel,
      progress: PlayerProgress(),
      saveService: saveService,
      audio: AudioService(testMode: true),
    );
    await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
    for (var i = 0; i < 100 && !game.isLoaded; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    game.startDrive();
    var elapsed = 0.0;
    for (var step = 0; step < 600; step++) {
      if (elapsed < 1.2) {
        game.setGas(true);
      } else if (elapsed < 3.5) {
        game.setGas(false);
      } else {
        game.setGas(true);
      }
      await tester.pump(const Duration(milliseconds: 16));
      elapsed += 0.016;
      if (step % 10 == 0) {
        final pos = game.car.position;
        // ignore: avoid_print
        print(
          't=${elapsed.toStringAsFixed(2)} '
          'pos=(${pos.x.toStringAsFixed(2)}, ${pos.y.toStringAsFixed(2)}) '
          'angle=${game.car.angle.toStringAsFixed(2)} '
          'speed=${game.car.speed.toStringAsFixed(2)} '
          'phase=${game.phase}',
        );
      }
      if (game.phase == GamePhase.result) {
        // ignore: avoid_print
        print('RESULT: ${game.resultNotifier.value?.failReason} '
            'stars=${game.resultNotifier.value?.stars} '
            'coins=${game.resultNotifier.value?.coinsCollected}');
        break;
      }
    }
  });
}
