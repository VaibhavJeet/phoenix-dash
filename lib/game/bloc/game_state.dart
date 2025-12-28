part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    required this.score,
    required this.currentLevel,
    required this.currentSection,
    this.comboCount = 0,
    this.comboTimer = 0,
    this.maxCombo = 0,
    this.totalEnemiesStomped = 0,
  });

  const GameState.initial()
      : score = 0,
        currentLevel = 1,
        currentSection = 0,
        comboCount = 0,
        comboTimer = 0,
        maxCombo = 0,
        totalEnemiesStomped = 0;

  final int score;
  final int currentLevel;
  final int currentSection;

  /// Current combo count (resets after combo timer expires)
  final int comboCount;

  /// Time remaining in combo window (in seconds)
  final double comboTimer;

  /// Highest combo achieved in this session
  final int maxCombo;

  /// Total enemies stomped in this session
  final int totalEnemiesStomped;

  /// Combo time window in seconds
  static const double comboWindowDuration = 2.0;

  /// Whether combo is currently active
  bool get isComboActive => comboCount > 0 && comboTimer > 0;

  GameState copyWith({
    int? score,
    int? currentLevel,
    int? currentSection,
    int? comboCount,
    double? comboTimer,
    int? maxCombo,
    int? totalEnemiesStomped,
  }) {
    return GameState(
      score: score ?? this.score,
      currentLevel: currentLevel ?? this.currentLevel,
      currentSection: currentSection ?? this.currentSection,
      comboCount: comboCount ?? this.comboCount,
      comboTimer: comboTimer ?? this.comboTimer,
      maxCombo: maxCombo ?? this.maxCombo,
      totalEnemiesStomped: totalEnemiesStomped ?? this.totalEnemiesStomped,
    );
  }

  @override
  List<Object?> get props => [
        score,
        currentLevel,
        currentSection,
        comboCount,
        comboTimer,
        maxCombo,
        totalEnemiesStomped,
      ];
}
