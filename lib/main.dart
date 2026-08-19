import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/provider_observer.dart';

void main() {
  bootstrap();
  runApp(
    ProviderScope(
      observers: [const DebugProviderObserver()],
      child: const App(),
    ),
  );
}
