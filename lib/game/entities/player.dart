import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:leap/leap.dart';
import 'package:phoenix_dash/audio/audio.dart';
import 'package:phoenix_dash/game/game.dart';

class Player extends JumperCharacter<SuperDashGame> {
  Player({
    required this.levelSize,
    required this.cameraViewport,
    super.health = initialHealth,
  });

  static const initialHealth = 1;
  static const baseSpeed = 5.0;
  static const jumpImpulse = .6;

  /// Speed increase per level (5% per level, max 50% increase)
  static const double speedIncreasePerLevel = 0.05;
  static const double maxSpeedIncrease = 0.5;

  /// Calculate speed based on current level
  double get speed {
    final level = gameRef.gameBloc.state.currentLevel;
    final speedMultiplier = 1 +
        (speedIncreasePerLevel * (level - 1)).clamp(0.0, maxSpeedIncrease);
    return baseSpeed * speedMultiplier;
  }

  final Vector2 levelSize;
  final Vector2 cameraViewport;
  late Vector2 spawn;
  late List<Vector2> respawnPoints;
  late final PlayerCameraAnchor cameraAnchor;
  late final PlayerStateBehavior stateBehavior =
      findBehavior<PlayerStateBehavior>();

  bool hasGoldenFeather = false;
  bool isPlayerInvincible = false;
  bool isPlayerTeleporting = false;
  bool isPlayerRespawning = false;

  /// Coyote time - grace period after leaving a platform where jump is allowed
  static const double _coyoteTimeDuration = 0.12; // 120ms grace period
  double _coyoteTimer = 0;
  bool _coyoteTimeActive = false;

  /// Whether player can still jump within coyote time window
  bool get canCoyoteJump => _coyoteTimeActive && _coyoteTimer > 0;

  /// Start coyote time when player walks off a platform
  void startCoyoteTime() {
    _coyoteTimeActive = true;
    _coyoteTimer = _coyoteTimeDuration;
  }

  /// Consume coyote time when player jumps
  void consumeCoyoteTime() {
    _coyoteTimeActive = false;
    _coyoteTimer = 0;
  }

  double? _gameOverTimer;

  double? _stuckTimer;
  double _dashPosition = 0;

  bool get isGoingToGameOver => _gameOverTimer != null;

  @override
  int get priority => 1;

  void jumpEffects() {
    final jumpSound = hasGoldenFeather ? Sfx.phoenixJump : Sfx.jump;
    gameRef.audioController.playSfx(jumpSound);

    final newJumpState =
        hasGoldenFeather ? DashState.phoenixJump : DashState.jump;
    stateBehavior.state = newJumpState;
  }

  void doubleJumpEffects() {
    gameRef.audioController.playSfx(Sfx.phoenixJump);
    stateBehavior.state = DashState.phoenixDoubleJump;
  }

  @override
  set walking(bool value) {
    if (!super.walking && value) {
      setRunningState();
    } else if (super.walking && !value) {
      setIdleState();
    }

    super.walking = value;
  }

  void setRunningState() {
    final behavior = stateBehavior;
    if (behavior.state != DashState.running &&
        behavior.state != DashState.phoenixRunning) {
      final newRunState =
          hasGoldenFeather ? DashState.phoenixRunning : DashState.running;
      if (behavior.state != newRunState) {
        behavior.state = newRunState;
      }
    }
  }

  void setIdleState() {
    stateBehavior.state =
        hasGoldenFeather ? DashState.phoenixIdle : DashState.idle;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(gameRef.tileSize * .5);
    walkSpeed = gameRef.tileSize * speed;
    minJumpImpulse = world.gravity * jumpImpulse;
    cameraAnchor = PlayerCameraAnchor(
      cameraViewport: cameraViewport,
      levelSize: levelSize,
      showCameraBounds: gameRef.inMapTester,
    );

    add(cameraAnchor);
    add(PlayerControllerBehavior());
    add(PlayerStateBehavior());

    gameRef.camera.follow(cameraAnchor);

    loadSpawnPoint();
    loadRespawnPoints();
  }

  void loadRespawnPoints() {
    final respawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('respawn');
    respawnPoints = [
      ...respawnGroup.objects.map(
        (object) => Vector2(object.x, object.y),
      ),
    ];
  }

  void loadSpawnPoint() {
    final spawnGroup = gameRef.leapMap.getTileLayer<ObjectGroup>('spawn');
    for (final object in spawnGroup.objects) {
      position = Vector2(object.x, object.y);
      spawn = position.clone();
    }
  }

