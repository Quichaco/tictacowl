# user_feature

Authentication and profile management with **Firebase**.

Implements the interfaces defined in `user_domain` with Firebase Auth and Firestore.

## Contents

- Firebase Auth implementation
- Firestore user storage
- Auth screens (Login, SignUp)
- Riverpod ViewModels

## Setup

**Required override** in your app's ProviderScope:

```dart
userNavigatorProvider.overrideWith(
  (ref) => YourUserNavigatorImpl(...),
)
```

## Dependencies

- `user_domain` - Interfaces
- `ui_components` - Widgets
