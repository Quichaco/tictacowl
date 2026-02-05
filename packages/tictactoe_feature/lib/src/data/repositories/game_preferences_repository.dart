import 'package:tictactoe_domain/tictactoe_domain.dart';

abstract class GamePreferencesRepository {
  GameMode getGameMode();
  void setGameMode(GameMode mode);
  int getRounds();
  void setRounds(int rounds);
}
