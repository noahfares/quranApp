import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Platform-correct storage locations, so neither Android's nor iOS's
/// rules leak into feature code — see docs/01-architecture.md §7. The iOS
/// branch is exercised by `path_provider` itself and compiles in CI, but
/// isn't behaviourally verified on a real device until Phase 11 (ADR
/// 0007) — no Apple Developer Program enrolment yet.
abstract final class AppPaths {
  /// Where `app.db` lives.
  static Future<File> appDatabaseFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/app.db');
  }

  /// Where the copied, read-only `quran.db` lives.
  static Future<File> quranDatabaseFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/quran.db');
  }

  /// Downloaded page images and audio. Must never sync to cloud backup —
  /// `path_provider`'s cache directory already resolves to a
  /// backup-excluded location on both platforms.
  static Future<Directory> downloadCacheDirectory() {
    return getApplicationCacheDirectory();
  }
}
