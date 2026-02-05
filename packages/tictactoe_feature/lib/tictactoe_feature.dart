library;

// L10n - export the generated localizations
export 'l10n/gen/game_localizations.dart';

// Navigation
export 'src/navigation/game_navigator.dart';

// Providers (to be overridden by app)
export 'src/providers/player_name_provider.dart';

// Constants
export 'src/common/constants/tictactoe_assets.dart';

// Theme
export 'src/common/models/game_mode_theme.dart';

// ViewModels
export 'src/presentation/viewmodels/game_config_viewmodel.dart';

// Screens
export 'src/presentation/screens/game_screen.dart';

// Widgets
export 'src/presentation/widgets/pickers/game_mode_carousel.dart';

// Re-export domain for convenience
export 'package:tictactoe_domain/tictactoe_domain.dart';
