import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/data/db/quran_database.dart';

void main() {
  group('QuranDatabase (in-memory)', () {
    test('opens and reports schemaVersion 1', () {
      final db = QuranDatabase.forTesting();
      expect(db.schemaVersion, 1);
      db.close();
    });
  });

  group('ensureQuranDatabaseCopied', () {
    late Directory tempDir;
    late File destination;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hifz_quran_db_test');
      destination = File('${tempDir.path}/quran.db');
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    Future<ByteData> fakeAsset(String path) async {
      return ByteData.sublistView(Uint8List.fromList([1, 2, 3, 4]));
    }

    test('copies when the destination does not exist yet', () async {
      final copied = await ensureQuranDatabaseCopied(
        destination: destination,
        bundledVersion: 'v1',
        assetPath: 'assets/quran.db',
        loadAsset: fakeAsset,
      );

      expect(copied, isTrue);
      expect(await destination.exists(), isTrue);
      expect(await File('${destination.path}.version').readAsString(), 'v1');
    });

    test('does not re-copy when the version is unchanged', () async {
      await ensureQuranDatabaseCopied(
        destination: destination,
        bundledVersion: 'v1',
        assetPath: 'assets/quran.db',
        loadAsset: fakeAsset,
      );

      var loadCount = 0;
      Future<ByteData> countingAsset(String path) {
        loadCount++;
        return fakeAsset(path);
      }

      final copied = await ensureQuranDatabaseCopied(
        destination: destination,
        bundledVersion: 'v1',
        assetPath: 'assets/quran.db',
        loadAsset: countingAsset,
      );

      expect(copied, isFalse);
      expect(loadCount, 0);
    });

    test('re-copies when the bundled version is newer', () async {
      await ensureQuranDatabaseCopied(
        destination: destination,
        bundledVersion: 'v1',
        assetPath: 'assets/quran.db',
        loadAsset: fakeAsset,
      );

      final copied = await ensureQuranDatabaseCopied(
        destination: destination,
        bundledVersion: 'v2',
        assetPath: 'assets/quran.db',
        loadAsset: fakeAsset,
      );

      expect(copied, isTrue);
      expect(await File('${destination.path}.version').readAsString(), 'v2');
    });
  });
}
