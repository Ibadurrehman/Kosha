import 'entities/appliance.dart';
import 'entities/home_utility.dart';
import 'entities/maintenance_job.dart';

/// Reads and writes the three things Home management holds (section 6.10):
/// utilities, maintenance jobs and appliances.
///
/// None of the three carry a `spaceId` a user picks — every row belongs to
/// the one Home system space, found the way `VehicleRepository` finds
/// Vehicle's: `SpaceRepository.findBySystemKey(SystemSpace.home)`.
abstract interface class HomeManagementRepository {
  /// Every utility, in the order they were linked. Excludes one whose bill
  /// has been deleted — a live tile pointing at nothing would be a promise
  /// the app cannot keep.
  Stream<List<HomeUtility>> watchUtilities();

  Future<HomeUtility> addUtility(NewHomeUtility draft);

  /// Removes the link. The bill itself is untouched.
  Future<void> removeUtility(String id);

  /// Live maintenance jobs, most recently created first.
  Stream<List<MaintenanceJob>> watchJobs();

  /// Jobs whose display status (`maintenanceJobDisplayStatus`) reads Overdue
  /// — Home's Needs attention section.
  Stream<List<MaintenanceJob>> watchJobsNeedingAttention({
    required DateTime today,
  });

  Future<MaintenanceJob> createJob(NewMaintenanceJob draft);

  /// Applies an edit. Every argument is optional; omitting one leaves that
  /// field alone.
  ///
  /// Nullable fields the user can *clear* take a sentinel rather than
  /// null-means-unchanged, the same shape `DocumentRepository.edit` uses:
  /// [clearDueDate], [clearCost], [clearVendor], [clearNotes].
  Future<MaintenanceJob> editJob(
    String id, {
    String? title,
    MaintenanceJobStatus? status,
    DateTime? dueDate,
    bool clearDueDate = false,
    int? costMinor,
    bool clearCost = false,
    String? vendor,
    bool clearVendor = false,
    String? notes,
    bool clearNotes = false,
    String? taskId,
  });

  Future<void> softDeleteJob(String id);

  Future<void> restoreJob(String id);

  /// Live appliances, most recently created first.
  Stream<List<Appliance>> watchAppliances();

  /// Appliances whose warranty needs attention — Home's Needs attention
  /// section.
  Stream<List<Appliance>> watchAppliancesNeedingAttention({
    required DateTime today,
  });

  Future<Appliance> createAppliance(NewAppliance draft);

  /// Applies an edit. Every argument is optional; omitting one leaves that
  /// field alone. Nullable fields the user can clear take a sentinel, the
  /// same shape [editJob] uses.
  Future<Appliance> editAppliance(
    String id, {
    String? name,
    String? makeModel,
    bool clearMakeModel = false,
    DateTime? purchasedOn,
    bool clearPurchasedOn = false,
    DateTime? warrantyTill,
    bool clearWarrantyTill = false,
    DateTime? nextServiceOn,
    bool clearNextServiceOn = false,
    String? documentId,
    bool clearDocumentId = false,
  });

  Future<void> softDeleteAppliance(String id);

  Future<void> restoreAppliance(String id);
}
