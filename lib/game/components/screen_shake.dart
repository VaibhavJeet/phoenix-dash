import 'dart:math';

import 'package:flame/components.dart';
import 'package:phoenix_dash/game/game.dart';

/// Screen shake effect component that shakes the camera
class ScreenShake extends Component with HasGameRef<SuperDashGame> {
  ScreenShake({
    this.intensity = 4.0,
    this.duration = 0.15,
  });

  final double intensity;
  final double duration;

  double _elapsed = 0;
  final Random _random = Random();
  Vector2? _originalCameraPosition;

  @override
  void onMount() {
    super.onMount();
    _originalCameraPosition = gameRef.camera.viewfinder.position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    if (_elapsed >= duration) {
      // Reset camera position and remove component
      if (_originalCameraPosition != null) {
        gameRef.camera.viewfinder.position = _originalCameraPosition!;
      }
      removeFromParent();
      return;
    }

    // Calculate shake intensity (decreases over time)
    final progress = _elapsed / duration;
    final currentIntensity = intensity * (1 - progress);

    // Apply random offset
    final offsetX = (_random.nextDouble() * 2 - 1) * currentIntensity;
    final offsetY = (_random.nextDouble() * 2 - 1) * currentIntensity;

    if (_originalCameraPosition != null) {
      gameRef.camera.viewfinder.position = _originalCameraPosition! +
          Vector2(offsetX, offsetY);
    }
  }

  @override
  void onRemove() {
    // Ensure camera is reset when removed
    if (_originalCameraPosition != null) {
      gameRef.camera.viewfinder.position = _originalCameraPosition!;
    }
    super.onRemove();
  }
}
