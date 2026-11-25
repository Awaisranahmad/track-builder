// Levels 1-3 ki validation — sab se qeemti test.
// Har level: valid data, design doc wali tray, coins duniya ke andar,
// aur tray se gaps cover ho sakte hain (solution maujood hai).
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/core/constants.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/models/piece_type.dart';

void main() {
  group('World 1 levels', () {
    test('teenon levels valid hain', () {
      for (final level in world1Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      // L1: Road x1. L2: Road x2. L3: Road x2.
      expect(level1.trayCount(PieceType.road), 1);
      expect(level1.tray.length, 1);
      expect(level2.trayCount(PieceType.road), 2);
      expect(level3.trayCount(PieceType.road), 2);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level1.name, 'First Gear');
      expect(level2.name, 'Two Gaps');
      expect(level3.name, 'Coin Line');
    });

    test('coins duniya ke andar aur zameen se upar hain', () {
      for (final level in world1Levels) {
        for (final coin in level.coins) {
          expect(coin.x, greaterThanOrEqualTo(0));
          expect(coin.x, lessThanOrEqualTo(WorldSize.width));
          expect(coin.y, greaterThanOrEqualTo(0));
          expect(coin.y, lessThan(WorldSize.groundTop));
        }
      }
    });

    test('tray ke roads se saare gaps cover ho sakte hain', () {
      // Har water zone (gap) ki chaudai <= tray ki kul road lambai.
      // Yehi solution ka wajood hai — fairness rule.
      for (final level in world1Levels) {
        final roadLength =
            level.trayCount(PieceType.road) * PieceType.road.length;
        var gapTotal = 0.0;
        for (final zone in level.waterZones) {
          gapTotal += zone.width;
        }
        expect(
          roadLength,
          greaterThanOrEqualTo(gapTotal),
          reason: 'Level ${level.id}: road $roadLength < gaps $gapTotal',
        );
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world1Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('levelById sahi level deta hai', () {
      expect(levelById(1)?.name, 'First Gear');
      expect(levelById(2)?.name, 'Two Gaps');
      expect(levelById(3)?.name, 'Coin Line');
      expect(levelById(99), isNull);
    });
  });
}
