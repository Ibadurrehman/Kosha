import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/home/domain/entities/dashboard_section.dart';
import 'package:kosha/features/settings/presentation/customize_dashboard_screen.dart';
import 'package:kosha/shared/widgets/kosha_toggle.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('toggling a section and saving persists it, disabled',
      (tester) async {
    await tester.pumpWidget(wrapPushedScreen(const CustomizeDashboardScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Needs attention'), findsOneWidget);

    await tester.tap(find.byType(KoshaToggle).first);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final sections = await db.select(db.dashboardSections).get();
    final attention =
        sections.firstWhere((s) => s.key == HomeSectionKey.attention.name);
    expect(attention.enabled, isFalse);
    await settleAndDispose(tester);
  });

  testWidgets('shows a toast naming how many sections stay on Home',
      (tester) async {
    await tester.pumpWidget(wrapPushedScreen(const CustomizeDashboardScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pump();

    expect(find.textContaining('sections shown on Home'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
