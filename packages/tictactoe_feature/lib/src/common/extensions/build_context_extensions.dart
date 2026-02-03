import 'package:flutter/widgets.dart';
import 'package:tictactoe_feature/l10n/gen/game_localizations.dart';

extension BuildContextExtensions on BuildContext {
  GameLocalizations get l10n => GameLocalizations.of(this)!;
}
