import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictactoe_domain/src/models/game_mode.dart';

part 'game_config.freezed.dart';

@freezed
abstract class GameConfig with _$GameConfig {
  const GameConfig._();

  const factory GameConfig({
    @Default(GameMode.multiplayer) GameMode mode,
    @Default(3) int rounds,
  }) = _GameConfig;

  static const minRounds = 1;
  static const maxRounds = 10;
}
