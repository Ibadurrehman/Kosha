import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_record.freezed.dart';

/// One completed service (section 6.9's "service history"): a fact about a
/// moment, like [Payment] — nothing edits a row in place once it exists, only
/// inserts or removes one.
///
/// A service's invoice or receipt is an [Attachment] scoped to this row's id,
/// the same `ownerType`/`ownerId` pattern documents use, rather than a column
/// here — see `document_table.dart`'s note on why `Attachments` is not scoped
/// to documents.
@freezed
abstract class ServiceRecord with _$ServiceRecord {
  const factory ServiceRecord({
    required String id,
    required String vehicleId,
    required DateTime date,
    required int odometerKm,
    required String description,
    required int costMinor,
    required DateTime createdAt,
  }) = _ServiceRecord;
}

/// Fields a caller supplies to log a service; the repository fills in the id
/// and timestamp.
class NewServiceRecord {
  const NewServiceRecord({
    required this.date,
    required this.odometerKm,
    required this.description,
    required this.costMinor,
  });

  final DateTime date;
  final int odometerKm;
  final String description;
  final int costMinor;
}

// The service history's own next-due tile ("next service by km/date", §6.9)
// is out of scope here: it needs a service *interval* the plan does not
// define a field for yet, so it is left to the screen that introduces one
// rather than guessed at in the repository.
