// Gari ka data — stats sirf halka farq rakhte hain, taake game
// pay-to-win na bane. Har level Starter Bug se bhi jeeta ja sakta hai.
class CarData {
  const CarData({
    required this.id,
    required this.name,
    required this.priceCoins,
    required this.speed,
    required this.grip,
    required this.stability,
  });

  final String id;
  final String name;

  /// Coins mein qeemat — 0 matlab free.
  final int priceCoins;

  /// Stats 1-10 scale par.
  final int speed;
  final int grip;
  final int stability;

  bool get isFree => priceCoins == 0;
}

/// Shuru ki gari — free, har stat mein balanced.
const CarData starterBug = CarData(
  id: 'starter_bug',
  name: 'Starter Bug',
  priceCoins: 0,
  speed: 5,
  grip: 5,
  stability: 5,
);

/// Phase 1 mein sirf Starter Bug hai — baaki gariyan Phase 3 mein.
const List<CarData> allCars = [starterBug];
