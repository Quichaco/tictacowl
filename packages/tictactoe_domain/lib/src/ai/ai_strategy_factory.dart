import 'package:tictactoe_domain/src/ai/ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/easy_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/hard_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/medium_ai_strategy.dart';
import 'package:tictactoe_domain/src/models/difficulty.dart';

class AiStrategyFactory {
  const AiStrategyFactory();

  AiStrategy create(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const EasyAiStrategy(),
        Difficulty.medium => const MediumAiStrategy(),
        Difficulty.hard => const HardAiStrategy(),
      };
}
