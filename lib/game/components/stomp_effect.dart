import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_dash/game/game.dart';

/// Visual effect when stomping an enemy - expanding ring + particles
class StompEffect extends PositionComponent with HasGameRef<SuperDashGame> {
  StompEffect({
    required Vector2 position,
    this.color = const Color(0xFFFF6B00),
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: 50,
        );

  final Color color;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add expanding ring
    add(StompRing(color: color));

    // Add particle burst
    final random = Random();
    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final speed = 80 + random.nextDouble() * 40;

      add(
        StompParticle(
          color: color,
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
        ),
      );
    }

    // Remove after animation
    add(
      TimerComponent(
        period: 0.5,
        removeOnFinish: true,
        onTick: removeFromParent,
      ),
    );
  }
}

/// Expanding ring part of the stomp effect
class StompRing extends CircleComponent {
  StompRing({
    required Color color,
  }) : super(
          radius: 10,
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Expand the ring
    add(
      SizeEffect.by(
        Vector2.all(60),
        EffectController(
          duration: 0.3,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Fade out
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.3),
      ),
    );
  }
}

/// Particle for the stomp burst effect
class StompParticle extends CircleComponent {
  StompParticle({
    required Color color,
    required this.velocity,
  }) : super(
          radius: 4,
          anchor: Anchor.center,
          paint: Paint()..color = color,
        );

  final Vector2 velocity;
  double _elapsed = 0;
  static const double _lifetime = 0.4;

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    // Move particle
    position += velocity * dt;

    // Apply gravity
    velocity.y += 200 * dt;

    // Fade out based on lifetime
    final alpha = (1 - (_elapsed / _lifetime)).clamp(0.0, 1.0);
    paint.color = paint.color.withValues(alpha: alpha);

    // Shrink
    radius = 4 * (1 - (_elapsed / _lifetime)).clamp(0.3, 1.0);

    if (_elapsed >= _lifetime) {
      removeFromParent();
    }
  }
}
