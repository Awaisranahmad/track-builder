# Track Builder — Puzzle Drive

Puzzle-driving game: pehle track banao, phir gari us par physics ke saath chalao.
Flutter + Flame (game engine) + flame_forge2d (physics).

## Game kya hai

Har level mein 3 phases hain:

1. **Build** — tray se pieces (road, ramp, bridge...) drag karke track banao.
2. **Drive** — GO dabao, 2 buttons se gari chalao (gas / brake-tilt). Physics
   faisla karegi: idea brilliant tha ya disaster.
3. **Result** — finish = 1 star, saare coins = 1 star, gold time = 1 star.

8 worlds, 96 levels, 8 pieces. Web pehle (itch.io / CrazyGames), phir Android.

## Chalana

```sh
flutter pub get
flutter run
```

Tests:

```sh
flutter analyze
flutter test
```

## Project structure

```
lib/
├── main.dart              # App entry
├── app/                   # MaterialApp, routes
├── core/                  # constants, game_config (saari values yahin)
├── data/
│   ├── models/            # LevelData, PieceType, PlayerProgress, CarData
│   ├── levels/            # Har world ki level definitions (Dart data, JSON nahi)
│   │   └── worlds.dart    # 8 worlds ki list (World Map ke liye)
│   └── save_service.dart  # Progress save/load (shared_preferences)
├── game/
│   ├── track_builder_game.dart  # FlameGame, phases
│   ├── components/        # Car, TrackPiece, Terrain, Coin, FinishFlag,
│   │                      # GhostHint (hint ghost), Snowball (L35 hazard)
│   └── managers/          # Build, Drive, Camera, Effects (particles+shake),
│                          # Hint (ghost solution)
├── ui/
│   ├── screens/           # Home, World Map, Level Select, Game Screen
│   ├── widgets/           # Tray chip, hold button, timer
│   └── overlays/          # Result overlay
├── garage/                # Garage (5 cars, coins se khareedo)
└── services/              # Audio, Ads, Sprites
```

Sprites dobara generate karne ke liye: `python3 tools/generate_sprites.py`
(PIL chahiye) — phir `flutter pub get`. Solutions (hint data) dobara
generate karne ke liye: `python3 tools/generate_solutions.py` — ye
`test/gameplay_test.dart` ke hal se `lib/data/levels/solutions.dart`
banata hai.

## Phases

- **Phase 1 — Vertical Slice** (complete): folder structure, models, Game Loop,
  Build System, Physics, Level 1-3 (Green Hills), Game Screen, Result.
- **Phase 2 — World 1 Complete** (complete): Bridge piece, poore 12 levels,
  Home, World Map, Level Select, stars/coins poora system. Har level headless
  khel kar pass hota hai (us ka hal test mein likha hai).
- **Phase 3 — Web Launch** (complete): World 2 Desert Dunes + World 3 Snow
  Peaks (36 levels total), Booster piece (L27 se unlock), Garage (5 cars,
  coins se khareedo), Audio (SFX + music + engine), Settings (Music/SFX
  toggles, Reset Progress). Web build ready (`flutter build web` pass).
  Har level headless khel kar pass hota hai (us ka hal test mein likha hai).
- **Phase 4 — Polish + Ads** (complete): sprites (5 gariyan, pieces, coin,
  flag, 3 world backgrounds — `tools/generate_sprites.py` se bane, load na
  hon to shape fallback), particles (coin sparkle, crash smoke, win
  confetti, boost flame) + camera shake, Ads system (interstitial har 3rd
  fail ke baad, rewarded hint/coins/skip — AdMob abhi stub hai, wiring
  neeche dekho), hints (ghost solution, shuru mein 3 free, ad se +1),
  bridge visual sag, hazards: L34 Thin Ice bridge 2s baad toot jata hai,
  L35 Avalanche Alley mein snowballs ludhakte hain. Tests: `flutter test`
  mein phase4_test.dart — sprites, effects, ads rules, hints, hazards.
- **Phase 5 — Full Game**: World 4-8 (96 levels), Play Store.

## Ads — AdMob wiring (Phase 5 mein)

`lib/services/ads_service.dart` abhi ek safe stub hai: `testMode` mein ads
hamesha ready aur rewarded hamesha kamyab (taake hint/coins ka flow test
ho sake); asal device par ads tab tak band hain jab tak ye na ho:

