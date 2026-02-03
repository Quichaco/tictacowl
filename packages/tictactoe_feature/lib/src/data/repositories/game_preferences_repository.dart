import 'package:tictactoe_domain/tictactoe_domain.dart';

abstract class GamePreferencesRepository {
  Difficulty getDifficulty();
  void setDifficulty(Difficulty difficulty);
  int getRounds();
  void setRounds(int rounds);
}
