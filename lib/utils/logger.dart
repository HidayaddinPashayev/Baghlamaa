import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _prefix = '[Yolçanta]';

  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('$_prefix [DEBUG] $message');
      if (error != null) {
        print('$_prefix [ERROR] $error');
      }
      if (stackTrace != null) {
        print('$_prefix [STACK] $stackTrace');
      }
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('$_prefix [INFO] $message');
    }
  }

  static void warning(String message, {dynamic error}) {
    print('$_prefix [WARNING] $message');
    if (error != null) {
      print('$_prefix [ERROR] $error');
    }
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    print('$_prefix [ERROR] $message');
    if (error != null) {
      print('$_prefix [DETAILS] $error');
    }
    if (stackTrace != null) {
      print('$_prefix [STACK] $stackTrace');
    }
  }
}
