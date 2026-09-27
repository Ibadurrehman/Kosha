import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/spaces/domain/entities/custom_record.dart';
import 'package:kosha/features/spaces/domain/entities/record_template.dart';
import 'package:kosha/features/spaces/domain/record_reminder.dart';

import '../../helpers/test_app.dart';

void main() {
  CustomRecord record({DateTime? renewalDate, String? statusLabel}) =>
      CustomRecord(
        id: 'r1',
        templateId: 't1',
        title: 'Star Health SH-2291840',
        renewalDate: renewalDate,
        statusLabel: statusLabel,
        createdAt: testNow,
        updatedAt: testNow,
      );

  final today = DateTime(2026, 9, 26);

  group('recordRenewalStatus', () {
    test('a record with no renewal date is noRenewal, not valid', () {
      expect(
        recordRenewalStatus(record(), today),
        RecordRenewalStatus.noRenewal,
      );
    });

    test('renewing beyond the lead time is valid', () {
      expect(
        recordRenewalStatus(
          record(renewalDate: DateTime(2027, 3, 31)),
          today,
        ),
        RecordRenewalStatus.valid,
      );
    });

    test('renewing inside the lead time is renewingSoon', () {
      expect(
        recordRenewalStatus(
          record(renewalDate: DateTime(2026, 10, 20)),
          today,
        ),
        RecordRenewalStatus.renewingSoon,
      );
    });

    test('the last day of the window is still renewingSoon, not valid', () {
      expect(
        recordRenewalStatus(
          record(renewalDate: DateTime(2026, 10, 26)),
          today,
        ),
        RecordRenewalStatus.renewingSoon,
      );
    });

    test('a day past the window is valid', () {
      expect(
        recordRenewalStatus(
          record(renewalDate: DateTime(2026, 10, 27)),
          today,
        ),
        RecordRenewalStatus.valid,
      );
    });

    test('the renewal day itself is not overdue', () {
      expect(
        recordRenewalStatus(record(renewalDate: today), today),
        RecordRenewalStatus.renewingSoon,
      );
    });

    test('the day after the renewal is overdue', () {
      expect(
        recordRenewalStatus(
          record(renewalDate: DateTime(2026, 9, 25)),
          today,
        ),
        RecordRenewalStatus.overdue,
      );
    });

    test('a renewal earlier the same day is not overdue', () {
      // Renewal dates are stored at local midnight, but a clock reading
      // 14:30 must not make today's renewal look like yesterday's problem.
      expect(
        recordRenewalStatus(record(renewalDate: today), DateTime(2026, 9, 26, 14, 30)),
        RecordRenewalStatus.renewingSoon,
      );
    });
  });

  group('recordNeedsAttention', () {
    test('covers overdue and renewingSoon only', () {
      expect(recordNeedsAttention(RecordRenewalStatus.overdue), isTrue);
      expect(recordNeedsAttention(RecordRenewalStatus.renewingSoon), isTrue);
      expect(recordNeedsAttention(RecordRenewalStatus.valid), isFalse);
      expect(recordNeedsAttention(RecordRenewalStatus.noRenewal), isFalse);
    });
  });

  group('daysUntilRenewal', () {
    test('is null when the record never renews', () {
      expect(daysUntilRenewal(record(), today), isNull);
    });

    test('counts whole days forward', () {
      expect(
        daysUntilRenewal(record(renewalDate: DateTime(2026, 10, 6)), today),
        10,
      );
    });

    test('goes negative once the renewal has passed', () {
      expect(
        daysUntilRenewal(record(renewalDate: DateTime(2026, 9, 20)), today),
        -6,
      );
    });

    test('ignores the time of day on both sides', () {
      expect(
        daysUntilRenewal(
          record(renewalDate: DateTime(2026, 10, 6)),
          DateTime(2026, 9, 26, 23, 59),
        ),
        10,
      );
    });
  });

  group('reminders', () {
    test('fire at 9 am, a lead time before the renewal', () {
      final reminder = reminderForRecord(
        record(renewalDate: DateTime(2027, 3, 31)),
        now: today,
        templateName: 'My Insurance',
      );

      expect(reminder, isNotNull);
      expect(reminder!.fireAt, DateTime(2027, 3, 1, recordReminderHour));
      expect(reminder.title, 'Star Health SH-2291840');
      expect(reminder.body, 'Renews in 30 days · My Insurance');
      expect(reminder.route, '/records/t1');
    });

    test('are null for a record that never renews', () {
      expect(
        reminderForRecord(record(), now: today, templateName: 'My Insurance'),
        isNull,
      );
    });

    test('are null once the moment has passed, though the intent survives', () {
      final soon = record(renewalDate: DateTime(2026, 10, 1));

      expect(
        reminderForRecord(soon, now: today, templateName: 'My Insurance'),
        isNull,
        reason: 'the fire moment was 1 Sep, three weeks before today',
      );
      expect(
        intendedRecordFireAt(soon),
        DateTime(2026, 9, 1, recordReminderHour),
        reason: 'the inbox reconciliation still needs the past moment',
      );
    });

    test('are null for a deleted record', () {
      final deleted = record(renewalDate: DateTime(2027, 3, 31))
          .copyWith(deletedAt: today);

      expect(
        reminderForRecord(deleted, now: today, templateName: 'My Insurance'),
        isNull,
      );
      expect(intendedRecordFireAt(deleted), isNull);
    });
  });

  group('field codec', () {
    const fields = [
      RecordField(key: 'f1', label: 'Provider', type: RecordFieldType.text),
      RecordField(
        key: 'f2',
        label: 'Policy number',
        type: RecordFieldType.text,
        isRequired: true,
      ),
      RecordField(key: 'f3', label: 'Premium', type: RecordFieldType.currency),
      RecordField(key: 'f4', label: 'Renewal', type: RecordFieldType.date),
    ];

    test('round-trips through JSON', () {
      expect(decodeRecordFields(encodeRecordFields(fields)), fields);
    });

    test('writes the shape section 5.1 specifies', () {
      expect(
        encodeRecordFields([fields.first]),
        '[{"key":"f1","label":"Provider","type":"text","required":false}]',
      );
    });

    test('stores the type by name, so reordering the enum cannot shift it', () {
      expect(
        encodeRecordFields([fields[2]]),
        contains('"type":"currency"'),
      );
    });

    test('decodes an unknown type as text rather than dropping the field', () {
      final decoded = decodeRecordFields(
        '[{"key":"f9","label":"Signature","type":"handwriting"}]',
      );

      expect(decoded, hasLength(1));
      expect(decoded.single.label, 'Signature');
      expect(decoded.single.type, RecordFieldType.text);
    });

    test('skips entries with no usable key or label', () {
      expect(
        decodeRecordFields('[{"label":"No key"},{"key":"","label":"Empty"},1]'),
        isEmpty,
      );
    });

    test('yields no fields for malformed JSON instead of throwing', () {
      expect(decodeRecordFields('not json'), isEmpty);
      expect(decodeRecordFields('{"not":"a list"}'), isEmpty);
    });
  });

  group('value codec', () {
    test('round-trips through JSON', () {
      const values = {'f1': 'Star Health', 'f2': 'SH-2291840'};
      expect(decodeRecordValues(encodeRecordValues(values)), values);
    });

    test('coerces a stored number rather than dropping it', () {
      expect(
        decodeRecordValues('{"f3":18400,"f4":true}'),
        {'f3': '18400', 'f4': 'true'},
      );
    });

    test('skips values no field type could render', () {
      expect(decodeRecordValues('{"f1":["a","b"],"f2":"kept"}'), {'f2': 'kept'});
    });

    test('yields nothing for malformed JSON instead of throwing', () {
      expect(decodeRecordValues('['), isEmpty);
    });
  });

  group('pruneValues', () {
    test('drops values whose field is gone', () {
      expect(
        pruneValues({'f1': 'Star Health', 'f9': 'orphan'}, ['f1', 'f2']),
        {'f1': 'Star Health'},
      );
    });

    test('keeps every value when nothing was removed', () {
      const values = {'f1': 'a', 'f2': 'b'};
      expect(pruneValues(values, ['f1', 'f2', 'f3']), values);
    });
  });

  group('RecordTemplate', () {
    final template = RecordTemplate(
      id: 't1',
      name: 'My Insurance',
      iconKey: 'shield',
      fields: const [
        RecordField(key: 'f1', label: 'Provider', type: RecordFieldType.text),
        RecordField(
          key: 'f2',
          label: 'Policy number',
          type: RecordFieldType.text,
          isRequired: true,
        ),
      ],
      createdAt: testNow,
      updatedAt: testNow,
    );

    test('reports only the fields that block Save', () {
      expect(
        template.requiredFields.map((f) => f.key),
        ['f2'],
      );
    });

    test('finds a field by key, and null for one that is gone', () {
      expect(template.fieldByKey('f1')?.label, 'Provider');
      expect(template.fieldByKey('f9'), isNull);
    });
  });

  group('CustomRecord.value', () {
    test('reads a stored value by field key', () {
      expect(
        record().copyWith(values: {'f1': 'Star Health'}).value('f1'),
        'Star Health',
      );
    });

    test('is null for a field saved before it existed', () {
      expect(record().value('f9'), isNull);
    });

    test('treats an empty string as nothing entered', () {
      expect(record().copyWith(values: {'f1': ''}).value('f1'), isNull);
    });
  });
}
