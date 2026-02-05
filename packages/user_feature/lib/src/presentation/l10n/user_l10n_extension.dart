import 'package:flutter/widgets.dart';
import 'package:user_feature/l10n/gen/user_localizations.dart';

export 'package:user_feature/src/presentation/l10n/user_localizations_error_extension.dart';

extension UserLocalizationsExtension on BuildContext {
  UserLocalizations get userL10n => UserLocalizations.of(this)!;
}
