import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/settings_table.dart';

part 'app_database.g.dart';

/// The app's read-write database — page states, sessions, settings, weak
/// spots (as those domains land in later phases). Lives in the app support
/// directory. Never store Quran content here — see docs/01-architecture.md
/// §5.
@DriftDatabase(tables: [Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// In-memory database for tests — never touches disk.
  factory AppDatabase.forTesting() => AppDatabase(NativeDatabase.memory());

  /// Opens (creating if absent) the on-disk database at [file].
  factory AppDatabase.at(File file) =>
      AppDatabase(NativeDatabase.createInBackground(file));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) => m.createAll());
  // No migrations exist yet. The first real schema change adds an
  // `onUpgrade` case here rather than editing `onCreate`, so a fresh
  // install and an upgraded install always converge on the same schema.
}
