import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';
import 'package:xoapp/src/common/logger/dev_logger.dart';
import 'package:xoapp/src/common/observers/app_provider_observer.dart';
import 'package:xoapp/src/common/providers/shared_preferences_provider.dart';
import 'package:xoapp/src/routing/app_router.dart';
import 'package:xoapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver(DevLogger())],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const XoApp(),
    ),
  );
}

class XoApp extends ConsumerWidget {
  const XoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
