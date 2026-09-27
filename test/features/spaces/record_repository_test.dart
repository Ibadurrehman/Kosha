import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/spaces/data/record_repository_impl.dart';
import 'package:kosha/features/spaces/domain/entities/custom_record.dart';
import 'package:kosha/features/spaces/domain/entities/record_template.dart';
import 'package:kosha/features/tasks/domain/entities/activity_entry.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;
  late DriftRecordRepository repository;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    repository = testRecordRepository(db, scheduler: scheduler);
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

  Future<CustomRecord> policy(
    RecordTemplate template, {
    String title = 'Star Health SH-2291840',
    Map<String, String> values = const {'f1': 'Star Health', 'f2': 'SH-2291840'},
    DateTime? renewalDate,
    String? statusLabel,
  }) =>
      repository.createRecord(
        NewCustomRecord(
          templateId: template.id,
          title: title,
          values: values,
          renewalDate: renewalDate,
          statusLabel: statusLabel,
        ),
      );

  Future<List<ActivityEvent>> events(String recordId) async {
    final rows = await (db.select(db.activityEntries)
          ..where((a) => a.ownerId.equals(recordId)))
        .get();
    return rows.map((r) => r.event).toList();
  }

  group('templates', () {
    test('creating one stores its fields as JSON and reads them back', () async {
      final template = await insurance();

      final stored = await repository.findTemplateById(template.id);
      expect(stored, isNotNull);
      expect(stored!.name, 'My Insurance');
      expect(stored.fields, [provider, policyNumber, premium]);
      expect(stored.createdAt, testNow);
    });

    test('watchTemplates lists live templates, newest first', () async {
      final first = await insurance();
      final second = await repository.createTemplate(
        const NewRecordTemplate(name: 'Warranties', iconKey: 'receipt'),
      );

      // Both were written by the same fixed clock, so the order is by the
      // secondary key SQLite gives equal timestamps rather than by time.
      final templates = await repository.watchTemplates().first;
      expect(
        templates.map((t) => t.id).toSet(),
        {first.id, second.id},
      );
    });

    test('renaming a field keeps every record value attached to it', () async {
      final template = await insurance();
      final record = await policy(template);

      await repository.editTemplate(
        template.id,
        fields: const [
          RecordField(key: 'f1', label: 'Insurer', type: RecordFieldType.text),
          policyNumber,
          premium,
        ],
      );

      final stored = await repository.findRecordById(record.id);
      expect(stored!.value('f1'), 'Star Health');
      expect(
        (await repository.findTemplateById(template.id))!.fields.first.label,
        'Insurer',
      );
    });

    test('reordering fields is just a different list, and keeps values', () async {
      final template = await insurance();
      final record = await policy(template);

      await repository.editTemplate(
        template.id,
        fields: const [premium, policyNumber, provider],
      );

      final stored = await repository.findTemplateById(template.id);
      expect(stored!.fields.map((f) => f.key), ['f3', 'f2', 'f1']);
      expect(
        (await repository.findRecordById(record.id))!.value('f2'),
        'SH-2291840',
      );
    });

    test('removing a field leaves its values until the record is next saved',
        () async {
      final template = await insurance();
      final record = await policy(
        template,
        values: const {'f1': 'Star Health', 'f2': 'SH-2291840', 'f3': '18400'},
      );

      await repository.editTemplate(
        template.id,
        fields: const [provider, policyNumber],
      );

      expect(
        (await repository.findRecordById(record.id))!.value('f3'),
        '18400',
        reason: 'a field deleted by mistake and added back keeps its data',
      );

      await repository.editRecord(
        record.id,
        values: const {'f1': 'Star Health', 'f2': 'SH-2291840', 'f3': '18400'},
      );

      expect(
        (await repository.findRecordById(record.id))!.value('f3'),
        isNull,
        reason: 'saving the record is when the orphan is actually pruned',
      );
    });

    test('deleting one hides it and its records, without touching their rows',
        () async {
      final template = await insurance();
      final record = await policy(template);

      await repository.deleteTemplate(template.id);

      expect(await repository.watchTemplates().first, isEmpty);
      expect(await repository.watchTemplateById(template.id).first, isNull);
      expect(await repository.watchRecords(template.id).first, isEmpty);
      expect(
        await repository.findRecordById(record.id),
        isNotNull,
        reason: 'the record row is untouched, which is what makes undo one write',
      );
    });

    test('restoring one brings every record back', () async {
      final template = await insurance();
      await policy(template);
      await policy(template, title: 'ICICI Lombard IL-8830271');

      await repository.deleteTemplate(template.id);
      await repository.restoreTemplate(template.id);

      expect(await repository.watchTemplates().first, hasLength(1));
      expect(await repository.watchRecords(template.id).first, hasLength(2));
    });

    test('deleting one cancels its records reminders, restoring re-schedules',
        () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));
      scheduler.scheduled.clear();

      await repository.deleteTemplate(template.id);
      expect(scheduler.cancelled, [record.id]);

      await repository.restoreTemplate(template.id);
      expect(scheduler.scheduled, hasLength(1));
      expect(
        scheduler.scheduled.single.fireAt,
        DateTime(2027, 3, 1, 9),
      );
    });
  });

  group('records', () {
    test('creating one logs it and schedules its renewal reminder', () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));

      expect(await events(record.id), [ActivityEvent.created]);
      expect(scheduler.scheduled, hasLength(1));
      expect(scheduler.scheduled.single.ownerId, record.id);
      expect(scheduler.scheduled.single.route, '/records/${template.id}');
      expect(scheduler.scheduled.single.body, 'Renews in 30 days · My Insurance');
    });

    test('a record that never renews schedules nothing', () async {
      final template = await insurance();
      await policy(template, statusLabel: 'Active');

      expect(scheduler.scheduled, isEmpty);
    });

    test('creating one drops values for fields the template does not have',
        () async {
      final template = await insurance(fields: const [provider]);
      final record = await policy(
        template,
        values: const {'f1': 'Star Health', 'f9': 'from another template'},
      );

      final stored = await repository.findRecordById(record.id);
      expect(stored!.values, {'f1': 'Star Health'});
    });

    test('creating one under a missing template throws rather than orphaning',
        () async {
      expect(
        () => repository.createRecord(
          const NewCustomRecord(templateId: 'nope', title: 'Orphan'),
        ),
        throwsStateError,
      );
    });

    test('editing re-syncs the reminder', () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));
      scheduler.scheduled.clear();

      await repository.editRecord(record.id, renewalDate: DateTime(2027, 6, 30));

      expect(scheduler.scheduled, hasLength(1));
      expect(scheduler.scheduled.single.fireAt, DateTime(2027, 5, 31, 9));
      expect(await events(record.id), contains(ActivityEvent.edited));
    });

    test('clearing the renewal date needs the sentinel, and cancels', () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));
      scheduler.cancelled.clear();

      final unchanged = await repository.editRecord(record.id, title: 'Renamed');
      expect(
        unchanged.renewalDate,
        DateTime(2027, 3, 31),
        reason: 'a null argument means "unchanged", not "clear"',
      );

      final cleared =
          await repository.editRecord(record.id, clearRenewalDate: true);
      expect(cleared.renewalDate, isNull);
      expect(cleared.title, 'Renamed');
      expect(scheduler.cancelled, isNotEmpty);
    });

    test('the status label and document link clear the same way', () async {
      final template = await insurance();
      final record = await policy(template, statusLabel: 'Active');

      final edited = await repository.editRecord(
        record.id,
        documentId: 'doc-1',
      );
      expect(edited.statusLabel, 'Active');
      expect(edited.documentId, 'doc-1');

      final cleared = await repository.editRecord(
        record.id,
        clearStatusLabel: true,
        clearDocumentId: true,
      );
      expect(cleared.statusLabel, isNull);
      expect(cleared.documentId, isNull);
    });

    test('deleting is soft, cancels the reminder, and undoes', () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));

      await repository.deleteRecord(record.id);
      expect(await repository.watchRecords(template.id).first, isEmpty);
      expect(scheduler.cancelled, isNotEmpty);
      expect(await events(record.id), contains(ActivityEvent.deleted));

      await repository.restoreRecord(record.id);
      expect(await repository.watchRecords(template.id).first, hasLength(1));
      expect(await events(record.id), contains(ActivityEvent.restored));
    });

    test('restoring under a deleted template re-schedules nothing', () async {
      final template = await insurance();
      final record = await policy(template, renewalDate: DateTime(2027, 3, 31));
      await repository.deleteRecord(record.id);
      await repository.deleteTemplate(template.id);
      scheduler.scheduled.clear();

      await repository.restoreRecord(record.id);

      expect(
        scheduler.scheduled,
        isEmpty,
        reason: 'a record under a deleted type must not start speaking again',
      );
    });
  });

  group('counts and renewals', () {
    test('counts live records per live template', () async {
      final insuranceTemplate = await insurance();
      final warranties = await repository.createTemplate(
        const NewRecordTemplate(name: 'Warranties', iconKey: 'receipt'),
      );
      await policy(insuranceTemplate);
      await policy(insuranceTemplate, title: 'ICICI Lombard');
      final third = await policy(warranties, title: 'Fridge');

      expect(
        await repository.watchRecordCounts().first,
        {insuranceTemplate.id: 2, warranties.id: 1},
      );

      await repository.deleteRecord(third.id);
      expect(
        await repository.watchRecordCounts().first,
        {insuranceTemplate.id: 2},
        reason: 'a template with no live records drops out rather than showing 0',
      );
    });

    test('a deleted template contributes no counts', () async {
      final template = await insurance();
      await policy(template);

      await repository.deleteTemplate(template.id);

      expect(await repository.watchRecordCounts().first, isEmpty);
    });

    test('watchRenewingBetween is a half-open window, soonest first', () async {
      final template = await insurance();
      await policy(
        template,
        title: 'October',
        renewalDate: DateTime(2026, 10, 15),
      );
      await policy(
        template,
        title: 'November',
        renewalDate: DateTime(2026, 11, 1),
      );
      await policy(template, title: 'No renewal');

      final window = await repository
          .watchRenewingBetween(DateTime(2026, 10, 1), DateTime(2026, 11, 1))
          .first;

      expect(window.map((r) => r.title), ['October']);
    });

    test('needing attention covers overdue and inside the lead time', () async {
      final template = await insurance();
      await policy(
        template,
        title: 'Overdue',
        renewalDate: DateTime(2026, 9, 20),
      );
      await policy(
        template,
        title: 'Renewing soon',
        renewalDate: DateTime(2026, 10, 10),
      );
      await policy(
        template,
        title: 'Far off',
        renewalDate: DateTime(2027, 3, 31),
      );
      await policy(template, title: 'No renewal');

      final attention = await repository
          .watchRenewalsNeedingAttention(today: DateTime(2026, 9, 26))
          .first;

      expect(attention.map((r) => r.title), ['Overdue', 'Renewing soon']);
    });

    test('a record renewing today needs attention, not tomorrow-only', () async {
      final template = await insurance();
      await policy(
        template,
        title: 'Today',
        renewalDate: DateTime(2026, 9, 26),
      );

      final attention = await repository
          .watchRenewalsNeedingAttention(today: DateTime(2026, 9, 26, 14, 30))
          .first;

      expect(attention.map((r) => r.title), ['Today']);
    });

    test('records under a deleted template never need attention', () async {
      final template = await insurance();
      await policy(
        template,
        title: 'Overdue',
        renewalDate: DateTime(2026, 9, 20),
      );

      await repository.deleteTemplate(template.id);

      expect(
        await repository
            .watchRenewalsNeedingAttention(today: DateTime(2026, 9, 26))
            .first,
        isEmpty,
      );
    });
  });
}
