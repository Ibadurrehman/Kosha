import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/app.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/theme/theme_mode_controller.dart';
import 'package:kosha/shared/widgets/kosha_bottom_nav.dart';

import 'helpers/test_app.dart';

/// The tab label inside the bottom bar (screens may repeat the same word).
Finder _tab(String label) =>
    find.descendant(of: find.byType(KoshaBottomNav), matching: find.text(label));

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('boots into Home with the five-tab bar', (tester) async {
    await seedCompletedProfile(db);
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    for (final label in ['Home', 'Tasks', 'Spaces', 'Calendar', 'More']) {
      expect(_tab(label), findsOneWidget);
    }
    await settleAndDispose(tester);
  });

  testWidgets('switches branches from the bottom bar', (tester) async {
    await seedCompletedProfile(db);
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(_tab('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing planned for today'), findsOneWidget);

    await tester.tap(_tab('Calendar'));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('More links to the States gallery in debug builds',
      (tester) async {
    await seedCompletedProfile(db);
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(_tab('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Design states'));
    await tester.pumpAndSettle();

    // SectionLabel upper-cases its text; the gallery is a lazy list, so the
    // lower sections must be scrolled into view before they exist.
    expect(find.text('STATUS PILLS'), findsOneWidget);
    final list = find.byType(Scrollable).first;
    for (final text in ['Nothing planned for today', "You're offline"]) {
      await tester.scrollUntilVisible(find.text(text), 300, scrollable: list);
      expect(find.text(text), findsOneWidget);
    }
    await settleAndDispose(tester);
  });

  testWidgets('theme mode provider drives dark mode', (tester) async {
    await seedCompletedProfile(db);
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(KoshaApp)));
    container.read(themeModeProvider.notifier).set(ThemeMode.dark);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
    await settleAndDispose(tester);
  });
}
