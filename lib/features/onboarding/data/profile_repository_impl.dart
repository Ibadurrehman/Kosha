import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/settings/settings_store.dart';
import '../../../core/utils/clock.dart';
import '../domain/area.dart';
import '../domain/entities/profile.dart';
import '../domain/profile_repository.dart';

part 'profile_repository_impl.g.dart';

const String _localProfileId = 'local';
const String _visibleAreasKey = 'onboarding.visible_areas';

/// The areas selected before "Pick areas" has ever run.
const Set<OnboardingArea> defaultVisibleAreas = {
  OnboardingArea.tasks,
  OnboardingArea.finance,
  OnboardingArea.bills,
  OnboardingArea.documents,
  OnboardingArea.shopping,
};

/// SQLite-backed profile, seeded lazily on first read.
///
/// `MigrationStrategy` callbacks have no `Clock`, so seeding the row there
/// would mean reading `DateTime.now()` directly and breaking the rule that
/// every "now" goes through the injected [Clock]. Seeding here instead keeps
/// it inside the normal repository discipline, the same as every other write.
class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._db, this._clock, this._settings);

  final AppDatabase _db;
  final Clock _clock;
  final SettingsStore _settings;

  @override
  Stream<Profile> watchProfile() async* {
    await _ensureSeeded();
    final query = _db.select(_db.profiles)
      ..where((p) => p.id.equals(_localProfileId));
    yield* query.watchSingle().map(_toDomain);
  }

  @override
  Future<Profile> current() async {
    await _ensureSeeded();
    final row = await (_db.select(_db.profiles)
          ..where((p) => p.id.equals(_localProfileId)))
        .getSingle();
    return _toDomain(row);
  }

  @override
  Future<void> completeOnboarding() async {
    await _ensureSeeded();
    await (_db.update(_db.profiles)..where((p) => p.id.equals(_localProfileId)))
        .write(
      ProfilesCompanion(
        onboardingCompleted: const Value(true),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Future<Set<OnboardingArea>> visibleAreas() async {
    final stored = await _settings.read(
      _visibleAreasKey,
      (json) => (json as List).cast<String>(),
    );
    if (stored == null) return defaultVisibleAreas;
    return {
      for (final name in stored)
        if (OnboardingArea.values.any((area) => area.name == name))
          OnboardingArea.values.byName(name),
    };
  }

  @override
  Future<void> setVisibleAreas(Set<OnboardingArea> areas) =>
      _settings.write(_visibleAreasKey, [for (final area in areas) area.name]);

  Future<void> _ensureSeeded() async {
    final now = _clock.now();
    await _db.into(_db.profiles).insert(
          ProfilesCompanion.insert(
            id: _localProfileId,
            joinedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Profile _toDomain(ProfileRow row) => Profile(
        id: row.id,
        name: row.name,
        email: row.email,
        avatarInitials: row.avatarInitials,
        joinedAt: row.joinedAt,
        currency: row.currency,
        dateFormat: row.dateFormat,
        weekStart: row.weekStart,
        locale: row.locale,
        onboardingCompleted: row.onboardingCompleted,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => DriftProfileRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(settingsStoreProvider),
    );
