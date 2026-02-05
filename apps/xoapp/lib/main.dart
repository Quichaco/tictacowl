import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:user_feature/user_feature.dart';
import 'package:xoapp/firebase_options.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';
import 'package:xoapp/src/common/observers/app_provider_observer.dart';
import 'package:xoapp/src/presentation/viewmodels/locale_viewmodel.dart';
import 'package:xoapp/src/presentation/viewmodels/theme_viewmodel.dart';
import 'package:xoapp/src/providers/app_ready_provider.dart';
import 'package:xoapp/src/routing/app_router.dart';
import 'package:xoapp/src/routing/game_navigator_impl.dart';
import 'package:xoapp/src/routing/user_navigator_impl.dart';
import 'package:xoapp/theme/app_theme.dart';

const _logger = DevLogger('XoApp');

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    _logger.error(
      'Flutter error: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _logger.error('Platform error: $error', error: error, stackTrace: stack);
    return true;
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver(_logger)],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        userNavigatorProvider.overrideWith(
          (ref) => UserNavigatorImpl(ref.watch(appRouterProvider)),
        ),
        gameNavigatorProvider.overrideWith(
          (ref) => GameNavigatorImpl(ref.watch(appRouterProvider)),
        ),
        playerNameProvider.overrideWith(
          (ref) => ref.watch(
            userViewModelProvider.select((async) => async.value?.name ?? ''),
          ),
        ),
      ],
      child: const XoApp(),
    ),
  );
}

class XoApp extends ConsumerWidget {
  const XoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appReadyProvider, (_, isReady) {
      if (isReady) FlutterNativeSplash.remove();
    });

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeViewModelProvider);
    final locale = ref.watch(localeViewModelProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        UserLocalizations.delegate,
        GameLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
