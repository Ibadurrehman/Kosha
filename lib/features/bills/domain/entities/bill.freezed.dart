// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Bill {

 String get id; String get name; int get amountMinor; DateTime get createdAt; DateTime get updatedAt; BillKind get kind;/// Local midnight of the next date money is owed.
///
/// Null means nothing is outstanding: a one-off ("on demand") bill that
/// has been paid has nowhere to advance to, so paying it clears the date
/// instead of leaving one in the past that would read as overdue for
/// ever.
 DateTime? get nextDue;/// An RFC 5545 rule the way tasks store one (`FREQ=MONTHLY;BYMONTHDAY=10`),
/// or null for a bill that arrives on no schedule. Month-end clamping is
/// `Recurrence`'s job, which is why 31 Jan → 28 Feb works here for free.
 String? get frequencyRule; bool get autopay; int get reminderOffsetDays;/// The day the most recent payment was recorded. Also the flag behind the
/// "Paid" status — see [billStatus] for why "has ever been paid" is a
/// sound reading of "paid for the cycle we are in".
 DateTime? get lastPaidOn; String? get provider;/// Consumer number, policy number, last four digits — whatever identifies
/// the account this bill is drawn against.
 String? get accountRef; String? get notes; String? get spaceId;
/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillCopyWith<Bill> get copyWith => _$BillCopyWithImpl<Bill>(this as Bill, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.frequencyRule, frequencyRule) || other.frequencyRule == frequencyRule)&&(identical(other.autopay, autopay) || other.autopay == autopay)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.lastPaidOn, lastPaidOn) || other.lastPaidOn == lastPaidOn)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accountRef, accountRef) || other.accountRef == accountRef)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,amountMinor,createdAt,updatedAt,kind,nextDue,frequencyRule,autopay,reminderOffsetDays,lastPaidOn,provider,accountRef,notes,spaceId);

@override
String toString() {
  return 'Bill(id: $id, name: $name, amountMinor: $amountMinor, createdAt: $createdAt, updatedAt: $updatedAt, kind: $kind, nextDue: $nextDue, frequencyRule: $frequencyRule, autopay: $autopay, reminderOffsetDays: $reminderOffsetDays, lastPaidOn: $lastPaidOn, provider: $provider, accountRef: $accountRef, notes: $notes, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class $BillCopyWith<$Res>  {
  factory $BillCopyWith(Bill value, $Res Function(Bill) _then) = _$BillCopyWithImpl;
@useResult
$Res call({
 String id, String name, int amountMinor, DateTime createdAt, DateTime updatedAt, BillKind kind, DateTime? nextDue, String? frequencyRule, bool autopay, int reminderOffsetDays, DateTime? lastPaidOn, String? provider, String? accountRef, String? notes, String? spaceId
});




}
/// @nodoc
class _$BillCopyWithImpl<$Res>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._self, this._then);

  final Bill _self;
  final $Res Function(Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amountMinor = null,Object? createdAt = null,Object? updatedAt = null,Object? kind = null,Object? nextDue = freezed,Object? frequencyRule = freezed,Object? autopay = null,Object? reminderOffsetDays = null,Object? lastPaidOn = freezed,Object? provider = freezed,Object? accountRef = freezed,Object? notes = freezed,Object? spaceId = freezed,}) {
  return _then(Bill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BillKind,nextDue: freezed == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as DateTime?,frequencyRule: freezed == frequencyRule ? _self.frequencyRule : frequencyRule // ignore: cast_nullable_to_non_nullable
as String?,autopay: null == autopay ? _self.autopay : autopay // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,lastPaidOn: freezed == lastPaidOn ? _self.lastPaidOn : lastPaidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,accountRef: freezed == accountRef ? _self.accountRef : accountRef // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Bill].
extension BillPatterns on Bill {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bill value)  $default,){
final _that = this;
switch (_that) {
case _Bill():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bill value)?  $default,){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int amountMinor,  DateTime createdAt,  DateTime updatedAt,  BillKind kind,  DateTime? nextDue,  String? frequencyRule,  bool autopay,  int reminderOffsetDays,  DateTime? lastPaidOn,  String? provider,  String? accountRef,  String? notes,  String? spaceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.name,_that.amountMinor,_that.createdAt,_that.updatedAt,_that.kind,_that.nextDue,_that.frequencyRule,_that.autopay,_that.reminderOffsetDays,_that.lastPaidOn,_that.provider,_that.accountRef,_that.notes,_that.spaceId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int amountMinor,  DateTime createdAt,  DateTime updatedAt,  BillKind kind,  DateTime? nextDue,  String? frequencyRule,  bool autopay,  int reminderOffsetDays,  DateTime? lastPaidOn,  String? provider,  String? accountRef,  String? notes,  String? spaceId)  $default,) {final _that = this;
switch (_that) {
case _Bill():
return $default(_that.id,_that.name,_that.amountMinor,_that.createdAt,_that.updatedAt,_that.kind,_that.nextDue,_that.frequencyRule,_that.autopay,_that.reminderOffsetDays,_that.lastPaidOn,_that.provider,_that.accountRef,_that.notes,_that.spaceId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int amountMinor,  DateTime createdAt,  DateTime updatedAt,  BillKind kind,  DateTime? nextDue,  String? frequencyRule,  bool autopay,  int reminderOffsetDays,  DateTime? lastPaidOn,  String? provider,  String? accountRef,  String? notes,  String? spaceId)?  $default,) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.name,_that.amountMinor,_that.createdAt,_that.updatedAt,_that.kind,_that.nextDue,_that.frequencyRule,_that.autopay,_that.reminderOffsetDays,_that.lastPaidOn,_that.provider,_that.accountRef,_that.notes,_that.spaceId);case _:
  return null;

}
}

}

