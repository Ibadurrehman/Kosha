# ADR 0002 — When to add database encryption

**Status:** Accepted · 2026-09-05 · resolves plan decision D5

## Decision
Phase 0 ships an unencrypted SQLite database through `drift_flutter`. SQLCipher-backed encryption of the database and attachments is added in Phase 6 (hardening), before the first store release.

## Why
- `package:sqlite3` 3.x now builds SQLite natively through Dart build hooks; the old `sqlite3_flutter_libs` / `sqlcipher_flutter_libs` packages are end-of-life no-ops. Encryption is now configured through `sqlite3` build options rather than a drop-in package, so it is better done once the toolchain has settled.
- Nothing in Phases 0–5 depends on the storage layer being encrypted; the schema, DAOs and repositories are identical either way.
- Deferring keeps `flutter run` and CI simple while the app is being built.

## Consequences
- Phase 6 must include: enabling the SQLCipher build option for `sqlite3`, key generation stored in `flutter_secure_storage`, a one-time migration that re-keys the existing database, and encryption of the attachments directory.
- Dogfood builds before Phase 6 store personal data unencrypted on device; the app lock (also Phase 6) is the only protection. Do not distribute externally before Phase 6.
