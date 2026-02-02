abstract class AppRoutes {
  static const welcome = '/';
  static const home = '/home';

  // Segments (for nested routes)
  static const settingsSegment = 'settings';
  static const gameSegment = 'game';

  // Full paths
  static const settings = '$home/$settingsSegment';
  static const game = '$home/$gameSegment';
}
