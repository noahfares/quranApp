import 'package:drift/drift.dart';

/// Simple key-value app settings. See docs/01-architecture.md §5
/// ("Page states, sessions, settings, weak spots").
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
