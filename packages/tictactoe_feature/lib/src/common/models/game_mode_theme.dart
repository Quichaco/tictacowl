import 'package:flutter/material.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/l10n/gen/game_localizations.dart';
import 'package:tictactoe_feature/src/common/constants/tictactoe_assets.dart';
import 'package:ui_components/ui_components.dart';

/// UI theme data for [GameMode].
/// All presentation data is co-located in [_registry].
@immutable
final class GameModeTheme {
  static const maxDifficultyLevel = 3;

  const GameModeTheme._({
    required this.emoji,
    required this.owlImage,
    required this.owlImageTop,
    required this.difficultyLevel,
    required String Function(GameLocalizations) label,
    required String Function(GameLocalizations) title,
    required String Function(GameLocalizations) subtitle,
    required LinearGradient Function(BrandTheme) gradient,
  })  : _label = label,
        _title = title,
        _subtitle = subtitle,
        _gradient = gradient;

  static final _registry = {
    GameMode.multiplayer: GameModeTheme._(
      emoji: '👥',
      owlImage: TictactoeAssets.owlMulti,
      owlImageTop: TictactoeAssets.owlMultiTop,
      difficultyLevel: null,
      label: (l10n) => l10n.gameModeMultiplayer,
      title: (l10n) => l10n.owlMultiTitle,
      subtitle: (l10n) => l10n.owlMultiSubtitle,
      gradient: (brand) => brand.multiplayerGradient,
    ),
    GameMode.easy: GameModeTheme._(
      emoji: '😊',
      owlImage: TictactoeAssets.owlEasy,
      owlImageTop: TictactoeAssets.owlEasyTop,
      difficultyLevel: 1,
      label: (l10n) => l10n.gameModeEasy,
      title: (l10n) => l10n.owlEasyTitle,
      subtitle: (l10n) => l10n.owlEasySubtitle,
      gradient: (brand) => brand.easyGradient,
    ),
    GameMode.medium: GameModeTheme._(
      emoji: '😐',
      owlImage: TictactoeAssets.owlMedium,
      owlImageTop: TictactoeAssets.owlMediumTop,
      difficultyLevel: 2,
      label: (l10n) => l10n.gameModeMedium,
      title: (l10n) => l10n.owlMediumTitle,
      subtitle: (l10n) => l10n.owlMediumSubtitle,
      gradient: (brand) => brand.mediumGradient,
    ),
    GameMode.hard: GameModeTheme._(
      emoji: '😱',
      owlImage: TictactoeAssets.owlHard,
      owlImageTop: TictactoeAssets.owlHardTop,
      difficultyLevel: 3,
      label: (l10n) => l10n.gameModeHard,
      title: (l10n) => l10n.owlHardTitle,
      subtitle: (l10n) => l10n.owlHardSubtitle,
      gradient: (brand) => brand.hardGradient,
    ),
  };

  static GameModeTheme of(GameMode mode) {
    assert(
      _registry.length == GameMode.values.length,
      'GameModeTheme._registry is incomplete! '
      'Expected ${GameMode.values.length}, got ${_registry.length}',
    );
    return _registry[mode]!;
  }

  final String emoji;
  final String owlImage;
  final String owlImageTop;

  /// Difficulty level for AI modes (1-3), null for multiplayer.
  final int? difficultyLevel;

  final String Function(GameLocalizations) _label;
  final String Function(GameLocalizations) _title;
  final String Function(GameLocalizations) _subtitle;
  final LinearGradient Function(BrandTheme) _gradient;

  String label(GameLocalizations l10n) => _label(l10n);
  String title(GameLocalizations l10n) => _title(l10n);
  String subtitle(GameLocalizations l10n) => _subtitle(l10n);
  LinearGradient gradient(BrandTheme brand) => _gradient(brand);
}

extension GameModeThemeExtension on GameMode {
  GameModeTheme get theme => GameModeTheme.of(this);
}
