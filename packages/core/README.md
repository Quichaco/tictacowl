# core

Foundation package providing **infrastructure concerns** shared across all feature packages.

Includes logging utilities and dependency injection setup (SharedPreferences provider).

## Contents

- Logging utilities
- SharedPreferences provider (dependency injection)

## Setup

**Required override** in your app's ProviderScope:

```dart
sharedPreferencesProvider.overrideWithValue(prefs),
```

## Dependencies

- `common` - Base types
