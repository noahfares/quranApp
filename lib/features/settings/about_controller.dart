import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads the bundled attribution text for the About screen (`SET-08`).
/// See assets/ATTRIBUTION.md and docs/02-data-sources.md §9.
final aboutAttributionProvider = FutureProvider<String>((ref) {
  return rootBundle.loadString('assets/ATTRIBUTION.md');
});
