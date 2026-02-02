import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:xoapp/src/presentation/screens/home_screen.dart';
import 'package:xoapp/src/presentation/screens/settings_screen.dart';
import 'package:xoapp/src/presentation/screens/welcome_screen.dart';
import 'package:xoapp/src/routing/app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    redirect: (context, state) async {
      final user = await ref.read(userViewModelProvider.future);
      final isLoggedIn = user != null;
      final isOnWelcome = state.matchedLocation == AppRoutes.welcome;

      if (isLoggedIn && isOnWelcome) return AppRoutes.home;
      if (!isLoggedIn && !isOnWelcome) return AppRoutes.welcome;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.settingsSegment,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.gameSegment,
            builder: (context, state) => const GameScreen(),
          ),
        ],
      ),
    ],
  );
}
