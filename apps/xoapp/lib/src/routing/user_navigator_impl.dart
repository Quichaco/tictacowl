import 'package:go_router/go_router.dart';
import 'package:user_feature/user_feature.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class UserNavigatorImpl implements UserNavigator {
  UserNavigatorImpl(this._router);

  final GoRouter _router;

  @override
  void goToLogin() => _router.go(AppRoutes.loginPath);

  @override
  void goToSignUp() => _router.go(AppRoutes.signUpPath);

  @override
  void goToForgotPassword() => _router.go(AppRoutes.forgotPasswordPath);

}
