import 'dart:developer' as developer;

/// Thin wrapper over `dart:developer` logging — pure Dart, safe for
/// `domain/`. Not a full logging framework; just a single place to route
/// through so a real one can replace it later without touching call sites.
abstract final class AppLogger {
  static void log(String message, {String name = 'hifz', Object? error}) {
    developer.log(message, name: name, error: error);
  }
}
