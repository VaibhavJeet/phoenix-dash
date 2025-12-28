import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_dash/game/bloc/game_bloc.dart';
import 'package:phoenix_dash/gen/assets.gen.dart';
import 'package:phoenix_dash/l10n/l10n.dart';

class ScoreLabel extends StatelessWidget {
  const ScoreLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final score = context.select(
      (GameBloc bloc) => bloc.state.score,
    );
    final comboCount = context.select(
      (GameBloc bloc) => bloc.state.comboCount,
    );
    final isComboActive = context.select(
      (GameBloc bloc) => bloc.state.isComboActive,
    );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TraslucentBackground(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            ),
            gradient: const [
              Color(0xFFEAFFFE),
              Color(0xFFC9D9F1),
            ],
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Assets.images.trophy.image(
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.gameScoreLabel(score),
                    style: textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF4D5B92),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Combo badge
          if (isComboActive && comboCount > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ComboBadge(comboCount: comboCount),
            ),
        ],
      ),
    );
  }
}

/// Animated combo badge that shows current combo multiplier
class ComboBadge extends StatelessWidget {
  const ComboBadge({
    required this.comboCount,
    super.key,
  });

  final int comboCount;

  @override
  Widget build(BuildContext context) {
    // Color based on combo level
    final Color badgeColor;
    final Color textColor;

    if (comboCount >= 5) {
      badgeColor = const Color(0xFFFFD700); // Gold
      textColor = const Color(0xFF6B4500);
    } else if (comboCount >= 3) {
      badgeColor = const Color(0xFFFF6B00); // Orange
      textColor = Colors.white;
    } else {
      badgeColor = const Color(0xFF00E5FF); // Cyan
      textColor = const Color(0xFF003D4D);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 150),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              badgeColor,
              badgeColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '${comboCount}x COMBO!',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
