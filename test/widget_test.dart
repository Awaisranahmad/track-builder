// App start hoti hai — smoke test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/app/app.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';

void main() {
  testWidgets('Home screen dikhti hai, Level 1-3 ki list hai',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final saveService = await SaveService.create();
    final progress = saveService.loadProgress();

    await tester.pumpWidget(
      MaterialApp(
        home: TrackBuilderApp(
          progress: progress,
          saveService: saveService,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Track Builder'), findsOneWidget);
    expect(find.text('First Gear'), findsOneWidget);
    expect(find.text('Two Gaps'), findsOneWidget);
    expect(find.text('Coin Line'), findsOneWidget);
    // Sirf Level 1 khula hai (play) — Level 2-3 lock hain.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsNWidgets(2));
  });

  testWidgets('Level 1 tap karne par Game Screen khulti hai',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final saveService = await SaveService.create();
    final progress = PlayerProgress();

    await tester.pumpWidget(
      MaterialApp(
        home: TrackBuilderApp(
          progress: progress,
          saveService: saveService,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('First Gear'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Level 1'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);
  });
}
