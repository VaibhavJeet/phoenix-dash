import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameScoreIncreased>(_onGameScoreIncreased);
    on<GameScoreDecreased>(_onGameScoreDecreased);
    on<GameOver>(_onGameOver);
    on<GameSectionCompleted>(_onGameSectionCompleted);
    on<GameEnemyStomped>(_onGameEnemyStomped);
    on<GameComboTimerTick>(_onGameComboTimerTick);
  }

  /// Base score for stomping an enemy
  static const int _stompBaseScore = 100;

  /// Bonus score per combo level (multiplied by combo count - 1)
  static const int _comboBonusPerLevel = 50;

  void _onGameScoreIncreased(
    GameScoreIncreased event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        score: state.score + event.by,
      ),
    );
  }

  void _onGameScoreDecreased(
    GameScoreDecreased event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        score: state.score - event.by,
      ),
    );
  }

  void _onGameOver(
    GameOver event,
    Emitter<GameState> emit,
  ) {
    emit(const GameState.initial());
  }

  void _onGameSectionCompleted(
    GameSectionCompleted event,
    Emitter<GameState> emit,
  ) {
    if (state.currentSection < event.sectionCount - 1) {
      emit(
        state.copyWith(
          currentSection: state.currentSection + 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentSection: 0,
          currentLevel: state.currentLevel + 1,
        ),
      );
    }
  }

  void _onGameEnemyStomped(
    GameEnemyStomped event,
    Emitter<GameState> emit,
  ) {
    // Increment combo count
    final newComboCount = state.comboCount + 1;

    // Calculate score with combo bonus
    // Base score + bonus for each combo level above 1
    final comboBonus = (newComboCount - 1) * _comboBonusPerLevel;
    final totalScore = _stompBaseScore + comboBonus;

    // Update max combo if needed
    final newMaxCombo = max(state.maxCombo, newComboCount);

    emit(
      state.copyWith(
        score: state.score + totalScore,
        comboCount: newComboCount,
        comboTimer: GameState.comboWindowDuration,
        maxCombo: newMaxCombo,
        totalEnemiesStomped: state.totalEnemiesStomped + 1,
      ),
    );
  }

  void _onGameComboTimerTick(
    GameComboTimerTick event,
    Emitter<GameState> emit,
  ) {
    if (state.comboTimer <= 0) return;

    final newTimer = state.comboTimer - event.deltaTime;

    if (newTimer <= 0) {
      // Combo expired - reset combo count
      emit(
        state.copyWith(
          comboTimer: 0,
          comboCount: 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          comboTimer: newTimer,
        ),
      );
    }
  }
}
