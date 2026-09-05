import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/app.dart';
import 'package:kosha/core/theme/kosha_theme.dart';
import 'package:kosha/core/theme/theme_mode_controller.dart';
import 'package:kosha/shared/widgets/kosha_bottom_nav.dart';

Widget _app() => ProviderScope(
      overrides: [googleFontsEnabledProvider.overrideWithValue(false)],
      child: const KoshaApp(),
    );

/// The tab label inside the bottom bar (screens may repeat the same word).
Finder _tab(String label) =>
    find.descendant(of: find.byType(KoshaBottomNav), matching: find.text(label));

void main() {
  testWidgets('boots into Home with the five-tab bar', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('The dashboard arrives in Phase 1.'), findsOneWidget);
    for (final label in ['Home', 'Tasks', 'Spaces', 'Calendar', 'More']) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('switches branches from the bottom bar', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(_tab('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Tasks arrive in Phase 1.'), findsOneWidget);

    await tester.tap(_tab('Calendar'));
    await tester.pumpAndSettle();
    expect(find.text('The calendar arrives in Phase 1.'), findsOneWidget);
  });

  testWidgets('More links to the States gallery in debug builds', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(_tab('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Design states'));
    await tester.pumpAndSettle();

    // SectionLabel upper-cases its text; the gallery is a lazy list so the
    // lower sections must be scrolled into view before they exist.
    expect(find.text('STATUS PILLS'), findsOneWidget);
    // `.first` is the gallery's ListView; later matches are the horizontal
    // SingleChildScrollView inside SegmentedTabs.
    final list = find.byType(Scrollable).first;
    for (final text in ['Nothing planned for today', "You're offline"]) {
      await tester.scrollUntilVisible(find.text(text), 300, scrollable: list);
      expect(find.text(text), findsOneWidget);
    }
  });

  testWidgets('theme mode provider drives dark mode', (tester) async {
    final container = ProviderContainer(
      overrides: [googleFontsEnabledProvider.overrideWithValue(false)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const KoshaApp()),
    );
    await tester.pumpAndSettle();

    container.read(themeModeProvider.notifier).set(ThemeMode.dark);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}
