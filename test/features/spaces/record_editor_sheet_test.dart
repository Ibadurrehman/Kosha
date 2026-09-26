import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/spaces/data/record_repository_impl.dart';
import 'package:kosha/features/spaces/domain/entities/custom_record.dart';
import 'package:kosha/features/spaces/domain/entities/record_template.dart';
import 'package:kosha/features/spaces/presentation/custom_records_screen.dart';
import 'package:kosha/features/spaces/presentation/spaces_screen.dart';
import 'package:kosha/features/spaces/presentation/widgets/record_editor_sheet.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftRecordRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRecordRepository(db);
  });

  tearDown(() => db.close());

  const provider = RecordField(
    key: 'f1',
    label: 'Provider',
    type: RecordFieldType.text,
  );
  const policyNumber = RecordField(
    key: 'f2',
    label: 'Policy number',
    type: RecordFieldType.text,
    isRequired: true,
  );
  const premium = RecordField(
    key: 'f3',
    label: 'Premium',
    type: RecordFieldType.currency,
  );

  Future<RecordTemplate> insurance({
    List<RecordField> fields = const [provider, policyNumber, premium],
  }) =>
      repository.createTemplate(
        NewRecordTemplate(
          name: 'My Insurance',
          iconKey: 'shield',
          fields: fields,
        ),
      );

  Future<void> pumpRecords(WidgetTester tester, String templateId) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapPushedScreen(CustomRecordsScreen(templateId: templateId), db: db),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openEditor(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Add record'));
    await tester.pumpAndSettle();
  }

  /// Scoped to the sheet: the empty state behind it offers its own "Add
  /// record" button, so an unscoped finder matches both.
  Finder saveButton() => find.descendant(
        of: find.byType(RecordEditorSheet),
        matching: find.widgetWithText(FilledButton, 'Add record'),
      );

  group('record editor', () {
    // The sheet lowercased the template's name into its own title, so a type
    // the user called "My Insurance" opened as "New my insurance record".
    // Found by the Phase 3 device pass (plan §12.5.5).
    testWidgets('titles itself with the type name the user chose',
        (tester) async {
      final template = await insurance();

      await pumpRecords(tester, template.id);
      await openEditor(tester);

      expect(find.text('New My Insurance record'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('renders one input per template field, in order',
        (tester) async {
      final template = await insurance();
      await pumpRecords(tester, template.id);
      await openEditor(tester);

      expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
      expect(find.text('Provider'), findsWidgets);
      expect(
        find.text('Policy number *'),
        findsWidgets,
        reason: 'a required field is starred in the editor too',
      );
      expect(find.text('Premium'), findsWidgets);
      await settleAndDispose(tester);
    });

    testWidgets('Save waits for the title and every required field',
        (tester) async {
      final template = await insurance();
      await pumpRecords(tester, template.id);
      await openEditor(tester);

      FilledButton save() => tester.widget<FilledButton>(saveButton());

      expect(save().onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        'Star Health SH-2291840',
      );
      await tester.pump();
      expect(
        save().onPressed,
        isNull,
        reason: 'the required Policy number is still empty',
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Policy number *'),
        'SH-2291840',
      );
      await tester.pump();
      expect(save().onPressed, isNotNull);
      await settleAndDispose(tester);
    });

    testWidgets('saving writes the record with its values', (tester) async {
      final template = await insurance(fields: const [provider]);
      await pumpRecords(tester, template.id);
      await openEditor(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        'Star Health SH-2291840',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Provider'),
        'Star Health',
      );
      await tester.pump();
      await tester.tap(saveButton());
      await tester.pumpAndSettle();

      // Read back through runAsync: drift emits a stream's first value on a
      // zero-duration timer, and inside the widget tester's fake-async zone
      // that timer only fires on a pump — so awaiting `.first` directly here
      // waits for a clock that is not running (§12.5.2).
      late List<CustomRecord> records;
      await tester.runAsync(() async {
        records = await repository.watchRecords(template.id).first;
      });
      expect(records, hasLength(1));
      expect(records.single.title, 'Star Health SH-2291840');
      expect(records.single.value('f1'), 'Star Health');
      await settleAndDispose(tester);
    });

    testWidgets('a template with no fields still takes a titled record',
        (tester) async {
      final template = await insurance(fields: const []);
      await pumpRecords(tester, template.id);
      await openEditor(tester);

      expect(find.textContaining('has no fields yet'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Title'),
        'Just a title',
      );
      await tester.pump();
      await tester.tap(saveButton());
      await tester.pumpAndSettle();

      late List<CustomRecord> records;
      await tester.runAsync(() async {
        records = await repository.watchRecords(template.id).first;
      });
      expect(records, hasLength(1));
      await settleAndDispose(tester);
    });

    testWidgets('the status field is offered only while nothing renews',
        (tester) async {
      final template = await insurance(fields: const []);
      await pumpRecords(tester, template.id);
      await openEditor(tester);

      expect(
        find.widgetWithText(TextField, 'Status (optional)'),
        findsOneWidget,
        reason: 'a record that does not renew is where a typed status earns '
            'its place',
      );
      await settleAndDispose(tester);
    });
  });

  group('spaces grid card', () {
    Future<void> pumpSpaces(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(wrapPushedScreen(const SpacesScreen(), db: db));
      await tester.pumpAndSettle();
    }

    testWidgets('offers to create one when there are no record types',
        (tester) async {
      await pumpSpaces(tester);
      await tester.scrollUntilVisible(
        find.text('Create a custom record'),
        300,
      );

      expect(find.text('Custom records'), findsOneWidget);
      expect(find.text('Create a custom record'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('lists each record type with its live count', (tester) async {
      final template = await insurance();
      await repository.createRecord(
        NewCustomRecord(templateId: template.id, title: 'Star Health'),
      );
      await pumpSpaces(tester);
      await tester.scrollUntilVisible(find.text('My Insurance'), 300);

      expect(find.text('My Insurance'), findsOneWidget);
      expect(find.text('1 record'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a type with no records yet says so rather than showing 0',
        (tester) async {
      await insurance();
      await pumpSpaces(tester);
      await tester.scrollUntilVisible(find.text('My Insurance'), 300);

      expect(find.text('None yet'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });
}
