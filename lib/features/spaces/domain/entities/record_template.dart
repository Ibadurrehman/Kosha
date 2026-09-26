import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_template.freezed.dart';

/// What one field of a template holds. Decides the keyboard, the formatter and
/// the picker the record editor shows for it — section 6.5 names exactly these
/// six: text, number, currency, date, phone, document link.
///
/// Stored inside the template's `fields` JSON **by name**, never by index. The
/// enum-by-index rule that governs `ReminderKind` and `TaskSource` is about
/// columns; a JSON object is read by name anyway, and a name survives both a
/// reorder of this declaration and a field being reordered in a template.
enum RecordFieldType {
  text('Text'),
  number('Number'),
  currency('Amount'),
  date('Date'),
  phone('Phone'),
  documentLink('Document');

  const RecordFieldType(this.label);

  final String label;
}

/// One field in a template: "Policy number", a text box, required.
///
/// [key] is the identity and [label] is only what the user reads. Renaming
/// "Provider" to "Insurer" therefore keeps every record's value, because
/// [CustomRecord.values] is keyed by [key] — a rename that silently emptied
/// three records would be the worst kind of data loss, the kind that looks
/// like a successful edit.
@freezed
abstract class RecordField with _$RecordField {
  const factory RecordField({
    required String key,
    required String label,
    required RecordFieldType type,

    /// Blocks Save in the record editor while it is empty. Named `isRequired`
    /// rather than `required` only because the latter reads badly next to
    /// Dart's own keyword; the JSON spelling stays `required` (§5.1).
    @Default(false) bool isRequired,
  }) = _RecordField;

  const RecordField._();
}

/// A user-defined record type: "My Insurance" with Provider / Policy number /
/// Premium / Renewal date / Document / Contact (Appendix B).
///
/// Soft-deleted rather than archived — unlike `Document` and `Space`, section
/// 6.5 gives this no Archive list to live in, so `deletedAt` is the ordinary
/// removal every other Phase 3 table uses, with undo from the toast.
@freezed
abstract class RecordTemplate with _$RecordTemplate {
  const factory RecordTemplate({
    required String id,
    required String name,
    required String iconKey,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<RecordField>[]) List<RecordField> fields,

    /// The space this record type belongs to, or null for one that stands on
    /// its own in the Spaces grid. Nullable and unused by v1's screens: it is
    /// the hook G29 needs to back a "Health" space's Records section without a
    /// second migration, and it costs one column to leave open.
    String? spaceId,
    DateTime? deletedAt,
  }) = _RecordTemplate;

  const RecordTemplate._();

  bool get isDeleted => deletedAt != null;

  /// The fields a record editor must fill before Save can be enabled.
  List<RecordField> get requiredFields =>
      fields.where((field) => field.isRequired).toList();

  RecordField? fieldByKey(String key) {
    for (final field in fields) {
      if (field.key == key) return field;
    }
    return null;
  }
}

/// Fields a caller supplies to create a template; the repository fills in the
/// id and timestamps.
class NewRecordTemplate {
  const NewRecordTemplate({
    required this.name,
    required this.iconKey,
    this.fields = const <RecordField>[],
    this.spaceId,
  });

  final String name;
  final String iconKey;
  final List<RecordField> fields;
  final String? spaceId;
}

/// The template's `fields` column: a JSON array of `{key,label,type,required}`
/// exactly as section 5.1 specifies it.
String encodeRecordFields(List<RecordField> fields) => jsonEncode([
      for (final field in fields)
        <String, Object?>{
          'key': field.key,
          'label': field.label,
          'type': field.type.name,
          'required': field.isRequired,
        },
    ]);

/// Reads a `fields` column back, tolerating anything it does not recognise.
///
/// A field whose `type` is not a name this build knows decodes as
/// [RecordFieldType.text] rather than being dropped: the value stored under
/// that key is still real, and showing it as text is the one reading that
/// cannot lose it. Malformed JSON — which nothing in the app writes, but a
/// hand-edited database or a half-finished restore could — yields no fields
/// rather than throwing on a screen that only wanted to draw a list.
List<RecordField> decodeRecordFields(String source) {
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    return const <RecordField>[];
  }
  if (decoded is! List) return const <RecordField>[];

  final fields = <RecordField>[];
  for (final entry in decoded) {
    if (entry is! Map) continue;
    final key = entry['key'];
    final label = entry['label'];
    if (key is! String || key.isEmpty || label is! String) continue;
    fields.add(
      RecordField(
        key: key,
        label: label,
        type: _fieldTypeByName(entry['type']),
        isRequired: entry['required'] == true,
      ),
    );
  }
  return fields;
}

RecordFieldType _fieldTypeByName(Object? name) {
  for (final type in RecordFieldType.values) {
    if (type.name == name) return type;
  }
  return RecordFieldType.text;
}
