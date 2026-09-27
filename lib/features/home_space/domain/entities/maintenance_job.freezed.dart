// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaintenanceJob {

 String get id; String get title; String get spaceId; DateTime get createdAt; DateTime get updatedAt; MaintenanceJobStatus get status; DateTime? get dueDate; int? get costMinor; String? get vendor; String? get notes;/// The task this job was promoted into, if the user asked for one — the
/// same nullable, unconstrained link `Payment.transactionId` uses, since
/// the task can be edited or deleted on its own from that point on.
 String? get taskId; DateTime? get deletedAt;
/// Create a copy of MaintenanceJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceJobCopyWith<MaintenanceJob> get copyWith => _$MaintenanceJobCopyWithImpl<MaintenanceJob>(this as MaintenanceJob, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceJob&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,spaceId,createdAt,updatedAt,status,dueDate,costMinor,vendor,notes,taskId,deletedAt);

@override
String toString() {
  return 'MaintenanceJob(id: $id, title: $title, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, dueDate: $dueDate, costMinor: $costMinor, vendor: $vendor, notes: $notes, taskId: $taskId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $MaintenanceJobCopyWith<$Res>  {
  factory $MaintenanceJobCopyWith(MaintenanceJob value, $Res Function(MaintenanceJob) _then) = _$MaintenanceJobCopyWithImpl;
@useResult
$Res call({
 String id, String title, String spaceId, DateTime createdAt, DateTime updatedAt, MaintenanceJobStatus status, DateTime? dueDate, int? costMinor, String? vendor, String? notes, String? taskId, DateTime? deletedAt
});




}
/// @nodoc
class _$MaintenanceJobCopyWithImpl<$Res>
    implements $MaintenanceJobCopyWith<$Res> {
  _$MaintenanceJobCopyWithImpl(this._self, this._then);

  final MaintenanceJob _self;
  final $Res Function(MaintenanceJob) _then;

/// Create a copy of MaintenanceJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? dueDate = freezed,Object? costMinor = freezed,Object? vendor = freezed,Object? notes = freezed,Object? taskId = freezed,Object? deletedAt = freezed,}) {
  return _then(MaintenanceJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaintenanceJobStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,costMinor: freezed == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceJob].
extension MaintenanceJobPatterns on MaintenanceJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceJob value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceJob value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  MaintenanceJobStatus status,  DateTime? dueDate,  int? costMinor,  String? vendor,  String? notes,  String? taskId,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceJob() when $default != null:
return $default(_that.id,_that.title,_that.spaceId,_that.createdAt,_that.updatedAt,_that.status,_that.dueDate,_that.costMinor,_that.vendor,_that.notes,_that.taskId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  MaintenanceJobStatus status,  DateTime? dueDate,  int? costMinor,  String? vendor,  String? notes,  String? taskId,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceJob():
return $default(_that.id,_that.title,_that.spaceId,_that.createdAt,_that.updatedAt,_that.status,_that.dueDate,_that.costMinor,_that.vendor,_that.notes,_that.taskId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  MaintenanceJobStatus status,  DateTime? dueDate,  int? costMinor,  String? vendor,  String? notes,  String? taskId,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceJob() when $default != null:
return $default(_that.id,_that.title,_that.spaceId,_that.createdAt,_that.updatedAt,_that.status,_that.dueDate,_that.costMinor,_that.vendor,_that.notes,_that.taskId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MaintenanceJob extends MaintenanceJob {
  const _MaintenanceJob({required this.id, required this.title, required this.spaceId, required this.createdAt, required this.updatedAt, this.status = MaintenanceJobStatus.upcoming, this.dueDate, this.costMinor, this.vendor, this.notes, this.taskId, this.deletedAt}): super._();
  

@override final  String id;
@override final  String title;
@override final  String spaceId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  MaintenanceJobStatus status;
@override final  DateTime? dueDate;
@override final  int? costMinor;
@override final  String? vendor;
@override final  String? notes;
/// The task this job was promoted into, if the user asked for one — the
/// same nullable, unconstrained link `Payment.transactionId` uses, since
/// the task can be edited or deleted on its own from that point on.
@override final  String? taskId;
@override final  DateTime? deletedAt;

/// Create a copy of MaintenanceJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceJobCopyWith<_MaintenanceJob> get copyWith => __$MaintenanceJobCopyWithImpl<_MaintenanceJob>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceJob&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,spaceId,createdAt,updatedAt,status,dueDate,costMinor,vendor,notes,taskId,deletedAt);

@override
String toString() {
  return 'MaintenanceJob(id: $id, title: $title, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, dueDate: $dueDate, costMinor: $costMinor, vendor: $vendor, notes: $notes, taskId: $taskId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceJobCopyWith<$Res> implements $MaintenanceJobCopyWith<$Res> {
  factory _$MaintenanceJobCopyWith(_MaintenanceJob value, $Res Function(_MaintenanceJob) _then) = __$MaintenanceJobCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String spaceId, DateTime createdAt, DateTime updatedAt, MaintenanceJobStatus status, DateTime? dueDate, int? costMinor, String? vendor, String? notes, String? taskId, DateTime? deletedAt
});




}
/// @nodoc
class __$MaintenanceJobCopyWithImpl<$Res>
    implements _$MaintenanceJobCopyWith<$Res> {
  __$MaintenanceJobCopyWithImpl(this._self, this._then);

  final _MaintenanceJob _self;
  final $Res Function(_MaintenanceJob) _then;

/// Create a copy of MaintenanceJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? dueDate = freezed,Object? costMinor = freezed,Object? vendor = freezed,Object? notes = freezed,Object? taskId = freezed,Object? deletedAt = freezed,}) {
  return _then(_MaintenanceJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaintenanceJobStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,costMinor: freezed == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
