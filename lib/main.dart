// App yahan se start hoti hai.
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/save_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final saveService = await SaveService.create();
  final progress = saveService.loadProgress();
  runApp(
    TrackBuilderApp(
      progress: progress,
      saveService: saveService,
    ),
  );
}
