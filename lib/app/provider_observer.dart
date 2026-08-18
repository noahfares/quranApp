import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging.dart';

/// Logs provider updates in debug builds only.
class DebugProviderObserver extends ProviderObserver {
  const DebugProviderObserver();

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      AppLogger.log('${provider.name ?? provider.runtimeType} -> $newValue');
    }
  }
}
