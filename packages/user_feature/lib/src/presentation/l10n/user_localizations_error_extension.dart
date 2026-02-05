import 'package:common/common.dart';
import 'package:user_feature/l10n/gen/user_localizations.dart';

extension UserLocalizationsErrorExtension on UserLocalizations {
  String getErrorMessage(AppException exception) {
    return switch (exception) {
      AuthException(:final code) => _mapAuthCode(code),
      NetworkException() => errorNetworkRequestFailed,
      ServerException() => errorUnknown,
      NotFoundException() => errorUserNotFound,
      UnknownException() => errorUnknown,
    };
  }

  String _mapAuthCode(String code) {
    return switch (code) {
      'invalid-email' => errorInvalidEmail,
      'user-disabled' => errorUserDisabled,
      'user-not-found' => errorUserNotFound,
      'wrong-password' => errorWrongPassword,
      'invalid-credential' => errorInvalidCredential,
      'email-already-in-use' => errorEmailAlreadyInUse,
      'weak-password' => errorWeakPassword,
      'too-many-requests' => errorTooManyRequests,
      'network-request-failed' => errorNetworkRequestFailed,
      'timeout' => errorTimeout,
      'not-signed-in' => errorNotSignedIn,
      _ => errorUnknown,
    };
  }
}
