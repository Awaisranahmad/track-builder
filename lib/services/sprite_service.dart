// Sprite loading — Phase 4: shapes ki jagah images.
// Har component apni sprite yahan se mangta hai; load na ho (test
// environment, missing asset) to null milta hai aur component apni
// purani shape wali drawing par wapas chala jata hai — game kabhi
// sprite ki wajah se nahi rukta.
// Flame.images ka prefix 'assets/images/' hai, is liye paths us ke
// baad se likhe jate hain.
import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

import '../data/models/car_data.dart';

/// Saare sprite paths ek jagah — naam se pata chale cheez kya hai.
class SpritePaths {
  static String car(String carId) => 'cars/car_$carId.png';
  static const String wheel = 'cars/wheel.png';
  static const String road = 'pieces/road.png';
  static const String ramp = 'pieces/ramp.png';
  static const String bridge = 'pieces/bridge.png';
  static const String booster = 'pieces/booster.png';
  static const String coin = 'ui/coin.png';
  static const String flag = 'ui/flag.png';
  static const String smoke = 'effects/smoke.png';
  static const String spark = 'effects/spark.png';

  /// World 1-3 ka background — baaki worlds Phase 5 mein.
  static String background(int world) => 'backgrounds/bg_world$world.png';
}

class SpriteService {
  /// Ek dafa load hui sprite dobara load nahi hoti (cache).
  static final Map<String, Sprite?> _cache = {};

  /// Test mode — sirf tests mein on karo.
  /// Is VM ke flutter_tester mein asal PNG decode (decodeImageFromList)
  /// ke baad agla frame/decode atak jata hai, is liye tests mein
  /// PictureRecorder se bana placeholder image istemal hota hai —
  /// bina decode ke. Game ka sprite-render path phir bhi poora test hota hai
  /// (SpriteComponent + render), sirf pixels placeholder hote hain.
  /// Asal PNG files ki validity alag test mein (rootBundle header check)
  /// aur aankh se (visual check) verify hoti hai.
  static bool testMode = false;
  static final Map<String, Sprite> _placeholders = {};

  static Future<ui.Image> _placeholderImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRect(
      const ui.Rect.fromLTWH(0, 0, 100, 100),
      ui.Paint()..color = const ui.Color(0xFF808080),
    );
    final picture = recorder.endRecording();
    return picture.toImage(100, 100);
  }

  /// Sprite lao — na mile to null (caller shape drawing kare).
  /// Pehle asset ka hona check karo: Flame ka Images cache failed load
  /// par andar hi unhandled error chhor deta hai (us ke .then mein
  /// onError nahi hai) — is liye missing asset par Sprite.load
  /// kabhi bulaya hi nahi jata.
  static Future<Sprite?> load(String path) async {
    if (testMode) {
      final placeholder = _placeholders[path];
      if (placeholder != null) return placeholder;
      final sprite = Sprite(await _placeholderImage());
      _placeholders[path] = sprite;
      return sprite;
    }
    if (_cache.containsKey(path)) return _cache[path];
    try {
      await rootBundle.load('assets/images/$path');
    } catch (_) {
      _cache[path] = null;
      return null;
    }
    try {
      final sprite = await Sprite.load(path);
      _cache[path] = sprite;
      return sprite;
    } catch (_) {
      _cache[path] = null;
      return null;
    }
  }

  /// Cache mein hai ya nahi — test ke liye.
  static bool isCached(String path) => _cache.containsKey(path);

  /// Saare sprites pehle se load karo — app start par (main.dart) aur
  /// tests mein game banane se pehle. Is se components ki onLoad mein
  /// sirf cache hit hota hai, dobara decode nahi hota.
  /// (Is VM ke flutter_tester mein game ki onLoad ke andar decode
  /// atak jata hai — test body mein preload karna zaroori hai.)
  static Future<void> preloadAll() async {
    final paths = <String>[
      for (final car in allCars) SpritePaths.car(car.id),
      SpritePaths.wheel,
      SpritePaths.road,
      SpritePaths.ramp,
      SpritePaths.bridge,
      SpritePaths.booster,
      SpritePaths.coin,
      SpritePaths.flag,
      for (var w = 1; w <= 3; w++) SpritePaths.background(w),
      SpritePaths.smoke,
      SpritePaths.spark,
    ];
    for (final path in paths) {
      await load(path);
    }
  }

  /// Tests ke liye — cache saaf karo.
  static void clearCache() {
    _cache.clear();
    _placeholders.clear();
  }

  /// Flame image cache bhi saaf karo (test isolation).
  static void clearFlameCache() => Flame.images.clearCache();
}
