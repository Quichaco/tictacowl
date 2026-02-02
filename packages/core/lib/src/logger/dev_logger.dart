import 'dart:developer' as dev;

import 'package:core/src/logger/app_logger.dart';

class DevLogger implements AppLogger {
  const DevLogger([this._name = 'App']);

  final String _name;

  @override
  void debug(String message) {
    dev.log(message, name: _name, level: 500);
  }

  @override
  void info(String message) {
    dev.log(message, name: _name, level: 800);
  }

  @override
  void warning(String message) {
    dev.log(message, name: _name, level: 900);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    dev.log(message, error: error, stackTrace: stackTrace, name: _name, level: 1000);
  }
}
