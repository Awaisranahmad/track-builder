// Player ki progress — stars, coins, unlocks.
// Yehi poora model save hota hai (shared_preferences mein JSON).
class PlayerProgress {
  PlayerProgress({
    Map<int, int>? starsPerLevel,
    this.totalCoins = 0,
    Set<int>? unlockedLevels,
    this.selectedCarId = 'starter_bug',
    Set<String>? ownedCars,
    this.musicOn = true,
    this.sfxOn = true,
  })  : starsPerLevel = starsPerLevel ?? {},
        unlockedLevels = unlockedLevels ?? {1},
        ownedCars = ownedCars ?? {'starter_bug'};

  /// Har level par mile hue stars (0-3). Key = level id.
  final Map<int, int> starsPerLevel;

  /// Wallet mein jama coins.
  int totalCoins;

  /// Khule hue levels — Level 1 hamesha khula hota hai.
  final Set<int> unlockedLevels;

  /// Chuni hui gari.
  String selectedCarId;

  /// Khareedi hui gariyan.
  final Set<String> ownedCars;

  bool musicOn;
  bool sfxOn;

  /// Kul stars — saare levels ka total.
  int get totalStars {
    var total = 0;
    for (final stars in starsPerLevel.values) {
      total += stars;
    }
    return total;
  }

  /// Is level par kitne stars mile (0-3).
  int starsForLevel(int levelId) => starsPerLevel[levelId] ?? 0;

  /// Kya ye level khula hai?
  bool isLevelUnlocked(int levelId) => unlockedLevels.contains(levelId);

  /// Level ka result save karo — behtareen stars rehte hain, coins jama hote hain.
  /// Returns: is dafa mile hue NAYE stars (0-3), taake UI dikha sake.
  int recordLevelResult({
    required int levelId,
    required int stars,
    required int coinsCollected,
  }) {
    final oldStars = starsForLevel(levelId);
    final newStars = stars > oldStars ? stars : oldStars;
    starsPerLevel[levelId] = newStars;
    totalCoins += coinsCollected;

    // Agla level khol do — pehli dafa clear par.
    if (stars >= 1) {
      unlockedLevels.add(levelId + 1);
    }

    return newStars - oldStars;
  }

  /// Agla world khulta hai jab pichle world mein 20+ stars hon.
  bool isWorldUnlocked(int world, {int starsNeeded = 20}) {
    if (world <= 1) return true;
    final previousWorldFirstLevel = (world - 2) * 12 + 1;
    var stars = 0;
    for (var i = 0; i < 12; i++) {
      stars += starsForLevel(previousWorldFirstLevel + i);
    }
    return stars >= starsNeeded;
  }

  Map<String, dynamic> toJson() {
    return {
      'starsPerLevel': starsPerLevel.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'totalCoins': totalCoins,
      'unlockedLevels': unlockedLevels.toList(),
      'selectedCarId': selectedCarId,
      'ownedCars': ownedCars.toList(),
      'musicOn': musicOn,
      'sfxOn': sfxOn,
    };
  }

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    final starsRaw = (json['starsPerLevel'] as Map?) ?? {};
    final stars = <int, int>{};
    for (final entry in starsRaw.entries) {
      stars[int.parse(entry.key.toString())] = (entry.value as num).toInt();
    }
    return PlayerProgress(
      starsPerLevel: stars,
      totalCoins: (json['totalCoins'] as num?)?.toInt() ?? 0,
      unlockedLevels: ((json['unlockedLevels'] as List?) ?? [1])
          .map((e) => (e as num).toInt())
          .toSet(),
      selectedCarId: json['selectedCarId'] as String? ?? 'starter_bug',
      ownedCars: ((json['ownedCars'] as List?) ?? ['starter_bug'])
          .map((e) => e.toString())
          .toSet(),
      musicOn: json['musicOn'] as bool? ?? true,
      sfxOn: json['sfxOn'] as bool? ?? true,
    );
  }
}
