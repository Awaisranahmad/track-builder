// Garage Screen — gariyan dekho, stats compare karo, coins se khareedo,
// select karo. Design doc §6 system 6 (Garage System).
// Gari ke stats sirf halka farq rakhte hain — har level Starter Bug
// se bhi jeeta ja sakta hai (pay-to-win nahi).
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/models/car_data.dart';
import '../data/models/player_progress.dart';
import '../data/save_service.dart';
import '../services/ads_service.dart';

class GarageScreen extends StatefulWidget {
  GarageScreen({
    super.key,
    required this.progress,
    required this.saveService,
    AdsService? ads,
  }) : ads = ads ?? adsService;

  final PlayerProgress progress;
  final SaveService saveService;

  /// Ads — default app ka shared service; tests mein testMode wala do.
  final AdsService ads;

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  PlayerProgress get _progress => widget.progress;

  Future<void> _buy(CarData car) async {
    // Master Builder khareedi nahi ja sakti — sirf Level 96 jeetne par milti hai.
    if (car.unlockLevelId > 0 &&
        _progress.starsForLevel(car.unlockLevelId) == 0) {
      return;
    }
    final bought = _progress.buyCar(
      carId: car.id,
      priceCoins: car.priceCoins,
    );
    if (!bought) return;
    _progress.selectCar(car.id);
    await widget.saveService.saveProgress(_progress);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${car.name} khareed li — selected!')),
    );
  }

  Future<void> _freeCoins() async {
    final rewarded = await widget.ads.showRewarded(placement: 'coins');
    if (!mounted) return;
    if (!rewarded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad abhi tayyar nahi — baad mein try karo')),
      );
      return;
    }
    _progress.addCoins(AdsValues.rewardedCoinsAmount);
    await widget.saveService.saveProgress(_progress);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+${AdsValues.rewardedCoinsAmount} coins mil gaye!',
        ),
      ),
    );
  }

  Future<void> _select(CarData car) async {
    if (!_progress.selectCar(car.id)) return;
    await widget.saveService.saveProgress(_progress);
    if (!mounted) return;
    setState(() {});
  }

  Widget _statBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 10,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Text('$value/10'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                Text(
                  ' ${_progress.totalCoins}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _freeCoins,
                icon: const Icon(Icons.play_circle_outline),
                label: Text(
                  'Free coins — watch ad (+${AdsValues.rewardedCoinsAmount})',
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
        itemCount: allCars.length,
        itemBuilder: (context, index) {
          final car = allCars[index];
          final owned = _progress.ownedCars.contains(car.id);
          final selected = _progress.selectedCarId == car.id;
          final afford = _progress.totalCoins >= car.priceCoins;
          // Master Builder locked hai jab tak Level 96 jeeta na ho.
          final locked = car.unlockLevelId > 0 &&
              _progress.starsForLevel(car.unlockLevelId) == 0;
          return Card(
            color: selected ? Colors.green[50] : null,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              car.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        const Chip(
                          label: Text('Selected'),
                          backgroundColor: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _statBar('Speed', car.speed),
                  _statBar('Grip', car.grip),
                  _statBar('Stability', car.stability),
                  const SizedBox(height: 12),
                  if (locked)
                    const Text(
                      '🔒 Level 96 jeetne par milegi.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else if (!owned)
                    ElevatedButton.icon(
                      onPressed: afford ? () => _buy(car) : null,
                      icon: const Icon(Icons.monetization_on),
                      label: Text(
                        afford
                            ? 'Buy — ${car.priceCoins} coins'
                            : 'Need ${car.priceCoins} coins',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else if (!selected)
                    OutlinedButton(
                      onPressed: () => _select(car),
                      child: const Text('Select'),
                    )
                  else
                    const Text(
                      'Ye gari har level mein chalegi.',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        },
              ),
            ),
          ],
        ),
    );
  }
}
