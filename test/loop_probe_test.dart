// Debug probe — loop mein gari kya karti hai, step by step.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';

import 'phase5_tuning_test.dart' show loopLevel;

void main() {
  testWidgets('loop probe', (tester) async {
    SpriteService.testMode = true;
    await SpriteService.preloadAll();
    SharedPreferences.setMockInitialValues({});
    final saveService = await SaveService.create();
    final game = TrackBuilderGame(
      level: loopLevel,
      progress: PlayerProgress(),
      saveService: saveService,
      audio: AudioService(testMode: true),
    );
    await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
    for (var i = 0; i < 100 && !game.isLoaded; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    game.buildManager.placeAt(Vector2(3.2, 9.3), PieceType.booster);
    game.buildManager.placeAt(Vector2(10, 7.0), PieceType.loop);
    await tester.pump();
    game.startDrive();
    game.setGas(true);
    for (var step = 0; step < 120; step++) {
      await tester.pump(const Duration(milliseconds: 16));
      if (step % 10 == 0) {
        final pos = game.car.position;
        final fw = game.car.frontWheelPosition;
        final rw = game.car.rearWheelPosition;
        // ignore: avoid_print
        print(
          't=${(step * 0.016).toStringAsFixed(2)} '
          'pos=(${pos.x.toStringAsFixed(2)}, ${pos.y.toStringAsFixed(2)}) '
          'angle=${game.car.angle.toStringAsFixed(2)} '
          'speed=${game.car.speed.toStringAsFixed(2)} '
          'fw=(${fw.x.toStringAsFixed(2)}, ${fw.y.toStringAsFixed(2)}) '
          'rw=(${rw.x.toStringAsFixed(2)}, ${rw.y.toStringAsFixed(2)}) '
          'inLoop=${game.car.isInLoop} phase=${game.phase}',
        );
      }
      if (game.phase == GamePhase.result) {
        // ignore: avoid_print
        print('RESULT: ${game.resultNotifier.value?.failReason} '
            'stars=${game.resultNotifier.value?.stars}');
        break;
      }
    }
  });
}
