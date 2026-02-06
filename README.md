# Tic Tac Owl

A modern and complete TicTacToe game, built with Flutter.

## Project Context

This project was developed as a **technical test for Betclic**.

During my interview with Théo, I learned that Betclic uses **Melos** to manage their Flutter monorepos. Having never used this tool before, I decided to adopt it for this project to train myself before a potential collaboration with the team.

I also implemented a **Clean Architecture MVVM** pattern to ensure a clear separation of concerns and maintainable codebase.

## Tech Stack

| Category | Technologies |
|----------|-------------|
| **Framework** | Flutter 3.10+ / Dart 3.10+ |
| **Architecture** | Clean Architecture MVVM (Domain / Feature / App) |
| **Monorepo** | Melos |
| **State Management** | Riverpod 3 + Hooks |
| **Navigation** | GoRouter |
| **Backend** | Firebase (Auth, Firestore, Crashlytics) |
| **Code Generation** | Freezed, json_serializable, riverpod_generator |
| **Testing** | flutter_test, mocktail, fake_cloud_firestore |

## Project Structure

```
xogame/
├── apps/
│   └── xoapp/                 # Main Flutter application
├── packages/
│   ├── common/                # Shared Dart types (Result, exceptions)
│   ├── core/                  # Interfaces and utilities (logging, DI)
│   ├── ui_components/         # Design system (theme, reusable widgets)
│   ├── tictactoe_domain/      # Game business logic (pure Dart)
│   ├── tictactoe_feature/     # Game UI and state management
│   ├── user_domain/           # User models and use cases
│   └── user_feature/          # Authentication and profile (Firebase)
└── melos.yaml                 # Melos configuration
```

## Required Provider Overrides

When using the feature packages, some providers **must be overridden** by the app:

```dart
ProviderScope(
  overrides: [
    // core - SharedPreferences instance
    sharedPreferencesProvider.overrideWithValue(prefs),

    // user_feature - Navigation implementation
    userNavigatorProvider.overrideWith(
      (ref) => UserNavigatorImpl(ref.watch(appRouterProvider)),
    ),

    // tictactoe_feature - Navigation implementation
    gameNavigatorProvider.overrideWith(
      (ref) => GameNavigatorImpl(ref.watch(appRouterProvider)),
    ),

    // tictactoe_feature - Current player name from user
    playerNameProvider.overrideWith(
      (ref) => ref.watch(userViewModelProvider.select((u) => u.value?.name ?? '')),
    ),
  ],
  child: MyApp(),
)
```

| Provider | Package | Purpose |
|----------|---------|---------|
| `sharedPreferencesProvider` | core | SharedPreferences instance |
| `userNavigatorProvider` | user_feature | Auth flow navigation |
| `gameNavigatorProvider` | tictactoe_feature | Game flow navigation |
| `playerNameProvider` | tictactoe_feature | Player name for game display |

## Prerequisites

- Flutter SDK >= 3.10.8
- Dart SDK >= 3.10.8
- Melos (`dart pub global activate melos`)
- A configured Firebase project (for authentication)

## Installation

```bash
# Clone the repo
git clone <repo-url>
cd xogame

# Install Melos globally (if not already done)
dart pub global activate melos

# Install dependencies for all packages
melos bootstrap

# Generate code (Freezed, Riverpod, etc.)
melos gen
```

## Run the Application

```bash
cd apps/xoapp && flutter run
```

## Melos Commands

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Install dependencies for all packages |
| `melos analyze` | Static code analysis |
| `melos test` | Run Dart tests (packages) |
| `melos flutter_test` | Run Flutter tests (apps) |
| `melos gen` | Generate code (build_runner) |

## Build

### Android

```bash
cd apps/xoapp
flutter build apk          # Debug APK
flutter build appbundle    # App Bundle (Play Store)
```

### iOS

```bash
cd apps/xoapp
flutter build ios          # iOS build
flutter build ipa          # IPA for distribution
```

## Features

- Play TicTacToe against an AI (3 difficulty levels)
- Configurable multi-round mode (1, 3, 5 rounds)
- Authentication (email/password)
- Light/Dark theme
- Multilingual support (FR/EN)
- Animations and visual effects (confetti, transitions)

