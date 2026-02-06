/// Tests for [AiStrategyFactory].
///
/// The factory creates the appropriate AI strategy based on game mode:
/// - [GameMode.easy] → [EasyAiStrategy]
/// - [GameMode.medium] → [MediumAiStrategy]
/// - [GameMode.hard] → [HardAiStrategy]
/// - [GameMode.multiplayer] → throws [StateError] (no AI needed)
///
/// This is the Strategy pattern - the factory encapsulates strategy selection.
library;

import 'package:test/test.dart';
import 'package:tictactoe_domain/src/ai/ai_strategy_factory.dart';
import 'package:tictactoe_domain/src/ai/easy_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/medium_ai_strategy.dart';
import 'package:tictactoe_domain/src/ai/hard_ai_strategy.dart';
import 'package:tictactoe_domain/src/models/game_mode.dart';

void main() {
  group('AiStrategyFactory', () {
    late AiStrategyFactory factory;

    setUp(() {
      factory = const AiStrategyFactory();
    });

    test('creates EasyAiStrategy for easy mode', () {
      final strategy = factory.create(GameMode.easy);
      expect(strategy, isA<EasyAiStrategy>());
    });

    test('creates MediumAiStrategy for medium mode', () {
      final strategy = factory.create(GameMode.medium);
      expect(strategy, isA<MediumAiStrategy>());
    });

    test('creates HardAiStrategy for hard mode', () {
      final strategy = factory.create(GameMode.hard);
      expect(strategy, isA<HardAiStrategy>());
    });

    test('throws StateError for multiplayer mode', () {
      expect(
        () => factory.create(GameMode.multiplayer),
        throwsStateError,
      );
    });
  });
}
