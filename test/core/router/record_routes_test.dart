import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/router/app_router.dart';
import 'package:kosha/core/theme/kosha_theme.dart';
import 'package:kosha/features/spaces/data/record_repository_impl.dart';
import 'package:kosha/features/spaces/domain/entities/record_template.dart';
import 'package:kosha/features/spaces/presentation/custom_records_screen.dart';
import 'package:kosha/features/spaces/presentation/record_template_builder_screen.dart';
import 'package:kosha/shared/widgets/toast_host.dart';

import '../../helpers/test_app.dart';

/// Custom records are the first routes in the app declared as siblings under a
/// path with nothing at its root, so these walk the real router rather than
/// pumping the screens directly.
///
/// The shape they guard: go_router runs the route-level redirect of *every*
/// match in the stack, not just the last, so a redirect-only `/records` parent
/// silently takes `/records/<id>` and `/records/<id>/fields` with it. A screen
/// test would never have seen it.
void main() {
  late AppDatabase db;
  late DriftRecordRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRecordRepository(db);
  });

  tearDown(() => db.close());

  Future<RecordTemplate> insurance() => repository.createTemplate(
        const NewRecordTemplate(name: 'My Insurance', iconKey: 'shield'),
      );

  Future<void> pumpAppAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await seedCompletedProfile(db);
    late final ProviderContainer container;
    await tester.pumpWidget(
      wrapApp(
        Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(
              routerConfig: ref.watch(appRouterProvider),
              theme: buildKoshaTheme(Brightness.light, useGoogleFonts: false),
              builder: (context, child) =>
                  ToastHost(child: child ?? const SizedBox.shrink()),
            );
          },
        ),
        db: db,
      ),
    );
    await tester.pumpAndSettle();

    container.read(appRouterProvider).go(location);
    await tester.pumpAndSettle();
  }

  testWidgets('/records/<id> opens that record type, not the grid',
      (tester) async {
    final template = await insurance();

    await pumpAppAt(tester, Routes.customRecords(template.id));

    expect(find.byType(CustomRecordsScreen), findsOneWidget);
    expect(find.text('My Insurance'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('/records/<id>/fields opens the builder for that type',
      (tester) async {
    final template = await insurance();

    await pumpAppAt(tester, Routes.recordTemplateFields(template.id));

    expect(find.byType(RecordTemplateBuilderScreen), findsOneWidget);
    expect(find.text('Edit fields'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('/records/new opens an empty builder, not a record type',
      (tester) async {
    await pumpAppAt(tester, Routes.newRecordTemplate);

    expect(find.byType(RecordTemplateBuilderScreen), findsOneWidget);
    expect(
      find.text('New record type'),
      findsOneWidget,
      reason: '"new" must win over ":id", which matches any segment',
    );
    await settleAndDispose(tester);
  });

  testWidgets("a reminder's route lands on the record's own type",
      (tester) async {
    final template = await insurance();

    // The literal path `record_reminder.dart` builds, spelled the way it
    // spells it rather than through Routes, so a change to either is caught.
    await pumpAppAt(tester, '/records/${template.id}');

    expect(find.byType(CustomRecordsScreen), findsOneWidget);
    await settleAndDispose(tester);
  });
}
