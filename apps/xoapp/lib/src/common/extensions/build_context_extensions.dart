import 'package:flutter/widgets.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    assert(localizations != null, 'No AppLocalizations found in context. Did you add AppLocalizations.delegate to your MaterialApp?');
    return localizations!;
  }
}
