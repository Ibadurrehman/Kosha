import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/onboarding/domain/area.dart';
import 'package:kosha/features/spaces/domain/entities/space.dart';
import 'package:kosha/features/spaces/presentation/spaces_screen.dart';
import 'package:kosha/features/spaces/presentation/widgets/space_tile.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  Future<void> pumpGrid(WidgetTester tester) async {
    await tester.pumpWidget(wrapScreen(const SpacesScreen(), db: db));
    await tester.pumpAndSettle();
  }

  /// The grid is taller than the 800x600 test surface once six spaces are
  /// seeded, so the New space tile and the "Not shown" footer are below the
  /// fold. Scrolling to them is what a user does — inflating the test window
  /// instead would hide exactly the overflow §7.6 asks these screens to
  /// survive.
  Future<void> scrollToBottom(WidgetTester tester) async {
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
  }

  testWidgets('the grid shows the seeded spaces and the New space tile',
      (tester) async {
    await pumpGrid(tester);

    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);
    await scrollToBottom(tester);
    expect(find.text('New space'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a space with nothing in it says so', (tester) async {
    await pumpGrid(tester);

    expect(find.text('Nothing yet'), findsWidgets);
    await settleAndDispose(tester);
  });

  testWidgets('the sub-line counts what points at the space', (tester) async {
    final spaces = testSpaceRepository(db);
    final finance = await spaces.findBySystemKey(SystemSpace.finance);
    await testRepository(db).create(
      NewTask(title: 'Call the bank', spaceId: finance!.id),
    );

    await pumpGrid(tester);

    expect(find.text('1 open task'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('areas skipped at onboarding are offered back, not hidden',
      (tester) async {
    await pumpGrid(tester);
    await scrollToBottom(tester);

    // The default selection leaves Home, Vehicle, Goals and Notes archived.
    expect(find.text('NOT SHOWN'), findsOneWidget);
    expect(find.text('4 hidden'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Show').first);
    await tester.pumpAndSettle();

    expect(find.text('3 hidden'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('with every area picked there is nothing to bring back',
      (tester) async {
    await testProfileRepository(db).setVisibleAreas(OnboardingArea.values.toSet());

    await pumpGrid(tester);
    await scrollToBottom(tester);

    expect(find.text('NOT SHOWN'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('creating a space from the sheet adds a tile', (tester) async {
    await pumpGrid(tester);
    await scrollToBottom(tester);

    await tester.tap(find.text('New space'));
    await tester.pumpAndSettle();

    expect(find.text('What can it hold'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Studio');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(SpaceTile, 'Studio'), findsOneWidget);
    expect(find.text('Created “Studio”'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('Create stays disabled until the space has a name',
      (tester) async {
    await pumpGrid(tester);
    await scrollToBottom(tester);

    await tester.tap(find.text('New space'));
    await tester.pumpAndSettle();

    final create = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Create'),
    );
    expect(create.onPressed, isNull);
    await settleAndDispose(tester);
  });

  testWidgets('archiving asks first and says what it will do', (tester) async {
    final spaces = testSpaceRepository(db);
    final finance = await spaces.findBySystemKey(SystemSpace.finance);
    await testRepository(db).create(
      NewTask(title: 'Call the bank', spaceId: finance!.id),
    );

    await pumpGrid(tester);
    await tester.longPress(find.text('Finance'));
    await tester.pumpAndSettle();

    expect(find.text('Archive “Finance”?'), findsOneWidget);
    expect(
      find.textContaining('the 1 item inside it stop showing a space'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
    await tester.pumpAndSettle();

    // The name is still on screen — in the "Not shown" footer, which is the
    // point of archiving rather than deleting.
    expect(find.widgetWithText(SpaceTile, 'Finance'), findsNothing);
    expect(find.text('Archived “Finance”'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('keeping it leaves the space alone', (tester) async {
    await pumpGrid(tester);
    await tester.longPress(find.text('Finance'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Keep it'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(SpaceTile, 'Finance'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
