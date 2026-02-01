import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xoapp/src/common/logger/app_logger.dart';

final class AppProviderObserver extends ProviderObserver {
  final AppLogger _logger;

  AppProviderObserver(this._logger);

  String _name(ProviderObserverContext context) =>
      context.provider.name ?? context.provider.runtimeType.toString();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.error(
      '${_name(context)} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
