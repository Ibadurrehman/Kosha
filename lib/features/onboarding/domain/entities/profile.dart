import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

/// The single local profile row. There is exactly one until Phase 5 adds
/// accounts.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String name,
    required String avatarInitials,
    required DateTime joinedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? email,
    @Default('INR') String currency,
    @Default('d MMM yyyy') String dateFormat,

    /// 1 = Monday, matching `DateTime.weekday`.
    @Default(1) int weekStart,
    @Default('en') String locale,
    @Default(false) bool onboardingCompleted,
  }) = _Profile;
}
