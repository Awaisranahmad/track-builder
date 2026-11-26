// World 1 ke 12 levels ki validation — sab se qeemti test.
// Har level: valid data, design doc wali tray, coins duniya ke andar,
// aur tray se gaps cover ho sakte hain ya ramp se jump (solution maujood hai).
// Phase 3 mein World 2 aur 3 bhi yahin check hote hain.
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/core/constants.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/levels/world2_levels.dart';
import 'package:track_builder/data/levels/world3_levels.dart';
import 'package:track_builder/data/levels/world4_levels.dart';
import 'package:track_builder/data/levels/world5_levels.dart';
import 'package:track_builder/data/levels/world6_levels.dart';
import 'package:track_builder/data/levels/world7_levels.dart';
import 'package:track_builder/data/levels/world8_levels.dart';
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
      expect(levelById(37)?.name, 'Rooftops');
      expect(levelById(48)?.name, 'City Exam');
      expect(levelById(60)?.name, 'Ruins Exam');
      expect(levelById(72)?.name, 'Station Exam');
      expect(levelById(84)?.name, 'Volcano Exam');
      expect(levelById(96)?.name, 'Master Builder');
      expect(levelById(97), isNull);
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

  group('World 4 levels', () {
    test('baarah levels valid hain', () {
      expect(world4Levels.length, 12);
      for (final level in world4Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level37.trayCount(PieceType.road), 2);
      expect(level37.trayCount(PieceType.ramp), 1);
      expect(level38.trayCount(PieceType.road), 1);
      expect(level38.tray.length, 1);
      expect(level39.trayCount(PieceType.ramp), 1);
      expect(level39.trayCount(PieceType.road), 1);
      expect(level40.trayCount(PieceType.loop), 1);
      expect(level40.trayCount(PieceType.booster), 1);
      expect(level41.trayCount(PieceType.loop), 1);
      expect(level41.trayCount(PieceType.bridge), 1);
      expect(level42.trayCount(PieceType.road), 1);
      expect(level42.trayCount(PieceType.booster), 1);
      expect(level43.trayCount(PieceType.ramp), 2);
      expect(level43.trayCount(PieceType.road), 1);
      expect(level44.trayCount(PieceType.booster), 1);
      expect(level44.trayCount(PieceType.ramp), 1);
      expect(level45.trayCount(PieceType.loop), 2);
      expect(level45.trayCount(PieceType.booster), 1);
      expect(level46.trayCount(PieceType.loop), 1);
      expect(level46.trayCount(PieceType.road), 2);
      expect(level47.trayCount(PieceType.bridge), 1);
      expect(level47.trayCount(PieceType.ramp), 1);
      expect(level48.trayCount(PieceType.loop), 1);
      expect(level48.trayCount(PieceType.booster), 1);
      expect(level48.trayCount(PieceType.road), 2);
      expect(level48.trayCount(PieceType.ramp), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level37.name, 'Rooftops');
      expect(level38.name, 'The Lift');
      expect(level39.name, 'Neon Alley');
      expect(level40.name, 'Loop the Loop');
      expect(level41.name, 'Loop + Landing');
      expect(level42.name, 'Traffic Lights');
      expect(level43.name, 'Parking Garage');
      expect(level44.name, 'Billboard Jump');
      expect(level45.name, 'Double Loop');
      expect(level46.name, 'Rush Hour');
      expect(level47.name, 'Blackout');
      expect(level48.name, 'City Exam');
    });

    test('loop sirf Level 40 se unlock (World 4)', () {
      expect(PieceType.loop.unlockLevel, 40);
      expect(PieceType.loop.isImplemented, isTrue);
    });

    test('har level mein 3 coins hain', () {
      for (final level in world4Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world4Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 37-48 lagatar hain', () {
      for (var i = 0; i < world4Levels.length; i++) {
        expect(world4Levels[i].id, i + 37);
        expect(world4Levels[i].world, 4);
        expect(world4Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 5 levels', () {
    test('baarah levels valid hain', () {
      expect(world5Levels.length, 12);
      for (final level in world5Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level49.trayCount(PieceType.road), 2);
      expect(level49.trayCount(PieceType.ramp), 1);
      expect(level50.trayCount(PieceType.spring), 1);
      expect(level50.trayCount(PieceType.road), 1);
      expect(level51.trayCount(PieceType.spring), 2);
      expect(level51.trayCount(PieceType.road), 1);
      expect(level52.trayCount(PieceType.road), 2);
      expect(level52.trayCount(PieceType.bridge), 1);
      expect(level53.trayCount(PieceType.ramp), 3);
      expect(level53.tray.length, 1);
      expect(level54.trayCount(PieceType.spring), 1);
      expect(level54.trayCount(PieceType.road), 1);
      expect(level55.trayCount(PieceType.spring), 1);
      expect(level55.trayCount(PieceType.ramp), 1);
      expect(level55.trayCount(PieceType.bridge), 1);
      expect(level56.trayCount(PieceType.road), 2);
      expect(level56.tray.length, 1);
      expect(level57.trayCount(PieceType.bridge), 1);
      expect(level57.trayCount(PieceType.spring), 1);
      expect(level58.trayCount(PieceType.road), 2);
      expect(level58.trayCount(PieceType.spring), 1);
      expect(level59.trayCount(PieceType.ramp), 2);
      expect(level59.trayCount(PieceType.spring), 1);
      expect(level59.trayCount(PieceType.road), 1);
      expect(level60.trayCount(PieceType.spring), 1);
      expect(level60.trayCount(PieceType.bridge), 1);
      expect(level60.trayCount(PieceType.ramp), 1);
      expect(level60.trayCount(PieceType.road), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level49.name, 'Ruins Entrance');
      expect(level50.name, 'Bounce!');
      expect(level51.name, 'Double Bounce');
      expect(level52.name, 'Falling Rocks');
      expect(level53.name, 'Temple Steps');
      expect(level54.name, 'The Well');
      expect(level55.name, 'Vine Swing');
      expect(level56.name, 'Crumble Stone');
      expect(level57.name, 'Rock Rain');
      expect(level58.name, 'Hidden Coins');
      expect(level59.name, 'Temple Run');
      expect(level60.name, 'Ruins Exam');
    });

    test('spring sirf Level 50 se unlock (World 5)', () {
      expect(PieceType.spring.unlockLevel, 50);
      expect(PieceType.spring.isImplemented, isTrue);
    });

    test('har level mein 3 coins hain', () {
      for (final level in world5Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world5Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 49-60 lagatar hain', () {
      for (var i = 0; i < world5Levels.length; i++) {
        expect(world5Levels[i].id, i + 49);
        expect(world5Levels[i].world, 5);
        expect(world5Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 6 levels', () {
    test('baarah levels valid hain', () {
      expect(world6Levels.length, 12);
      for (final level in world6Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level61.trayCount(PieceType.ramp), 1);
      expect(level61.trayCount(PieceType.road), 1);
      expect(level62.trayCount(PieceType.magnet), 1);
      expect(level62.trayCount(PieceType.road), 1);
      expect(level63.trayCount(PieceType.ramp), 1);
      expect(level63.tray.length, 1);
      expect(level64.trayCount(PieceType.road), 1);
      expect(level64.trayCount(PieceType.booster), 1);
      expect(level65.trayCount(PieceType.magnet), 1);
      expect(level65.tray.length, 1);
      expect(level66.trayCount(PieceType.seesaw), 1);
      expect(level66.tray.length, 1);
      expect(level67.trayCount(PieceType.seesaw), 1);
      expect(level67.trayCount(PieceType.ramp), 1);
      expect(level68.trayCount(PieceType.seesaw), 1);
      expect(level68.trayCount(PieceType.road), 1);
      expect(level69.trayCount(PieceType.magnet), 2);
      expect(level69.trayCount(PieceType.road), 1);
      expect(level70.trayCount(PieceType.ramp), 1);
      expect(level70.trayCount(PieceType.booster), 1);
      expect(level71.trayCount(PieceType.road), 1);
      expect(level71.trayCount(PieceType.ramp), 1);
      expect(level72.trayCount(PieceType.magnet), 1);
      expect(level72.trayCount(PieceType.seesaw), 1);
      expect(level72.trayCount(PieceType.road), 1);
      expect(level72.trayCount(PieceType.ramp), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level61.name, 'Zero-G');
      expect(level62.name, 'Ceiling Drive');
      expect(level63.name, 'Float and Drop');
      expect(level64.name, 'Airlock');
      expect(level65.name, 'Orbit');
      expect(level66.name, 'Balance Point');
      expect(level67.name, 'Tip and Launch');
      expect(level68.name, 'Low-G Seesaw');
      expect(level69.name, 'Gravity Flip');
      expect(level70.name, 'Asteroid Field');
      expect(level71.name, 'Docking Bay');
      expect(level72.name, 'Station Exam');
    });

    test('magnet Level 61 aur see-saw Level 66 se unlock (World 6)', () {
      expect(PieceType.magnet.unlockLevel, 61);
      expect(PieceType.seesaw.unlockLevel, 66);
      expect(PieceType.magnet.isImplemented, isTrue);
      expect(PieceType.seesaw.isImplemented, isTrue);
    });

    test('har level mein 3 coins hain', () {
      for (final level in world6Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world6Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 61-72 lagatar hain', () {
      for (var i = 0; i < world6Levels.length; i++) {
        expect(world6Levels[i].id, i + 61);
        expect(world6Levels[i].world, 6);
        expect(world6Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 7 levels', () {
    test('baarah levels valid hain', () {
      expect(world7Levels.length, 12);
      for (final level in world7Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level73.trayCount(PieceType.bridge), 1);
      expect(level73.trayCount(PieceType.road), 1);
      expect(level74.trayCount(PieceType.bridge), 1);
      expect(level74.trayCount(PieceType.road), 1);
      expect(level75.trayCount(PieceType.booster), 1);
      expect(level75.trayCount(PieceType.road), 1);
      expect(level76.trayCount(PieceType.road), 2);
      expect(level76.trayCount(PieceType.ramp), 1);
      expect(level77.trayCount(PieceType.bridge), 1);
      expect(level77.trayCount(PieceType.ramp), 1);
      expect(level77.trayCount(PieceType.booster), 1);
      expect(level78.trayCount(PieceType.road), 1);
      expect(level78.tray.length, 1);
      expect(level79.trayCount(PieceType.loop), 1);
      expect(level79.trayCount(PieceType.booster), 1);
      expect(level80.trayCount(PieceType.ramp), 2);
      expect(level80.trayCount(PieceType.spring), 1);
      expect(level80.trayCount(PieceType.road), 1);
      expect(level81.trayCount(PieceType.bridge), 1);
      expect(level81.trayCount(PieceType.road), 2);
      expect(level82.trayCount(PieceType.seesaw), 1);
      expect(level82.trayCount(PieceType.road), 1);
      expect(level83.trayCount(PieceType.bridge), 1);
      expect(level83.trayCount(PieceType.booster), 1);
      expect(level83.trayCount(PieceType.ramp), 1);
      expect(level84.trayCount(PieceType.loop), 1);
      expect(level84.trayCount(PieceType.bridge), 1);
      expect(level84.trayCount(PieceType.booster), 1);
      expect(level84.trayCount(PieceType.road), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level73.name, 'Lava Line');
      expect(level74.name, 'Hot Bridge');
      expect(level75.name, 'Gate Keeper');
      expect(level76.name, 'Eruption');
      expect(level77.name, 'Lava Run');
      expect(level78.name, 'Cooling Rocks');
      expect(level79.name, 'Double Gate Loop');
      expect(level80.name, 'Rising Lava');
      expect(level81.name, 'Ember Rain');
      expect(level82.name, 'The Crucible');
      expect(level83.name, 'Last Bridge');
      expect(level84.name, 'Volcano Exam');
    });

    test('har level mein 3 coins hain', () {
      for (final level in world7Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world7Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 73-84 lagatar hain', () {
      for (var i = 0; i < world7Levels.length; i++) {
        expect(world7Levels[i].id, i + 73);
        expect(world7Levels[i].world, 7);
        expect(world7Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('World 8 levels', () {
    test('baarah levels valid hain', () {
      expect(world8Levels.length, 12);
      for (final level in world8Levels) {
        final errors = level.validate(
          worldWidth: WorldSize.width,
          worldHeight: WorldSize.height,
        );
        expect(errors, isEmpty, reason: 'Level ${level.id}: $errors');
      }
    });

    test('tray design doc ke mutabiq hai', () {
      expect(level85.trayCount(PieceType.bridge), 1);
      expect(level85.trayCount(PieceType.road), 1);
      expect(level85.trayCount(PieceType.ramp), 1);
      expect(level86.trayCount(PieceType.ramp), 1);
      expect(level86.tray.length, 1);
      expect(level87.trayCount(PieceType.booster), 1);
      expect(level87.trayCount(PieceType.ramp), 1);
      expect(level88.trayCount(PieceType.road), 3);
      expect(level88.trayCount(PieceType.spring), 1);
      expect(level89.trayCount(PieceType.loop), 1);
      expect(level89.trayCount(PieceType.booster), 1);
      expect(level90.trayCount(PieceType.seesaw), 1);
      expect(level90.trayCount(PieceType.road), 1);
      expect(level91.trayCount(PieceType.magnet), 1);
      expect(level91.trayCount(PieceType.ramp), 1);
      expect(level92.trayCount(PieceType.booster), 1);
      expect(level92.trayCount(PieceType.bridge), 1);
      expect(level92.trayCount(PieceType.road), 1);
      expect(level93.trayCount(PieceType.road), 1);
      expect(level93.trayCount(PieceType.ramp), 1);
      // L94: har piece ek dafa.
      for (final type in PieceType.values) {
        expect(level94.trayCount(type), 1, reason: 'L94: $type');
      }
      expect(level95.trayCount(PieceType.ramp), 1);
      expect(level95.trayCount(PieceType.spring), 1);
      // L96: fixed 6-piece tray (free-choice picker abhi nahi bana).
      expect(level96.tray.length, 6);
      expect(level96.trayCount(PieceType.loop), 1);
      expect(level96.trayCount(PieceType.booster), 1);
    });

    test('naam design doc ke mutabiq hain', () {
      expect(level85.name, 'First Island');
      expect(level86.name, 'Tailwind');
      expect(level87.name, 'Headwind');
      expect(level88.name, 'Island Hop');
      expect(level89.name, 'Cloud Loop');
      expect(level90.name, 'Sky Seesaw');
      expect(level91.name, 'Zero-G Sky');
      expect(level92.name, 'Storm Run');
      expect(level93.name, 'Almost Nothing II');
      expect(level94.name, 'Every Piece');
      expect(level95.name, 'The Long Fall');
      expect(level96.name, 'Master Builder');
    });

    test('har level mein 3 coins hain', () {
      for (final level in world8Levels) {
        expect(level.coins.length, 3, reason: 'Level ${level.id}');
      }
    });

    test('gold time positive aur munasib hai', () {
      for (final level in world8Levels) {
        expect(level.goldTimeSeconds, greaterThan(5));
        expect(level.goldTimeSeconds, lessThan(60));
      }
    });

    test('level ids 85-96 lagatar hain', () {
      for (var i = 0; i < world8Levels.length; i++) {
        expect(world8Levels[i].id, i + 85);
        expect(world8Levels[i].world, 8);
        expect(world8Levels[i].levelInWorld, i + 1);
      }
    });
  });

  group('Saare levels', () {
    test('kul 96 levels hain', () {
      expect(allLevels.length, 96);
    });

    test('worlds 2-8 ki levels worlds list mein hain', () {
      for (var i = 1; i < 8; i++) {
        expect(worlds[i].levels.length, 12, reason: 'World ${i + 1}');
        expect(worlds[i].maxStars, 36, reason: 'World ${i + 1}');
      }
    });
  });
}
