import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:user_feature/user_feature.dart';
import 'package:xoapp/src/presentation/screens/home_screen.dart';
import 'package:xoapp/src/presentation/screens/settings_screen.dart';
import 'package:xoapp/src/presentation/screens/welcome_screen.dart';
import 'package:xoapp/src/routing/app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcomePath,
    refreshListenable: _RefreshNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final userViewModel = ref.read(userViewModelProvider);
      final path = state.matchedLocation;
      final isPublicRoute = AppRoutes.publicPaths.contains(path);
      final isOnboarding = path.startsWith(AppRoutes.onboardingPath);

      if (authState.isLoading) return null;

      if (authState.value == null) {
        return isPublicRoute ? null : AppRoutes.welcomePath;
      }

      if (userViewModel.isLoading) return null;

      if (userViewModel.value == null) {
        return isOnboarding ? null : AppRoutes.usernamePath;
      }

      if (isPublicRoute || isOnboarding) {
        return AppRoutes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcomePath,
        builder: (_, _) => const WelcomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (_, _) => const LoginScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.forgotPassword,
                builder: (_, _) => const ForgotPasswordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.signUp,
            builder: (_, _) => const SignUpScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.usernamePath,
        builder: (_, _) => const SetUsernameScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.game,
            builder: (_, _) => const GameScreen(),
          ),
        ],
      ),
    ],
  );
}

class _RefreshNotifier extends ChangeNotifier {
  _RefreshNotifier(this._ref) {
    _ref.listen(authViewModelProvider, (_, _) => notifyListeners());
    _ref.listen(userViewModelProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}
