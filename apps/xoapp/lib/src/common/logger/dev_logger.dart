import 'dart:developer' as dev;

import 'package:xoapp/src/common/logger/app_logger.dart';

class DevLogger implements AppLogger {
  static const _name = 'XoApp';

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
