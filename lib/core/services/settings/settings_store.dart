import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../db/app_database.dart';
import '../../utils/clock.dart';

part 'settings_store.g.dart';

/// Typed JSON access to the [Settings] key/value table.
///
/// Several independent features share this one table (onboarding's visible
/// areas, search's recent-searches list, appearance's theme mode), so they go
/// through one access point instead of each rolling its own SQL against it.
class SettingsStore {
  SettingsStore(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  Future<T?> read<T>(String key, T Function(dynamic json) decode) async {
    final row = await (_db.select(_db.settings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    if (row == null) return null;
    return decode(jsonDecode(row.value));
  }

  Future<void> write(String key, Object? value) async {
    await _db.into(_db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: key,
            value: jsonEncode(value),
            updatedAt: Value(_clock.now()),
          ),
        );
  }

  /// Emits null when the key has never been written.
  Stream<T?> watch<T>(String key, T Function(dynamic json) decode) {
    final query = _db.select(_db.settings)..where((s) => s.key.equals(key));
    return query.watchSingleOrNull().map(
          (row) => row == null ? null : decode(jsonDecode(row.value)),
        );
  }
}

@Riverpod(keepAlive: true)
SettingsStore settingsStore(Ref ref) =>
    SettingsStore(ref.watch(appDatabaseProvider), ref.watch(clockProvider));
