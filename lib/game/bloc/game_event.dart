part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

final class GameScoreIncreased extends GameEvent {
  const GameScoreIncreased({this.by = 1});

  final int by;

  @override
  List<Object> get props => [by];
}

final class GameScoreDecreased extends GameEvent {
  const GameScoreDecreased({this.by = 1});

  final int by;

  @override
  List<Object> get props => [by];
}

final class GameOver extends GameEvent {
  const GameOver();
}

final class GameSectionCompleted extends GameEvent {
  const GameSectionCompleted({required this.sectionCount});

  final int sectionCount;

  @override
  List<Object> get props => [sectionCount];
}

/// Event fired when player stomps an enemy
final class GameEnemyStomped extends GameEvent {
  const GameEnemyStomped();
}

/// Event fired to update combo timer (called from game update loop)
final class GameComboTimerTick extends GameEvent {
  const GameComboTimerTick({required this.deltaTime});

  final double deltaTime;

  @override
  List<Object> get props => [deltaTime];
}
