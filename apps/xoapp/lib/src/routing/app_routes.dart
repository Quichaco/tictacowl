abstract final class AppRoutes {
  // Segments
  static const login = 'login';
  static const signUp = 'sign-up';
  static const forgotPassword = 'forgot-password';
  static const onboarding = 'onboarding';
  static const username = 'username';
  static const home = 'home';
  static const settings = 'settings';
  static const game = 'game';

  // Paths
  static const welcomePath = '/';
  static const loginPath = '/$login';
  static const signUpPath = '/$signUp';
  static const forgotPasswordPath = '$loginPath/$forgotPassword';
  static const onboardingPath = '/$onboarding';
  static const usernamePath = '$onboardingPath/$username';
  static const homePath = '/$home';
  static const settingsPath = '$homePath/$settings';
  static const gamePath = '$homePath/$game';

  static const publicPaths = {
    welcomePath,
    loginPath,
    signUpPath,
    forgotPasswordPath,
  };
}
