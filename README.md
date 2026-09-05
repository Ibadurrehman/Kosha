# Kosha — Personal Life OS

A Flutter app that keeps tasks, bills, spending, documents, vehicle and home
records, shopping lists, notes, goals and shared trip expenses in one place.

- Product spec and roadmap: [project-doc/Kosha-Master-Implementation-Plan.md](project-doc/Kosha-Master-Implementation-Plan.md)
- Clickable prototype: `project-doc/Kosha - Personal Life OS.html` (open in a browser)
- Architecture decisions: [project-doc/decisions](project-doc/decisions)

## Prerequisites

- Flutter 3.44.x stable (Dart 3.12). Check with `flutter --version`.
- Android Studio with an API 24+ emulator, or Xcode 15+ for iOS.
- Release builds on Android need `android/key.properties`; copy
  `android/key.properties.example` and fill it in. The file is gitignored.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # or tool/gen.sh, tool\gen.ps1
flutter run --dart-define-from-file=config/dev.json
```

Flavors are plain `--dart-define` files under `config/`:

| File | Purpose |
|---|---|
| `config/dev.json` | Seeds demo data, shows the debug States gallery, crash reporting off |
| `config/prod.json` | Release configuration |

VS Code launch configurations for both live in `.vscode/launch.json`.

## Project layout

```
lib/
  main.dart            runApp only
  bootstrap.dart       ProviderScope, error handling, DB and timezone init
  app.dart             MaterialApp.router, theme
  core/                config, db, router, theme, services, utils
  shared/              design-system widgets, sheets, toast/undo state
  features/<name>/     data / domain / presentation per feature
test/                  mirrors lib/
integration_test/      end-to-end flows
```

See section 4 of the implementation plan for the layering rules.

## Everyday commands

```bash
flutter analyze
flutter test
tool/gen.sh watch        # keep generated code fresh while developing
```

## Platform targets

Android and iOS are the release targets. The `web/`, `windows/`, `macos/` and
`linux/` folders are kept for quick local UI iteration only and are not built in CI.

Running on the web needs two files drift cannot get from pub, because sqlite3 has
to be compiled to wasm for a browser: `web/sqlite3.wasm` and `web/drift_worker.js`.
Both are committed, and both ship with the drift release pinned in `pubspec.lock`,
so refresh them after upgrading drift:

```bash
tool/fetch_web_assets.sh        # or tooletch_web_assets.ps1
```

Drift stores the database in OPFS and needs a worker to reach it, so the web build
only runs in a real browser tab — an embedded webview that cannot start a worker
from inside another worker will hang on the first query.
