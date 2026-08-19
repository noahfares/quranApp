import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/logging.dart';
import '../ui/widgets/error_recovery_screen.dart';

/// Startup sequence: binding init and the global error handler. Call this
/// before `runApp`. See docs/01-architecture.md §8 — unexpected exceptions
/// bubble here, get logged, and show a recovery screen instead of a blank
/// or garbled one. There is no crash reporting service (no-telemetry rule).
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.log('Uncaught Flutter error', error: details.exception);
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (details) => const ErrorRecoveryScreen();

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.log('Uncaught platform error', error: error);
    return true;
  };
}
