import 'package:tictactoe_domain/src/models/difficulty.dart';

class GameConfig {
  const GameConfig({
    this.difficulty = Difficulty.easy,
    this.rounds = 3,
  });

  final Difficulty difficulty;
  final int rounds;

  static const minRounds = 1;
  static const maxRounds = 10;

  GameConfig copyWith({
    Difficulty? difficulty,
    int? rounds,
  }) {
    return GameConfig(
      difficulty: difficulty ?? this.difficulty,
      rounds: rounds ?? this.rounds,
    );
  }
}
