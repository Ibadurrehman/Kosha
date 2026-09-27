import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every `<receiver>` the app declares for `flutter_local_notifications` names
/// a Java class by string, and nothing checks that string until Android tries
/// to instantiate it — at which point the *app* dies, not the notification.
///
/// It was wrong for two phases: the manifest said
/// `…flutterlocalnotifications.receivers.ScheduledNotificationBootReceiver`,
/// a package that has never existed in the plugin. The boot receiver listens
/// for `MY_PACKAGE_REPLACED`, so the crash landed on every install and every
/// update, and the delivery receiver would have taken every scheduled
/// reminder down with it. See plan §12.5.5.
///
/// Resolving the class against the plugin version this project actually has
/// means a future upgrade that moves or renames it fails here rather than on
/// a user's phone.
void main() {
  test('every declared notification receiver class exists in the plugin', () {
    final manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

    final declared = RegExp(
      r'<receiver[^>]*android:name\s*=\s*"([^"]+)"',
      multiLine: true,
      dotAll: true,
    ).allMatches(manifest).map((m) => m.group(1)!).toList();

    expect(
      declared,
      isNotEmpty,
      reason: 'the reminders in §8.1 need their receivers declared',
    );

    final pluginRoot = _packageRoot('flutter_local_notifications');
    for (final className in declared) {
      final source = File(
        '$pluginRoot/android/src/main/java/${className.replaceAll('.', '/')}.java',
      );
      expect(
        source.existsSync(),
        isTrue,
        reason: '$className is declared in AndroidManifest.xml but there is no '
            'such class in flutter_local_notifications — Android throws '
            'ClassNotFoundException and kills the app when it tries to '
            'instantiate the receiver',
      );
    }
  });
}

/// The on-disk root of a resolved package, from the package config `pub get`
/// writes. `rootUri` is relative to `.dart_tool/` unless it is absolute.
String _packageRoot(String name) {
  final config = jsonDecode(
    File('.dart_tool/package_config.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final package = (config['packages'] as List)
      .cast<Map<String, dynamic>>()
      .firstWhere((p) => p['name'] == name);

  final uri = Uri.parse(package['rootUri'] as String);
  return uri.hasScheme
      ? uri.toFilePath()
      : Directory('.dart_tool/${package['rootUri']}').absolute.path;
}
