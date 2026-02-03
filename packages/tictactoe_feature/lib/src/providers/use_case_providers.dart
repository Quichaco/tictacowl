import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';

part 'use_case_providers.g.dart';

@riverpod
PlayMoveUseCase playMoveUseCase(Ref ref) => const PlayMoveUseCase();

@riverpod
NextRoundUseCase nextRoundUseCase(Ref ref) => const NextRoundUseCase();

@riverpod
RestartGameUseCase restartGameUseCase(Ref ref) => const RestartGameUseCase();

@riverpod
AiStrategyFactory aiStrategyFactory(Ref ref) => const AiStrategyFactory();

@riverpod
AiMoveUseCase aiMoveUseCase(Ref ref) => AiMoveUseCase(
      playMoveUseCase: ref.watch(playMoveUseCaseProvider),
      strategyFactory: ref.watch(aiStrategyFactoryProvider),
    );
