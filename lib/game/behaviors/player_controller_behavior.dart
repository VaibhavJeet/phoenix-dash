import 'dart:async';

import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/widgets.dart';
import 'package:phoenix_dash/game/game.dart';

class PlayerControllerBehavior extends Behavior<Player> {
  @visibleForTesting
  bool doubleJumpUsed = false;

  double _jumpTimer = 0;

  /// Input buffer - stores time since last tap to allow "early" jumps
  /// When player taps slightly before landing, the jump will still register
  static const double _inputBufferDuration = 0.15; // 150ms buffer window
  double _inputBufferTimer = 0;
  bool _hasBufferedInput = false;

  /// Track if player was on ground last frame (for coyote time detection)
  bool _wasOnGroundLastFrame = false;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    parent.gameRef.addInputListener(_handleInput);
  }

  @override
  void onRemove() {
    super.onRemove();

    parent.gameRef.removeInputListener(_handleInput);
  }

  void _handleInput() {
    if (parent.isDead ||
        parent.isPlayerTeleporting ||
        parent.isPlayerRespawning ||
        parent.isGoingToGameOver) {
      return;
    }

    // Do nothing when there is a jump cool down
    if (_jumpTimer >= 0) {
      return;
    }

    // If is no walking, start walking
    if (!parent.walking) {
      parent.walking = true;
      return;
    }

    // Check if can jump (on ground or within coyote time)
    final canJump = parent.isOnGround || parent.canCoyoteJump;

    // If is walking, jump
    if (parent.walking && canJump) {
      _executeJump();
      return;
    }

    // If is walking and double jump is enabled, double jump
    if (parent.walking &&
        !parent.isOnGround &&
        parent.hasGoldenFeather &&
        !doubleJumpUsed) {
      _executeDoubleJump();
      return;
    }

    // If we can't jump right now, buffer the input
    if (parent.walking && !canJump) {
      _hasBufferedInput = true;
      _inputBufferTimer = _inputBufferDuration;
    }
  }

  void _executeJump() {
    parent
      ..jumpEffects()
      ..jumping = true;
    _jumpTimer = 0.04;
    _hasBufferedInput = false;
    _inputBufferTimer = 0;
    // Consume coyote time when jumping
    parent.consumeCoyoteTime();
  }

  void _executeDoubleJump() {
    parent
      ..doubleJumpEffects()
      ..jumping = true;
    _jumpTimer = 0.06;
    doubleJumpUsed = true;
    _hasBufferedInput = false;
    _inputBufferTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (parent.isDead && parent.jumping) {
      parent.jumping = false;
    }

    if (parent.isDead ||
        parent.isPlayerTeleporting ||
        parent.isGoingToGameOver) {
      return;
    }

    // Update input buffer timer
    if (_inputBufferTimer > 0) {
      _inputBufferTimer -= dt;
      if (_inputBufferTimer <= 0) {
        _hasBufferedInput = false;
      }
    }

    // Coyote time: If player just left the ground (not from jumping),
    // start the coyote timer
    if (_wasOnGroundLastFrame && !parent.isOnGround && !parent.jumping) {
      parent.startCoyoteTime();
    }
    _wasOnGroundLastFrame = parent.isOnGround;

    // Check for buffered input when landing
    if (_hasBufferedInput && parent.isOnGround && _jumpTimer < 0) {
      _executeJump();
    }

    if (_jumpTimer >= 0) {
      _jumpTimer -= dt;

      if (_jumpTimer <= 0) {
        parent.jumping = false;
      }
    }

    if (_jumpTimer <= 0 && parent.isOnGround && parent.walking) {
      parent.setRunningState();
    }

    if (doubleJumpUsed && parent.isOnGround) {
      doubleJumpUsed = false;
    }
  }
}
