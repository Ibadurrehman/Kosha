import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/home_management_repository_impl.dart';
import '../../domain/entities/appliance.dart';
import '../../domain/entities/home_utility.dart';
import '../../domain/entities/maintenance_job.dart';

part 'home_management_providers.g.dart';

@riverpod
Stream<List<HomeUtility>> homeUtilities(Ref ref) =>
    ref.watch(homeManagementRepositoryProvider).watchUtilities();

@riverpod
Stream<List<MaintenanceJob>> maintenanceJobs(Ref ref) =>
    ref.watch(homeManagementRepositoryProvider).watchJobs();

@riverpod
Stream<List<Appliance>> appliances(Ref ref) =>
    ref.watch(homeManagementRepositoryProvider).watchAppliances();
