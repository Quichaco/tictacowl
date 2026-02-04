import 'package:flutter/material.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/l10n/gen/game_localizations.dart';
import 'package:tictactoe_feature/src/common/constants/tictactoe_assets.dart';
import 'package:ui_components/ui_components.dart';

/// UI theme data for [Difficulty].
/// All presentation data is co-located in [_registry].
@immutable
final class DifficultyTheme {
  const DifficultyTheme._({
    required this.emoji,
    required this.owlImage,
    required this.owlImageTop,
    required String Function(GameLocalizations) label,
    required String Function(GameLocalizations) title,
    required String Function(GameLocalizations) subtitle,
    required LinearGradient Function(BrandTheme) gradient,
  })  : _label = label,
        _title = title,
        _subtitle = subtitle,
        _gradient = gradient;

  static final _registry = {
    Difficulty.easy: DifficultyTheme._(
      emoji: '😊',
      owlImage: TictactoeAssets.owlEasy,
      owlImageTop: TictactoeAssets.owlEasyTop,
      label: (l10n) => l10n.difficultyEasy,
      title: (l10n) => l10n.owlEasyTitle,
      subtitle: (l10n) => l10n.owlEasySubtitle,
      gradient: (brand) => brand.easyGradient,
    ),
    Difficulty.medium: DifficultyTheme._(
      emoji: '😐',
      owlImage: TictactoeAssets.owlMedium,
      owlImageTop: TictactoeAssets.owlMediumTop,
      label: (l10n) => l10n.difficultyMedium,
      title: (l10n) => l10n.owlMediumTitle,
      subtitle: (l10n) => l10n.owlMediumSubtitle,
      gradient: (brand) => brand.mediumGradient,
    ),
    Difficulty.hard: DifficultyTheme._(
      emoji: '😱',
      owlImage: TictactoeAssets.owlHard,
      owlImageTop: TictactoeAssets.owlHardTop,
      label: (l10n) => l10n.difficultyHard,
      title: (l10n) => l10n.owlHardTitle,
      subtitle: (l10n) => l10n.owlHardSubtitle,
      gradient: (brand) => brand.hardGradient,
    ),
  };

  static DifficultyTheme of(Difficulty difficulty) {
    assert(
      _registry.length == Difficulty.values.length,
      'DifficultyTheme._registry is incomplete! '
      'Expected ${Difficulty.values.length}, got ${_registry.length}',
    );
    return _registry[difficulty]!;
  }

  final String emoji;
  final String owlImage;
  final String owlImageTop;

  final String Function(GameLocalizations) _label;
  final String Function(GameLocalizations) _title;
  final String Function(GameLocalizations) _subtitle;
  final LinearGradient Function(BrandTheme) _gradient;

  String label(GameLocalizations l10n) => _label(l10n);
  String title(GameLocalizations l10n) => _title(l10n);
  String subtitle(GameLocalizations l10n) => _subtitle(l10n);
  LinearGradient gradient(BrandTheme brand) => _gradient(brand);
}

extension DifficultyThemeExtension on Difficulty {
  DifficultyTheme get theme => DifficultyTheme.of(this);
}
