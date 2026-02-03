import 'package:flutter/material.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';

extension BuildContextL10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  GameLocalizations get gameL10n => GameLocalizations.of(this)!;
}