1. `flutter pub add google_mobile_ads` (Android/iOS only — web build par
   ye package nahi chalta, is liye web ke liye alag build flavour chahiye).
2. AdMob App ID `android/app/src/main/AndroidManifest.xml` aur
   `ios/Runner/Info.plist` mein, ad unit IDs `lib/core/constants.dart`
   (`AdsValues`) mein.
3. `AdsService.init()` mein `MobileAds.instance.initialize()` + real
   `InterstitialAd.load` / `RewardedAd.load`, aur `showRewarded` /
   `maybeShowInterstitialAfterFail` mein real `show()` calls.

Rules (design doc §6.8) jo service enforce karti hai: drive ke beech mein
kabhi ad nahi; interstitial sirf fail ke baad, har 3rd fail par, 60s
cooldown; rewarded hint (+1 hint), garage coins (+50) aur level skip ke liye.

## Levels — World 1 (Green Hills)

| # | Naam | Tray | Hal (test mein) |
|---|------|------|-----------------|
| 1 | First Gear | Road x1 | road 4-6 par |
| 2 | Two Gaps | Road x2 | road 4-6, 10-12 par |
| 3 | Coin Line | Road x2 | road 5-7 par |
| 4 | Downhill | Road x2 | road 4-6 par (0.5m drop) |
| 5 | Ramp Up | Road x1, Ramp x1 | road 4-6, ramp (6.5, 8.5) |
| 6 | Angle It | Ramp x1, Road x1 | road 4-6, ramp (6.5, 8.5) |
| 7 | Too Fast | Ramp x1 | ramp (4.5, 7.5) |
| 8 | Step Up, Step Down | Road x2, Ramp x1 | road 5-7, ramp (6.5, 8.5), road 12-14 |
| 9 | Bridge the Gap | Bridge x1, Road x1 | bridge 4-8 par |
| 10 | Bridge + Jump | Bridge x1, Ramp x1 | bridge 4-8, ramp (11.5, 8.5) |
| 11 | Almost Nothing | Road, Ramp, Bridge x1 | road 4-6, bridge 12-16 (ramp spare) |
| 12 | Hills Exam | Road x2, Ramp x1, Bridge x1 | road 4-6, bridge 11-15, ramp (14.5, 8.5) |

Physics notes (playtests se):
- 1m drop se gari flip ho jati hai — is liye L4 ka drop 0.5m hai.
- Ramp jump: 30° ramp se ~3 m/s par ~1.6m aage, ~1m upar utarta hai.
- Booster 7.5 m/s deta hai (2 second motor overdrive) — sirf velocity set
  karna kaafi nahi tha, wheel motor boost ko wapas brake kar deta tha.
  30° ramp se 7.5 m/s par ~5m aage utarta hai, 6m gap paar karta hai.
- Barf (ice) par ramp climb flip kar deta hai — traction kam, pitch zyada.
  Is liye L17/L21 mein dhalwan ki jagah 0.5m drop (road/bridge par) hai,
  aur L35 mein ramp jump hai, climb nahi.
- Ramp ka low end hamesha solid zameen/road par hona chahiye — gap ke upar
  float kare to gari us ki tip par atak jati hai.
- Coin tab collect hota hai jab chassis us se 0.5m ke andar guzre — is liye
  road par coins y=8.2, ledge (top 8.5) par y=7.7 par hain. Hawa wale coins
  (booster jump) flight path par hone chahiye (y~7.0-7.3).
- Barf par 30° ramp charhne ke liye combined friction ~0.58+ chahiye —
  is liye ice friction 0.15/0.5 se barha kar 0.55/0.9 kiya (combined ~0.67).

Design docs: `../track-builder-level-design.pdf` aur
`../track-builder-system-design.pdf` (workspace mein).

## Coding rules

1. Ek file, ek kaam — file 300 lines se bari ho to taqseem karo.
2. Magic numbers nahi — values `lib/core/constants.dart` ya `game_config.dart` mein.
3. Level data kabhi code mein hardcode nahi — sirf `lib/data/levels/` mein.
4. UI game logic nahi likhegi, game UI nahi banayega.
5. Har feature ke saath us ka test.
6. Auto-generated files (android/, ios/, web/, build/) haath se edit nahi karna.
