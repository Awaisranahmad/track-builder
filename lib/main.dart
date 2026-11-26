// App yahan se start hoti hai.
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/save_service.dart';
import 'services/ads_service.dart';
import 'services/audio_service.dart';
import 'services/sprite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final saveService = await SaveService.create();
  final progress = saveService.loadProgress();
  // Audio tayyar karo — saved settings ke mutabiq.
  audioService.musicOn = progress.musicOn;
  audioService.sfxOn = progress.sfxOn;
  await audioService.init();
  // Sprites pehle se load karo — game ki onLoad mein sirf cache hit ho.
  await SpriteService.preloadAll();
  // Ads tayyar karo — AdMob wire na ho to stub rehta hai (game chalta hai).
  await adsService.init();
  if (progress.musicOn) {
    await audioService.startMusic();
  }
  runApp(
    TrackBuilderApp(
      progress: progress,
      saveService: saveService,
    ),
  );
}
