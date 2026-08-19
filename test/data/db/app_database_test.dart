import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/data/db/app_database.dart';

void main() {
  group('AppDatabase (in-memory)', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting();
    });

    tearDown(() => db.close());

    test('round-trips a row through the settings table', () async {
      await db
          .into(db.settings)
          .insert(SettingsCompanion.insert(key: 'theme', value: 'sepia'));

      final row = await (db.select(
        db.settings,
      )..where((t) => t.key.equals('theme'))).getSingle();

      expect(row.value, 'sepia');
    });

    test('schemaVersion is 1', () {
      expect(db.schemaVersion, 1);
    });
  });

  group('AppDatabase (on disk)', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hifz_app_db_test');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    test('deleting the file and reopening recovers cleanly', () async {
      final file = File('${tempDir.path}/app.db');

      final first = AppDatabase.at(file);
      await first
          .into(first.settings)
          .insert(SettingsCompanion.insert(key: 'theme', value: 'dark'));
      await first.close();

      expect(await file.exists(), isTrue);
      await file.delete();

      final second = AppDatabase.at(file);
      final rows = await second.select(second.settings).get();
      await second.close();

      expect(rows, isEmpty);
    });
  });
}
