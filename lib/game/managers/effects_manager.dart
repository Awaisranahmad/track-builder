// Effects Manager — particles aur camera shake (design doc §6,
// effects_manager.dart). Game ke events par bulaya jata hai:
// coin collect → sparkle, crash → smoke + shake, win → confetti,
// booster → flame trail. Particles sirf visual hain — physics aur
// game logic par koi asar nahi.
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';

class EffectsManager {
  EffectsManager(this.game);

  final TrackBuilderGame game;

  final _random = math.Random();

  /// Coin collect — sunehri sparks, coin ki jagah par.
  void coinBurst(Vector2 position) {
    _burst(
      position,
      count: EffectsValues.coinSparkCount,
      colors: const [Color(0xFFFFD600), Color(0xFFFFF176), Color(0xFFFF8F00)],
      speed: 2.5,
      size: 0.09,
      lifespan: 0.6,
    );
  }

  /// Crash / fail — grey smoke, gari ki jagah par.
  void crashSmoke(Vector2 position) {
    _burst(
      position,
      count: EffectsValues.crashSmokeCount,
      colors: const [Color(0xFF9E9E9E), Color(0xFF757575), Color(0xFFBDBDBD)],
      speed: 1.5,
      size: 0.28,
      lifespan: 1.0,
      gravity: -0.5,
    );
  }

  /// Level win — rang-biranga confetti, finish flag se neeche girta hua.
  void winConfetti(Vector2 position) {
    _burst(
      position,
      count: EffectsValues.winConfettiCount,
      colors: const [
        Color(0xFFE53935),
        Color(0xFFFFD600),
        Color(0xFF43A047),
        Color(0xFF1E88E5),
        Color(0xFF8E24AA),
      ],
      speed: 3.0,
      size: 0.12,
      lifespan: 1.6,
      gravity: 4.0,
    );
  }

  /// Booster — peeche se flame jaisa burst, gari ki jagah par.
  void boostFlame(Vector2 position) {
    _burst(
      position,
      count: EffectsValues.boostFlameCount,
      colors: const [Color(0xFF00E5FF), Color(0xFFFF9800), Color(0xFFFFEB3B)],
      speed: 2.0,
      size: 0.12,
      lifespan: 0.5,
      gravity: 0,
    );
  }

  /// Camera hilao — crash par zyada, boost par halka.
  void shake({double amount = EffectsValues.shakeAmountMetres}) {
    game.cameraManager.shake(amount: amount);
  }

  /// Ek burst — har particle random direction mein, gravity ke saath.
  void _burst(
    Vector2 position, {
    required int count,
    required List<Color> colors,
    required double speed,
    required double size,
    required double lifespan,
    double gravity = 2.0,
  }) {
    final particle = Particle.generate(
      count: count,
      lifespan: lifespan,
      generator: (i) {
        final angle = _random.nextDouble() * math.pi * 2;
        final velocity = Vector2(
          math.cos(angle) * speed * (0.4 + _random.nextDouble() * 0.6),
          math.sin(angle) * speed * (0.4 + _random.nextDouble() * 0.6),
        );
        final color = colors[_random.nextInt(colors.length)];
        return AcceleratedParticle(
          acceleration: Vector2(0, gravity),
          speed: velocity,
          child: CircleParticle(
            radius: size * (0.6 + _random.nextDouble() * 0.8),
            paint: Paint()..color = color,
          ),
        );
      },
    );
    game.add(
      ParticleSystemComponent(
        particle: particle,
        position: position,
        priority: 10,
      ),
    );
  }
}
