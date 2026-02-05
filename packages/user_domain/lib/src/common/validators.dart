/// Shared validators for user input.
abstract class Validators {
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int maxNameLength = 30;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Validates email format. Returns error message or null if valid.
  static String? email(String? value, {required String invalidMessage}) {
    if (value == null || !_emailRegex.hasMatch(value.trim())) {
      return invalidMessage;
    }
    return null;
  }

  /// Validates password strength. Returns error message or null if valid.
  static String? password(String? value, {required String tooShortMessage}) {
    if (value == null || value.length < minPasswordLength) {
      return tooShortMessage;
    }
    return null;
  }

  /// Validates username. Returns error message or null if valid.
  static String? name(
    String? value, {
    required String tooShortMessage,
    required String tooLongMessage,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length < minNameLength) {
      return tooShortMessage;
    }
    if (trimmed.length > maxNameLength) {
      return tooLongMessage;
    }
    return null;
  }
}
