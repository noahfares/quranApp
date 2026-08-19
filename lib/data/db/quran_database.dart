import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'quran_database.g.dart';

/// The bundled, read-only Quran database — surahs, ayahs, page/juz
/// mapping, coordinates. Never written to. See docs/01-architecture.md §5.
///
/// No tables are declared yet — the bundled `quran.db`'s schema isn't
/// fixed until real content ships (see PROGRESS.md blocker #5). This class
/// only owns the connection lifecycle and the copy-if-newer logic; Phase 1
/// adds typed tables once the schema is known.
@DriftDatabase(tables: [])
class QuranDatabase extends _$QuranDatabase {
  QuranDatabase(super.executor);

  /// In-memory database for tests — never touches disk.
  factory QuranDatabase.forTesting() => QuranDatabase(NativeDatabase.memory());

  /// Opens the read-only copy already on disk at [file].
  factory QuranDatabase.at(File file) => QuranDatabase(
    NativeDatabase(file, setup: (db) => db.execute('PRAGMA query_only = ON;')),
  );

  @override
  int get schemaVersion => 1;
}

/// Copies the bundled `quran.db` asset to [destination], but only if
/// [bundledVersion] differs from whatever version is recorded in
/// `<destination>.version`, or [destination] doesn't exist yet. Returns
/// `true` if a copy happened.
///
/// [loadAsset] defaults to [rootBundle.load] and exists so this can be
/// tested without a real Flutter asset bundle.
Future<bool> ensureQuranDatabaseCopied({
  required File destination,
  required String bundledVersion,
  required String assetPath,
  Future<ByteData> Function(String)? loadAsset,
}) async {
  final load = loadAsset ?? rootBundle.load;
  final versionFile = File('${destination.path}.version');

  final upToDate =
      await destination.exists() &&
      await versionFile.exists() &&
      await versionFile.readAsString() == bundledVersion;
  if (upToDate) return false;

  final bytes = await load(assetPath);
  await destination.create(recursive: true);
  await destination.writeAsBytes(
    bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
  );
  await versionFile.writeAsString(bundledVersion);
  return true;
}
