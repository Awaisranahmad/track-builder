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
│   └── save_service.dart  # Progress save/load (shared_preferences)
├── game/
│   ├── track_builder_game.dart  # FlameGame, phases
│   ├── components/        # Car, TrackPiece, Terrain, Coin, FinishFlag
│   └── managers/          # Build, Drive, Camera
├── ui/
│   ├── screens/           # Home, Game Screen
│   ├── widgets/           # Tray chip, hold button, timer
│   └── overlays/          # Result overlay
└── services/              # Audio, Ads (baad ke phases mein)
```

## Phases

- **Phase 1 — Vertical Slice** (jaari): folder structure, models, Game Loop,
  Build System, Physics, Level 1-3 (Green Hills), Game Screen, Result.
- **Phase 2 — World 1 Complete**: baaki pieces, poore 12 levels, Home, World Map,
  Level Select, stars/coins poora system.
- **Phase 3 — Web Launch**: World 2-3 (36 levels), Garage, Audio, Settings.
- **Phase 4 — Polish + Ads**: sprites, particles, Ads, hints.
- **Phase 5 — Full Game**: World 4-8 (96 levels), Play Store.

Design docs: `../track-builder-level-design.pdf` aur
`../track-builder-system-design.pdf` (workspace mein).

## Coding rules

1. Ek file, ek kaam — file 300 lines se bari ho to taqseem karo.
2. Magic numbers nahi — values `lib/core/constants.dart` ya `game_config.dart` mein.
3. Level data kabhi code mein hardcode nahi — sirf `lib/data/levels/` mein.
4. UI game logic nahi likhegi, game UI nahi banayega.
5. Har feature ke saath us ka test.
6. Auto-generated files (android/, ios/, web/, build/) haath se edit nahi karna.