/// @nodoc


class _Bill extends Bill {
  const _Bill({required this.id, required this.name, required this.amountMinor, required this.createdAt, required this.updatedAt, this.kind = BillKind.bill, this.nextDue, this.frequencyRule, this.autopay = false, this.reminderOffsetDays = defaultBillReminderDays, this.lastPaidOn, this.provider, this.accountRef, this.notes, this.spaceId}): super._();
  

@override final  String id;
@override final  String name;
@override final  int amountMinor;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  BillKind kind;
/// Local midnight of the next date money is owed.
///
/// Null means nothing is outstanding: a one-off ("on demand") bill that
/// has been paid has nowhere to advance to, so paying it clears the date
/// instead of leaving one in the past that would read as overdue for
/// ever.
@override final  DateTime? nextDue;
/// An RFC 5545 rule the way tasks store one (`FREQ=MONTHLY;BYMONTHDAY=10`),
/// or null for a bill that arrives on no schedule. Month-end clamping is
/// `Recurrence`'s job, which is why 31 Jan → 28 Feb works here for free.
@override final  String? frequencyRule;
@override@JsonKey() final  bool autopay;
@override@JsonKey() final  int reminderOffsetDays;
/// The day the most recent payment was recorded. Also the flag behind the
/// "Paid" status — see [billStatus] for why "has ever been paid" is a
/// sound reading of "paid for the cycle we are in".
@override final  DateTime? lastPaidOn;
@override final  String? provider;
/// Consumer number, policy number, last four digits — whatever identifies
/// the account this bill is drawn against.
@override final  String? accountRef;
@override final  String? notes;
@override final  String? spaceId;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillCopyWith<_Bill> get copyWith => __$BillCopyWithImpl<_Bill>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.frequencyRule, frequencyRule) || other.frequencyRule == frequencyRule)&&(identical(other.autopay, autopay) || other.autopay == autopay)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.lastPaidOn, lastPaidOn) || other.lastPaidOn == lastPaidOn)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accountRef, accountRef) || other.accountRef == accountRef)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,amountMinor,createdAt,updatedAt,kind,nextDue,frequencyRule,autopay,reminderOffsetDays,lastPaidOn,provider,accountRef,notes,spaceId);

@override
String toString() {
  return 'Bill(id: $id, name: $name, amountMinor: $amountMinor, createdAt: $createdAt, updatedAt: $updatedAt, kind: $kind, nextDue: $nextDue, frequencyRule: $frequencyRule, autopay: $autopay, reminderOffsetDays: $reminderOffsetDays, lastPaidOn: $lastPaidOn, provider: $provider, accountRef: $accountRef, notes: $notes, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class _$BillCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$BillCopyWith(_Bill value, $Res Function(_Bill) _then) = __$BillCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int amountMinor, DateTime createdAt, DateTime updatedAt, BillKind kind, DateTime? nextDue, String? frequencyRule, bool autopay, int reminderOffsetDays, DateTime? lastPaidOn, String? provider, String? accountRef, String? notes, String? spaceId
});




}
/// @nodoc
class __$BillCopyWithImpl<$Res>
    implements _$BillCopyWith<$Res> {
  __$BillCopyWithImpl(this._self, this._then);

  final _Bill _self;
  final $Res Function(_Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amountMinor = null,Object? createdAt = null,Object? updatedAt = null,Object? kind = null,Object? nextDue = freezed,Object? frequencyRule = freezed,Object? autopay = null,Object? reminderOffsetDays = null,Object? lastPaidOn = freezed,Object? provider = freezed,Object? accountRef = freezed,Object? notes = freezed,Object? spaceId = freezed,}) {
  return _then(_Bill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BillKind,nextDue: freezed == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as DateTime?,frequencyRule: freezed == frequencyRule ? _self.frequencyRule : frequencyRule // ignore: cast_nullable_to_non_nullable
as String?,autopay: null == autopay ? _self.autopay : autopay // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,lastPaidOn: freezed == lastPaidOn ? _self.lastPaidOn : lastPaidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,accountRef: freezed == accountRef ? _self.accountRef : accountRef // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
