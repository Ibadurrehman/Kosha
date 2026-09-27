import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/spaces/data/record_repository_impl.dart';
import 'package:kosha/features/spaces/domain/entities/custom_record.dart';
import 'package:kosha/features/spaces/domain/entities/record_template.dart';
import 'package:kosha/features/spaces/presentation/custom_records_screen.dart';
import 'package:kosha/features/spaces/presentation/record_template_builder_screen.dart';

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

  Future<void> pumpBuilder(WidgetTester tester, {String? templateId}) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapPushedScreen(
        RecordTemplateBuilderScreen(templateId: templateId),
        db: db,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('custom records screen', () {
    testWidgets('is titled with the record type and says what it holds',
        (tester) async {
      final template = await insurance();
      await pumpRecords(tester, template.id);

      expect(find.text('My Insurance'), findsOneWidget);
      expect(find.text('No records yet'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a record card shows only the fields that were filled in',
        (tester) async {
      final template = await insurance();
      await repository.createRecord(
        NewCustomRecord(
          templateId: template.id,
          title: 'Star Health SH-2291840',
          values: const {'f1': 'Star Health', 'f3': '18400'},
        ),
      );
      await pumpRecords(tester, template.id);

      expect(find.text('Star Health SH-2291840'), findsOneWidget);
      expect(find.text('Star Health'), findsOneWidget);
      expect(
        find.text('₹18,400'),
        findsOneWidget,
        reason: 'a currency field formats what was typed as a plain number',
      );
      expect(
        find.text('Provider'),
        findsNWidgets(2),
        reason: 'once as the filled row, once as a chip in the Fields card',
      );
      expect(
        find.text('Policy number'),
        findsNothing,
        reason: 'it was left empty, so the card does not ask about it — the '
            'Fields card lists it as "Policy number *" instead',
      );
      await settleAndDispose(tester);
    });

    testWidgets('a renewing record derives its pill from the date',
        (tester) async {
      final template = await insurance();
      await repository.createRecord(
        NewCustomRecord(
          templateId: template.id,
          title: 'Star Health',
          // testNow is 4 Sep 2026; 14 Sep is inside the 30-day lead.
          renewalDate: DateTime(2026, 9, 14),
        ),
      );
      await pumpRecords(tester, template.id);

      expect(find.text('Renews in 10 days'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a record with no renewal shows its own status label',
        (tester) async {
      final template = await insurance();
      await repository.createRecord(
        NewCustomRecord(
          templateId: template.id,
          title: 'Old policy',
          statusLabel: 'Lapsed',
        ),
      );
      await pumpRecords(tester, template.id);

      expect(find.text('Lapsed'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('the Fields card lists every field, required ones starred',
        (tester) async {
      final template = await insurance();
      await pumpRecords(tester, template.id);

      expect(find.text('Fields in this record'), findsOneWidget);
      expect(find.text('Provider'), findsOneWidget);
      expect(find.text('Policy number *'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a deleted record type says so rather than throwing',
        (tester) async {
      final template = await insurance();
      await repository.deleteTemplate(template.id);
      await pumpRecords(tester, template.id);

      expect(find.text('This record type is gone'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });

  group('template builder', () {
    testWidgets('creating one needs a name before Save is offered',
        (tester) async {
      await pumpBuilder(tester);

      final save = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Save'),
      );
      expect(save.onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'My Insurance'),
        'My Insurance',
      );
      await tester.pump();

      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Save'))
            .onPressed,
        isNotNull,
      );
      await settleAndDispose(tester);
    });

    testWidgets('editing shows the existing fields and their types',
        (tester) async {
      final template = await insurance();
      await pumpBuilder(tester, templateId: template.id);

      expect(find.text('Edit fields'), findsOneWidget);
      // The label hint renders in every row, so rows are counted by the one
      // control that carries their own label: the remove button's tooltip.
      expect(find.byTooltip('Remove Provider'), findsOneWidget);
      expect(find.byTooltip('Remove Policy number'), findsOneWidget);
      expect(find.byTooltip('Remove Premium'), findsOneWidget);
      // Six type chips per row, three rows.
      expect(find.text('Amount'), findsNWidgets(3));
      await settleAndDispose(tester);
    });

    testWidgets('adding a field appends an empty row to fill in',
        (tester) async {
      final template = await insurance(fields: const [provider]);
      await pumpBuilder(tester, templateId: template.id);

      expect(find.text('Required'), findsOneWidget);

      await tester.tap(find.byTooltip('Add field'));
      await tester.pumpAndSettle();

      expect(
        find.text('Required'),
        findsNWidgets(2),
        reason: 'one row per field, and the new one is empty and unlabelled',
      );
      await settleAndDispose(tester);
    });

    testWidgets('removing a field takes its row away without saving',
        (tester) async {
      final template = await insurance(fields: const [provider, policyNumber]);
      await pumpBuilder(tester, templateId: template.id);

      await tester.tap(find.byTooltip('Remove Policy number'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Remove Policy number'), findsNothing);
      expect(find.text('Required'), findsOneWidget);
      expect(
        (await repository.findTemplateById(template.id))!.fields,
        hasLength(2),
        reason: 'nothing is written until Save',
      );
      await settleAndDispose(tester);
    });

    testWidgets('saving a renamed field keeps the records values',
        (tester) async {
      final template = await insurance(fields: const [provider]);
      final record = await repository.createRecord(
        NewCustomRecord(
          templateId: template.id,
          title: 'Star Health',
          values: const {'f1': 'Star Health'},
        ),
      );
      await pumpBuilder(tester, templateId: template.id);

      // The only field row, so its label box is the one TextField holding
      // "Provider" — the hint collision needs two rows to bite.
      await tester.enterText(
        find.widgetWithText(TextField, 'Provider'),
        'Insurer',
      );
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(
        (await repository.findTemplateById(template.id))!.fields.single.label,
        'Insurer',
      );
      expect(
        (await repository.findRecordById(record.id))!.value('f1'),
        'Star Health',
      );
      await settleAndDispose(tester);
    });

    testWidgets('a field left unlabelled is dropped rather than saved empty',
        (tester) async {
      final template = await insurance(fields: const [provider]);
      await pumpBuilder(tester, templateId: template.id);

      await tester.tap(find.byTooltip('Add field'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(
        (await repository.findTemplateById(template.id))!.fields,
        hasLength(1),
      );
      await settleAndDispose(tester);
    });
  });
}
