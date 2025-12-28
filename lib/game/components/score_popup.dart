import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_dash/game/game.dart';

/// Floating score popup that rises and fades when scoring
class ScorePopup extends TextComponent with HasGameRef<SuperDashGame> {
  ScorePopup({
    required this.score,
    required Vector2 position,
    this.comboMultiplier = 1,
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: 100,
        );

  final int score;
  final int comboMultiplier;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Choose color based on combo
    final Color textColor;
    final double fontSize;

    if (comboMultiplier >= 5) {
      textColor = const Color(0xFFFFD700); // Gold
      fontSize = 28;
    } else if (comboMultiplier >= 3) {
      textColor = const Color(0xFFFF6B00); // Orange
      fontSize = 24;
    } else if (comboMultiplier >= 2) {
      textColor = const Color(0xFF00E5FF); // Cyan
      fontSize = 22;
    } else {
      textColor = Colors.white;
      fontSize = 20;
    }

    // Format text
    final displayText = comboMultiplier > 1
        ? '+$score x$comboMultiplier'
        : '+$score';

    text = displayText;
    textRenderer = TextPaint(
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            color: Colors.black,
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );

    // Add rise and fade effect
    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(duration: 0.8, curve: Curves.easeOut),
      ),
    );

    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.8),
        onComplete: removeFromParent,
      ),
    );

    // Slight scale up for combos
    if (comboMultiplier > 1) {
      add(
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(
            duration: 0.15,
            reverseDuration: 0.15,
          ),
        ),
      );
    }
  }
}
