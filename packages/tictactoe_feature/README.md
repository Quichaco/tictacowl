# tictactoe_feature

TicTacToe UI and state management.

Bridges `tictactoe_domain` business logic with Flutter UI components.


## Contents

- Game screens (board, result)
- Riverpod ViewModels
- Game widgets (cells, board, scores)
- Preferences persistence

## Setup

**Required overrides** in your app's ProviderScope:

```dart
gameNavigatorProvider.overrideWith(
  (ref) => YourGameNavigatorImpl(...),
),
playerNameProvider.overrideWith(
  (ref) => 'Player name from your user system',
),
```

## Dependencies

- `tictactoe_domain` - Game logic
- `ui_components` - Design system