  void addPowerUp() {
    hasGoldenFeather = true;

    if (stateBehavior.state == DashState.idle) {
      stateBehavior.state = DashState.phoenixIdle;
    } else if (stateBehavior.state == DashState.running) {
      stateBehavior.state = DashState.phoenixRunning;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update walk speed based on current level (difficulty scaling)
    walkSpeed = gameRef.tileSize * speed;

    // Update coyote time timer
    if (_coyoteTimeActive && _coyoteTimer > 0) {
      _coyoteTimer -= dt;
      if (_coyoteTimer <= 0) {
        _coyoteTimeActive = false;
      }
    }

    // Reset coyote time when landing
    if (isOnGround) {
      _coyoteTimeActive = false;
      _coyoteTimer = 0;
    }

    if (_gameOverTimer != null) {
      _gameOverTimer = _gameOverTimer! - dt;
      if (_gameOverTimer! <= 0) {
        _gameOverTimer = null;
        gameRef.gameOver();
      }
      return;
    }

    _checkPlayerStuck(dt);

    if (isPlayerTeleporting) return;

    if ((gameRef.isLastSection && x >= gameRef.leapMap.width - tileSize) ||
        (!gameRef.isLastSection &&
            x >= gameRef.leapMap.width - gameRef.tileSize * 15)) {
      sectionCleared();
      return;
    }

    if (isDead) {
      return _animateToGameOver();
    }

    // Player falls in a hazard zone.
    if ((collisionInfo.downCollision?.tags.contains('hazard') ?? false) &&
        !isPlayerInvincible) {
      // If player has no golden feathers, game over.
      if (!hasGoldenFeather) {
        _animateToGameOver(DashState.deathPit);
        return;
      }

      // If player has a golden feather, use it to avoid death.
      hasGoldenFeather = false;
      return respawn();
    }

    final collisions = collisionInfo.otherCollisions ?? const [];

    if (collisions.isEmpty) return;

    for (final collision in collisions) {
      if (collision is Item) {
        switch (collision.type) {
          case ItemType.acorn || ItemType.egg:
            gameRef.audioController.playSfx(
              collision.type == ItemType.acorn
                  ? Sfx.acornPickup
                  : Sfx.eggPickup,
            );
            gameRef.gameBloc.add(
              GameScoreIncreased(by: collision.type.points),
            );
          case ItemType.goldenFeather:
            addPowerUp();
            gameRef.audioController.playSfx(Sfx.featherPowerup);
        }
        gameRef.world.add(
          ItemEffect(
            type: collision.type,
            position: collision.position.clone(),
          ),
        );
        collision.removeFromParent();
      }

      if (collision is Enemy && !isPlayerInvincible) {
        // Check if player is landing on top of the enemy (stomping)
        // Player must be falling (positive velocity.y = moving down) and
        // player's bottom must be near the enemy's top
        final isFalling = velocity.y > 0;
        final playerBottom = position.y + size.y;
        final enemyTop = collision.position.y;
        final isAboveEnemy = playerBottom <= enemyTop + size.y * 0.5;

        if (isFalling && isAboveEnemy) {
          // Get enemy position before removing
          final enemyPosition = collision.position.clone();

          // Stomp the enemy - kill it and bounce
          collision.removeFromParent();

          // Give player a small bounce
          velocity.y = -minJumpImpulse * 0.7;

          // Get current combo count before incrementing (for display)
          final currentCombo = gameRef.gameBloc.state.comboCount;

          // Trigger stomp event (handles combo and score)
          gameRef.gameBloc.add(const GameEnemyStomped());

          // Play stomp sound
          gameRef.audioController.playSfx(Sfx.jump);

          // Add visual effects
          gameRef.world.add(
            StompEffect(position: enemyPosition),
          );

          // Add screen shake
          gameRef.add(ScreenShake());

          // Add score popup (show new combo multiplier)
          gameRef.world.add(
            ScorePopup(
              score: 100,
              position: enemyPosition - Vector2(0, 20),
              comboMultiplier: currentCombo + 1,
            ),
          );

          return;
        }

        // If player has no golden feathers, game over.
        if (!hasGoldenFeather) {
          health -= collision.enemyDamage;
          return;
        }

        // If player has a golden feather, use it to avoid death.
        hasGoldenFeather = false;
        return respawn();
      }
    }
  }

  void _checkPlayerStuck(double dt) {
    final currentDashPosition = position.x;
    final isPlayerStopped = currentDashPosition == _dashPosition;
    // Player is set as walking but is not moving.
    if (walking && isPlayerStopped) {
      _stuckTimer ??= 1;
      _stuckTimer = _stuckTimer! - dt;
      if (_stuckTimer! <= 0) {
        _stuckTimer = null;
        health = 0;
      }
    } else {
      _stuckTimer = null;
    }
    _dashPosition = currentDashPosition;
  }

  void _animateToGameOver([DashState deathState = DashState.deathFaint]) {
    stateBehavior.state = deathState;
    super.walking = false;
    _gameOverTimer = 1.4;
  }

  void respawn() {
    // Get closest value to gridX and gridY in respawnPoints.
    final respawnPointsBehind = respawnPoints.where((point) {
      return point.x < position.x;
    });

    Vector2 closestRespawn;
    if (respawnPointsBehind.isEmpty) {
      closestRespawn = spawn;
    } else {
      closestRespawn = respawnPointsBehind.reduce((a, b) {
        return (a - position).length2 < (b - position).length2 ? a : b;
      });
    }

    isPlayerRespawning = true;
    isPlayerInvincible = true;
    walking = false;
    stateBehavior.fadeOut();
    add(
      MoveToEffect(
        closestRespawn.clone(),
        EffectController(
          curve: Curves.easeInOut,
          startDelay: .2,
          duration: .8,
        ),
      ),
    );
    stateBehavior.fadeIn(
      onComplete: () {
        isPlayerRespawning = false;
        isPlayerInvincible = false;
        walking = true;
      },
    );
  }

  void spritePaintColor(Color color) {
    stateBehavior.updateSpritePaintColor(color);
  }

  void sectionCleared() {
    isPlayerTeleporting = true;
    gameRef.sectionCleared();
  }
}
