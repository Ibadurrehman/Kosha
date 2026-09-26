import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_utility.freezed.dart';

/// A thin link between a bill and the Home screen's Utilities row (section
/// 6.10). `Bill` carries no icon of its own — Phase 2 dropped the field the
/// plan's original data model gave it — so this table's own `iconKey` is what
/// lets Electricity/Water/Gas/Internet read as distinct tiles rather than
/// four identical receipts.
///
/// Tapping a utility opens Bills filtered to it (section 6.10's "tap → Bills
/// filtered"); nothing here duplicates the bill's own amount or due date.
@freezed
abstract class HomeUtility with _$HomeUtility {
  const factory HomeUtility({
    required String id,
    required String name,
    required String iconKey,
    required String billId,
    required String spaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HomeUtility;
}

/// Fields a caller supplies to link a bill as a utility; the repository fills
/// in the id, its space and the timestamps.
class NewHomeUtility {
  const NewHomeUtility({
    required this.name,
    required this.iconKey,
    required this.billId,
  });

  final String name;
  final String iconKey;
  final String billId;
}

/// The icons the New utility picker offers, keyed the way `spaceIconKeys` is
/// — `presentation/home_utility_icons.dart` maps these to real symbols.
const List<String> homeUtilityIconKeys = [
  'bolt',
  'water_drop',
  'local_fire_department',
  'wifi',
  'category',
];
