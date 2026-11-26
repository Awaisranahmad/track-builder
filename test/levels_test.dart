// World 1 ke 12 levels ki validation — sab se qeemti test.
// Har level: valid data, design doc wali tray, coins duniya ke andar,
// aur tray se gaps cover ho sakte hain ya ramp se jump (solution maujood hai).
// Phase 3 mein World 2 aur 3 bhi yahin check hote hain.
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/core/constants.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/levels/world2_levels.dart';
import 'package:track_builder/data/levels/world3_levels.dart';
import 'package:track_builder/data/levels/worlds.dart';
import 'package:track_builder/data/models/piece_type.dart';

void main() {
  group('World 1 levels', () {
    test('baarah levels valid hain', () {
      expect(world1Levels.length, 12);
      for (final level in world1Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      // L1: Road x1. L2: Road x2. L3: Road x2. L4: Road x2.
      expect(level1.trayCount(PieceType.road), 1);
      expect(level2.trayCount(PieceType.road), 2);
      expect(level3.trayCount(PieceType.road), 2);
      expect(level4.trayCount(PieceType.road), 2);
      // L5: Road x1, Ramp x1. L6: Ramp x1, Road x1. L7: Ramp x1.
      expect(level5.trayCount(PieceType.road), 1);
      expect(level5.trayCount(PieceType.ramp), 1);
      expect(level6.trayCount(PieceType.ramp), 1);
      expect(level6.trayCount(PieceType.road), 1);
      expect(level7.trayCount(PieceType.ramp), 1);
      expect(level7.tray.length, 1);
      // L8: Road x2, Ramp x1.
      expect(level8.trayCount(PieceType.road), 2);
      expect(level8.trayCount(PieceType.ramp), 1);
      // L9: Bridge x1, Road x1. L10: Bridge x1, Ramp x1.
      expect(level9.trayCount(PieceType.bridge), 1);
      expect(level9.trayCount(PieceType.road), 1);
      expect(level10.trayCount(PieceType.bridge), 1);
      expect(level10.trayCount(PieceType.ramp), 1);
      // L11: Road x1, Ramp x1, Bridge x1 (ramp spare hai).
      expect(level11.trayCount(PieceType.road), 1);
      expect(level11.trayCount(PieceType.ramp), 1);
      expect(level11.trayCount(PieceType.bridge), 1);
      // L12: Road x2, Ramp x1, Bridge x1.
      expect(level12.trayCount(PieceType.road), 2);
      expect(level12.trayCount(PieceType.ramp), 1);
      expect(level12.trayCount(PieceType.bridge), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level1.name, 'First Gear');
      expect(level2.name, 'Two Gaps');
      expect(level3.name, 'Coin Line');
      expect(level4.name, 'Downhill');
      expect(level5.name, 'Ramp Up');
      expect(level6.name, 'Angle It');
      expect(level7.name, 'Too Fast');
      expect(level8.name, 'Step Up, Step Down');
      expect(level9.name, 'Bridge the Gap');
      expect(level10.name, 'Bridge + Jump');
      expect(level11.name, 'Almost Nothing');
      expect(level12.name, 'Hills Exam');
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

    test('har level mein 3 coins hain', () {
      for (final level in world1Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gaps cover ho sakte hain ya ramp se jump hai', () {
      // Har water zone (gap) ya to road/bridge se cover ho,
      // ya tray mein ramp ho (jump wala hal).
      // Yehi solution ka wajood hai — fairness rule.
      for (final level in world1Levels) {
        final cover = level.trayCount(PieceType.road) * PieceType.road.length +
            level.trayCount(PieceType.bridge) * PieceType.bridge.length;
        var gapTotal = 0.0;
        for (final zone in level.waterZones) {
          gapTotal += zone.width;
        }
        final hasJump = level.trayCount(PieceType.ramp) > 0;
        expect(
          cover >= gapTotal || hasJump,
          isTrue,
          reason: 'Level ${level.id}: cover $cover < gaps $gapTotal, '
              'aur ramp bhi nahi',
        );
      }
    });

    test('bridge 4m ka hai aur implemented hai', () {
      expect(PieceType.bridge.length, 4.0);
      expect(PieceType.bridge.isImplemented, isTrue);
      expect(PieceType.bridge.unlockLevel, 9);
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world1Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('levelById sahi level deta hai', () {
      expect(levelById(1)?.name, 'First Gear');
      expect(levelById(5)?.name, 'Ramp Up');
      expect(levelById(9)?.name, 'Bridge the Gap');
      expect(levelById(12)?.name, 'Hills Exam');
      expect(levelById(13)?.name, 'First Dune');
      expect(levelById(27)?.name, 'Boost!');
      expect(levelById(36)?.name, 'Peaks Exam');
      expect(levelById(37), isNull);
      expect(levelById(99), isNull);
    });

    test('level ids 1-12 lagatar hain', () {
      for (var i = 0; i < world1Levels.length; i++) {
        expect(world1Levels[i].id, i + 1);
        expect(world1Levels[i].world, 1);
        expect(world1Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 2 levels', () {
    test('baarah levels valid hain', () {
      expect(world2Levels.length, 12);
      for (final level in world2Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level13.trayCount(PieceType.road), 2);
      expect(level14.trayCount(PieceType.bridge), 1);
      expect(level14.trayCount(PieceType.road), 1);
      expect(level15.trayCount(PieceType.road), 2);
      expect(level15.trayCount(PieceType.ramp), 1);
      expect(level16.trayCount(PieceType.ramp), 2);
      expect(level17.trayCount(PieceType.road), 1);
      expect(level17.trayCount(PieceType.ramp), 1);
      expect(level18.trayCount(PieceType.bridge), 2);
      expect(level18.trayCount(PieceType.road), 2);
      expect(level19.trayCount(PieceType.ramp), 1);
      expect(level19.trayCount(PieceType.road), 1);
      expect(level20.trayCount(PieceType.road), 1);
      expect(level20.tray.length, 1);
      expect(level21.trayCount(PieceType.bridge), 1);
      expect(level21.trayCount(PieceType.ramp), 1);
      expect(level22.trayCount(PieceType.bridge), 1);
      expect(level22.trayCount(PieceType.ramp), 1);
      expect(level22.trayCount(PieceType.road), 1);
      expect(level23.trayCount(PieceType.road), 2);
      expect(level23.trayCount(PieceType.bridge), 1);
      expect(level23.trayCount(PieceType.ramp), 1);
      expect(level24.trayCount(PieceType.bridge), 1);
      expect(level24.trayCount(PieceType.ramp), 2);
      expect(level24.trayCount(PieceType.road), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level13.name, 'First Dune');
      expect(level14.name, 'Long Crossing');
      expect(level15.name, 'Cactus Alley');
      expect(level16.name, 'Half Pipe');
      expect(level17.name, 'Soft Landing');
      expect(level18.name, 'Three Bridges');
      expect(level19.name, 'Rock Block');
      expect(level20.name, 'Dune Surf');
      expect(level21.name, 'The Long Way Down');
      expect(level22.name, 'Mirage');
      expect(level23.name, 'Sandstorm Run');
      expect(level24.name, 'Dunes Exam');
    });

    test('surface sand hai', () {
      for (final level in world2Levels) {
        expect(level.surface, SurfaceType.sand, reason: 'Level ${level.id}');
      }
    });

    test('coins 3-5 hain aur duniya ke andar hain', () {
      for (final level in world2Levels) {
        expect(level.coins.length, greaterThanOrEqualTo(3));
        expect(level.coins.length, lessThanOrEqualTo(5));
        for (final coin in level.coins) {
          expect(coin.x, greaterThanOrEqualTo(0));
          expect(coin.x, lessThanOrEqualTo(WorldSize.width));
          expect(coin.y, greaterThanOrEqualTo(0));
          // groundTop (9.0) nahi — L16 ki valley floor y=10 par hai,
          // us ka coin (8, 9.3) zameen ke neeche nahi, valley mein hai.
          expect(coin.y, lessThan(WorldSize.height));
        }
      }
    });

    test('gaps cover ho sakte hain ya ramp se jump hai', () {
      for (final level in world2Levels) {
        final cover = level.trayCount(PieceType.road) * PieceType.road.length +
            level.trayCount(PieceType.bridge) * PieceType.bridge.length;
        var gapTotal = 0.0;
        for (final zone in level.waterZones) {
          gapTotal += zone.width;
        }
        final hasJump = level.trayCount(PieceType.ramp) > 0;
        expect(
          cover >= gapTotal || hasJump,
          isTrue,
          reason: 'Level ${level.id}: cover $cover < gaps $gapTotal, '
              'aur ramp bhi nahi',
        );
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world2Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 13-24 lagatar hain', () {
      for (var i = 0; i < world2Levels.length; i++) {
        expect(world2Levels[i].id, i + 13);
        expect(world2Levels[i].world, 2);
        expect(world2Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 3 levels', () {
    test('baarah levels valid hain', () {
      expect(world3Levels.length, 12);
      for (final level in world3Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level25.trayCount(PieceType.road), 2);
      expect(level26.trayCount(PieceType.road), 1);
      expect(level26.tray.length, 1);
      expect(level27.trayCount(PieceType.booster), 1);
      expect(level27.trayCount(PieceType.ramp), 1);
      expect(level28.trayCount(PieceType.bridge), 1);
      expect(level28.trayCount(PieceType.road), 1);
      expect(level29.trayCount(PieceType.booster), 1);
      expect(level29.trayCount(PieceType.ramp), 1);
      expect(level30.trayCount(PieceType.road), 2);
      expect(level30.trayCount(PieceType.ramp), 1);
      expect(level31.trayCount(PieceType.booster), 1);
      expect(level31.trayCount(PieceType.ramp), 1);
      expect(level31.trayCount(PieceType.road), 1);
      expect(level32.trayCount(PieceType.road), 2);
      expect(level32.trayCount(PieceType.bridge), 1);
      expect(level33.trayCount(PieceType.booster), 2);
      expect(level33.trayCount(PieceType.ramp), 2);
      expect(level34.trayCount(PieceType.bridge), 1);
      expect(level34.tray.length, 1);
      expect(level35.trayCount(PieceType.road), 2);
      expect(level35.trayCount(PieceType.ramp), 1);
      expect(level36.trayCount(PieceType.booster), 1);
      expect(level36.trayCount(PieceType.bridge), 1);
      expect(level36.trayCount(PieceType.ramp), 1);
      expect(level36.trayCount(PieceType.road), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level25.name, 'First Ice');
      expect(level26.name, 'Brake Early');
      expect(level27.name, 'Boost!');
      expect(level28.name, 'Ice Ice Baby');
      expect(level29.name, 'Too Much Boost');
      expect(level30.name, 'Pine Forest');
      expect(level31.name, 'Frozen Waterfall');
      expect(level32.name, 'Whiteout');
      expect(level33.name, 'Double Boost');
      expect(level34.name, 'Thin Ice');
      expect(level35.name, 'Avalanche Alley');
      expect(level36.name, 'Peaks Exam');
    });

    test('surface ice hai', () {
      for (final level in world3Levels) {
        expect(level.surface, SurfaceType.ice, reason: 'Level ${level.id}');
      }
    });

    test('booster sirf World 3 mein hai (Level 27 se unlock)', () {
      expect(PieceType.booster.unlockLevel, 27);
      expect(PieceType.booster.isImplemented, isTrue);
      for (final level in world2Levels) {
        expect(level.trayCount(PieceType.booster), 0);
      }
    });

    test('coins 3-5 hain aur duniya ke andar hain', () {
      for (final level in world3Levels) {
        expect(level.coins.length, greaterThanOrEqualTo(3));
        expect(level.coins.length, lessThanOrEqualTo(5));
        for (final coin in level.coins) {
          expect(coin.x, greaterThanOrEqualTo(0));
          expect(coin.x, lessThanOrEqualTo(WorldSize.width));
          expect(coin.y, greaterThanOrEqualTo(0));
          expect(coin.y, lessThan(WorldSize.groundTop));
        }
      }
    });

    test('gaps cover ho sakte hain ya ramp/booster se jump hai', () {
      for (final level in world3Levels) {
        final cover = level.trayCount(PieceType.road) * PieceType.road.length +
            level.trayCount(PieceType.bridge) * PieceType.bridge.length;
        var gapTotal = 0.0;
        for (final zone in level.waterZones) {
          gapTotal += zone.width;
        }
        final hasJump = level.trayCount(PieceType.ramp) > 0 ||
            level.trayCount(PieceType.booster) > 0;
        expect(
          cover >= gapTotal || hasJump,
          isTrue,
          reason: 'Level ${level.id}: cover $cover < gaps $gapTotal, '
              'aur jump bhi nahi',
        );
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world3Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 25-36 lagatar hain', () {
      for (var i = 0; i < world3Levels.length; i++) {
        expect(world3Levels[i].id, i + 25);
        expect(world3Levels[i].world, 3);
        expect(world3Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('Saare levels', () {
    test('kul 36 levels hain', () {
      expect(allLevels.length, 36);
    });

    test('worlds 2-3 ki levels worlds list mein hain', () {
      expect(worlds[1].levels.length, 12);
      expect(worlds[2].levels.length, 12);
      expect(worlds[1].maxStars, 36);
      expect(worlds[2].maxStars, 36);
    });
  });
}
