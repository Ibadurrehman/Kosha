import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/settings/settings_store.dart';
import '../../domain/notification_settings.dart';

part 'settings_providers.g.dart';

@riverpod
Future<bool> taskRemindersEnabled(Ref ref) =>
    readTaskRemindersEnabled(ref.watch(settingsStoreProvider));
