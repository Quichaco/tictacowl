import 'package:tictactoe_domain/src/ai/ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/easy_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/hard_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/medium_ai_strategy.dart';
import 'package:tictactoe_domain/src/models/game_mode.dart';

class AiStrategyFactory {
  const AiStrategyFactory();

  AiStrategy create(GameMode mode) => switch (mode) {
        GameMode.easy => const EasyAiStrategy(),
        GameMode.medium => const MediumAiStrategy(),
        GameMode.hard => const HardAiStrategy(),
        GameMode.multiplayer => throw StateError('No AI in multiplayer mode'),
      };
}
