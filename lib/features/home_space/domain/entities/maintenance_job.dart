import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_job.freezed.dart';

/// A maintenance job's status (section 6.10). Unlike `BillStatus` or
/// `DocumentStatus`, this is a *stored* field, not derived — the seed data's
/// "Kitchen tap leak (Active, plumber 6 Sep)" is Active despite its date
/// being days ahead, which only a user's own choice can express. Persisted by
/// index — append only.
enum MaintenanceJobStatus {
  upcoming('Upcoming'),
  active('Active'),
  overdue('Overdue'),
  done('Done');

  const MaintenanceJobStatus(this.label);

  final String label;
}

/// A repair or service job (section 6.10's "Maintenance & repairs").
///
/// No `spaceId` picker: every row belongs to the one Home system space, found
/// the way `Vehicle.spaceId` is — see `HomeManagementRepository`'s doc
/// comment.
@freezed
abstract class MaintenanceJob with _$MaintenanceJob {
  const factory MaintenanceJob({
    required String id,
    required String title,
    required String spaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(MaintenanceJobStatus.upcoming) MaintenanceJobStatus status,
    DateTime? dueDate,
    int? costMinor,
    String? vendor,
    String? notes,

    /// The task this job was promoted into, if the user asked for one — the
    /// same nullable, unconstrained link `Payment.transactionId` uses, since
    /// the task can be edited or deleted on its own from that point on.
    String? taskId,
    DateTime? deletedAt,
  }) = _MaintenanceJob;

  const MaintenanceJob._();

  bool get isDeleted => deletedAt != null;

  bool get isPromoted => taskId != null;
}

/// Fields a caller supplies to create a job; the repository fills in the id,
/// its space and the timestamps.
class NewMaintenanceJob {
  const NewMaintenanceJob({
    required this.title,
    this.status = MaintenanceJobStatus.upcoming,
    this.dueDate,
    this.costMinor,
    this.vendor,
    this.notes,
  });

  final String title;
  final MaintenanceJobStatus status;
  final DateTime? dueDate;
  final int? costMinor;
  final String? vendor;
  final String? notes;
}

/// What a job's status pill actually reads: [MaintenanceJobStatus.overdue] is
/// never stored by a normal write (see [MaintenanceJobStatus]'s doc comment)
/// — it is what an Upcoming job with a past due date displays as, the same
/// "derived where the stored value would go stale" reasoning `billStatus`
/// gives `Bill.lastPaidOn`. Active and Done both override a passed date,
/// because neither reads as "overdue" no matter when it falls.
MaintenanceJobStatus maintenanceJobDisplayStatus(
  MaintenanceJob job,
  DateTime today,
) {
  if (job.status != MaintenanceJobStatus.upcoming) return job.status;
  final due = job.dueDate;
  if (due != null && due.isBefore(today)) return MaintenanceJobStatus.overdue;
  return MaintenanceJobStatus.upcoming;
}

/// Whether a job belongs in Home's "Needs attention" (§5.2 lists "maintenance
/// jobs overdue").
bool maintenanceJobNeedsAttention(MaintenanceJobStatus displayStatus) =>
    displayStatus == MaintenanceJobStatus.overdue;
