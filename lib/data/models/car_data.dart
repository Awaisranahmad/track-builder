// Gari ka data — stats sirf halka farq rakhte hain, taake game
// pay-to-win na bane. Har level Starter Bug se bhi jeeta ja sakta hai.
// Design doc page 14: 5 gariyan, coins se khareedni hain.
class CarData {
  const CarData({
    required this.id,
    required this.name,
    required this.priceCoins,
    required this.speed,
    required this.grip,
    required this.stability,
    required this.description,
    this.unlockLevelId = 0,
  });

  final String id;
  final String name;

  /// Coins mein qeemat — 0 matlab free.
  final int priceCoins;

  /// Stats 1-10 scale par.
  final int speed;
  final int grip;
  final int stability;

  /// Garage mein dikhane wali ek line.
  final String description;

  /// Is level ko jeetne par milti hai (0 matlab koi shart nahi).
  /// Master Builder sirf Level 96 jeetne par milti hai — khareedi nahi ja sakti.
  final int unlockLevelId;

  bool get isFree => priceCoins == 0;

  /// Motor speed ka multiplier — speed 5 = 1.0 (Starter Bug jaisa).
  /// 9 (City Racer) = 1.12, 4 (Desert Pickup) = 0.97.
  double get motorMultiplier => 0.85 + speed * 0.03;

  /// Wheel grip ka multiplier — grip 5 = 1.0.
  /// 9 (Snow Rally) = 1.24, 4 (City Racer) = 0.94.
  double get gripMultiplier => 0.7 + grip * 0.06;

  /// Chassis density ka multiplier — stability 5 = 1.0.
  /// Bhari gari kam ultati hai (bridge aur see-saw par steady).
  double get stabilityMultiplier => 0.8 + stability * 0.04;
}

/// Shuru ki gari — free, har stat mein balanced.
const CarData starterBug = CarData(
  id: 'starter_bug',
  name: 'Starter Bug',
  priceCoins: 0,
  speed: 5,
  grip: 5,
  stability: 5,
  description: 'Balanced — har level ke liye theek.',
);

/// Bhari, bridge aur see-saw par steady, halki slow.
const CarData desertPickup = CarData(
  id: 'desert_pickup',
  name: 'Desert Pickup',
  priceCoins: 300,
  speed: 4,
  grip: 7,
  stability: 8,
  description: 'Bhari aur steady — bridge par kam hilti hai.',
);

/// Barf aur ret ke liye extra grip.
const CarData snowRally = CarData(
  id: 'snow_rally',
  name: 'Snow Rally',
  priceCoins: 600,
  speed: 6,
  grip: 9,
  stability: 6,
  description: 'Extra grip — ice aur sand par slide kam.',
);

/// Sab se tez acceleration, control mushkil.
const CarData cityRacer = CarData(
  id: 'city_racer',
  name: 'City Racer',
  priceCoins: 1000,
  speed: 9,
  grip: 4,
  stability: 3,
  description: 'Sab se tez — lekin control mushkil.',
);

/// Joke car: bari, wobbly, pasandeeda. Stats average.
const CarData rocketVan = CarData(
  id: 'rocket_van',
  name: 'Rocket Van',
  priceCoins: 1800,
  speed: 5,
  grip: 5,
  stability: 4,
  description: 'Bari aur wobbly — dekhne mein mazahiya.',
);

/// Master Builder — Level 96 (finale) jeetne par milti hai.
/// Khareedi nahi ja sakti. Balanced, sunheri paint.
const CarData masterBuilder = CarData(
  id: 'master_builder',
  name: 'Master Builder',
  priceCoins: 0,
  speed: 7,
  grip: 7,
  stability: 7,
  description: 'Level 96 jeetne par mili — finale ki gari.',
  unlockLevelId: 96,
);

/// Saari gariyan — Garage isi list se banta hai.
const List<CarData> allCars = [
  starterBug,
  desertPickup,
  snowRally,
  cityRacer,
  rocketVan,
  masterBuilder,
];

/// Car id se dhoondho — na mile to null.
CarData? carById(String id) {
  for (final car in allCars) {
    if (car.id == id) return car;
  }
  return null;
}
