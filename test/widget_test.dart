// App start hoti hai — smoke test.
// Flow: Home (Play) → World Map → Level Select → Game Screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/app/app.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/services/sprite_service.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  // Test mode: asal PNG decode nahi — placeholder sprites.
  SpriteService.testMode = true;
  await SpriteService.preloadAll();
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final progress = saveService.loadProgress();

  // Lamba viewport — World Map (8) aur Level Select (12) ki
  // saari tiles ek saath dikhen, ListView lazy build ki wajah se
  // aakhri items chhup na jayen.
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: TrackBuilderApp(
        progress: progress,
        saveService: saveService,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('Home screen dikhti hai — Play button, stars, coins',
      (tester) async {
    await _pumpApp(tester);

    expect(find.text('Track Builder'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Garage'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    // Shuru mein 0 stars, 0 coins.
    expect(find.textContaining('0 stars'), findsOneWidget);
    expect(find.textContaining('0 coins'), findsOneWidget);
    // Home par level list nahi — wo Level Select mein hai.
    expect(find.text('First Gear'), findsNothing);
  });

  testWidgets('Play → World Map — 8 worlds, sirf World 1 khula',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Play'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Worlds'), findsOneWidget);
    expect(find.text('Green Hills'), findsOneWidget);
    expect(find.text('Desert Dunes'), findsOneWidget);
    expect(find.text('Sky Islands'), findsOneWidget);
    // Sirf World 1 khula (play) — baaki 7 lock hain.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsNWidgets(7));
  });

  testWidgets('Locked world tap karne par snack bar aata hai',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Play'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Desert Dunes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('20 stars'), findsOneWidget);
  });

  testWidgets('World 1 → Level Select — 12 levels, sirf Level 1 khula',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Play'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Green Hills'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Green Hills'), findsOneWidget);
    expect(find.text('First Gear'), findsOneWidget);
    expect(find.text('Hills Exam'), findsOneWidget);
    // Sirf Level 1 khula — baaki 11 lock hain.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsNWidgets(11));
  });

  testWidgets('Level 1 tap karne par Game Screen khulti hai',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Play'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Green Hills'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('First Gear'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Level 1'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);
  });

  testWidgets('Garage button Garage screen kholta hai — 5 gariyan',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Garage'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Garage'), findsOneWidget);
    expect(find.text('Starter Bug'), findsOneWidget);
    expect(find.text('Desert Pickup'), findsOneWidget);
    expect(find.text('Snow Rally'), findsOneWidget);
    expect(find.text('City Racer'), findsOneWidget);
    expect(find.text('Rocket Van'), findsOneWidget);
    // Starter Bug selected hai — baaki khareedni hain (0 coins, is liye
    // 'Need ... coins' dikhta hai, 'Buy' nahi).
    expect(find.text('Selected'), findsOneWidget);
    expect(find.textContaining('Need'), findsNWidgets(4));
  });

  testWidgets('Settings button Settings screen kholta hai', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Music'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);
    expect(find.text('Reset Progress'), findsOneWidget);
  });

  testWidgets('Garage mein gari khareedna kaam karta hai', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final saveService = await SaveService.create();
    final progress = saveService.loadProgress();
    progress.totalCoins = 500;

    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: TrackBuilderApp(
          progress: progress,
          saveService: saveService,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Garage'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Desert Pickup (300 coins) khareedo.
    await tester.tap(find.textContaining('Buy — 300 coins'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Selected'), findsNWidgets(1));
    expect(progress.ownedCars.contains('desert_pickup'), isTrue);
    expect(progress.totalCoins, 200);
  });
}
