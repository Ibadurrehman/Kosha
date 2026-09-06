import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/settings/settings_store.dart';

const String themeModeSettingKey = 'appearance.theme_mode';

/// Light / Dark / System, persisted through the Settings table.
///
/// `build()` returns [ThemeMode.system] immediately and kicks off an async
/// load of the persisted value in the background; `set()` updates state
/// synchronously and persists without waiting. The one frame between launch
/// and the persisted value loading is an accepted, effectively invisible
/// trade-off — the same category as the app's onboarding splash gate.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    unawaited(_load());
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final stored = await ref.read(settingsStoreProvider).read(
          themeModeSettingKey,
          (json) => ThemeMode.values.byName(json as String),
        );
    if (stored != null) state = stored;
  }

  void set(ThemeMode mode) {
    state = mode;
    unawaited(ref.read(settingsStoreProvider).write(themeModeSettingKey, mode.name));
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
