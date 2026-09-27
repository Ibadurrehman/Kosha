// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_renewal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleRenewal {

 String get id; String get vehicleId; VehicleRenewalKind get kind; DateTime get validTill; DateTime get createdAt; DateTime get updatedAt; int get reminderOffsetDays;/// The Document row this renewal was filed under (Add document, category
/// Vehicle), if the user attached one.
 String? get documentId;
/// Create a copy of VehicleRenewal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleRenewalCopyWith<VehicleRenewal> get copyWith => _$VehicleRenewalCopyWithImpl<VehicleRenewal>(this as VehicleRenewal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleRenewal&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.validTill, validTill) || other.validTill == validTill)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,kind,validTill,createdAt,updatedAt,reminderOffsetDays,documentId);

@override
String toString() {
  return 'VehicleRenewal(id: $id, vehicleId: $vehicleId, kind: $kind, validTill: $validTill, createdAt: $createdAt, updatedAt: $updatedAt, reminderOffsetDays: $reminderOffsetDays, documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $VehicleRenewalCopyWith<$Res>  {
  factory $VehicleRenewalCopyWith(VehicleRenewal value, $Res Function(VehicleRenewal) _then) = _$VehicleRenewalCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleId, VehicleRenewalKind kind, DateTime validTill, DateTime createdAt, DateTime updatedAt, int reminderOffsetDays, String? documentId
});




}
/// @nodoc
class _$VehicleRenewalCopyWithImpl<$Res>
    implements $VehicleRenewalCopyWith<$Res> {
  _$VehicleRenewalCopyWithImpl(this._self, this._then);

  final VehicleRenewal _self;
  final $Res Function(VehicleRenewal) _then;

/// Create a copy of VehicleRenewal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? kind = null,Object? validTill = null,Object? createdAt = null,Object? updatedAt = null,Object? reminderOffsetDays = null,Object? documentId = freezed,}) {
  return _then(VehicleRenewal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as VehicleRenewalKind,validTill: null == validTill ? _self.validTill : validTill // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleRenewal].
extension VehicleRenewalPatterns on VehicleRenewal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleRenewal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleRenewal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleRenewal value)  $default,){
final _that = this;
switch (_that) {
case _VehicleRenewal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleRenewal value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleRenewal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleId,  VehicleRenewalKind kind,  DateTime validTill,  DateTime createdAt,  DateTime updatedAt,  int reminderOffsetDays,  String? documentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleRenewal() when $default != null:
return $default(_that.id,_that.vehicleId,_that.kind,_that.validTill,_that.createdAt,_that.updatedAt,_that.reminderOffsetDays,_that.documentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleId,  VehicleRenewalKind kind,  DateTime validTill,  DateTime createdAt,  DateTime updatedAt,  int reminderOffsetDays,  String? documentId)  $default,) {final _that = this;
switch (_that) {
case _VehicleRenewal():
return $default(_that.id,_that.vehicleId,_that.kind,_that.validTill,_that.createdAt,_that.updatedAt,_that.reminderOffsetDays,_that.documentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleId,  VehicleRenewalKind kind,  DateTime validTill,  DateTime createdAt,  DateTime updatedAt,  int reminderOffsetDays,  String? documentId)?  $default,) {final _that = this;
switch (_that) {
case _VehicleRenewal() when $default != null:
return $default(_that.id,_that.vehicleId,_that.kind,_that.validTill,_that.createdAt,_that.updatedAt,_that.reminderOffsetDays,_that.documentId);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleRenewal extends VehicleRenewal {
  const _VehicleRenewal({required this.id, required this.vehicleId, required this.kind, required this.validTill, required this.createdAt, required this.updatedAt, this.reminderOffsetDays = defaultVehicleRenewalReminderDays, this.documentId}): super._();
  

@override final  String id;
@override final  String vehicleId;
@override final  VehicleRenewalKind kind;
@override final  DateTime validTill;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  int reminderOffsetDays;
/// The Document row this renewal was filed under (Add document, category
/// Vehicle), if the user attached one.
@override final  String? documentId;

/// Create a copy of VehicleRenewal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleRenewalCopyWith<_VehicleRenewal> get copyWith => __$VehicleRenewalCopyWithImpl<_VehicleRenewal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleRenewal&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.validTill, validTill) || other.validTill == validTill)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,kind,validTill,createdAt,updatedAt,reminderOffsetDays,documentId);

@override
String toString() {
  return 'VehicleRenewal(id: $id, vehicleId: $vehicleId, kind: $kind, validTill: $validTill, createdAt: $createdAt, updatedAt: $updatedAt, reminderOffsetDays: $reminderOffsetDays, documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class _$VehicleRenewalCopyWith<$Res> implements $VehicleRenewalCopyWith<$Res> {
  factory _$VehicleRenewalCopyWith(_VehicleRenewal value, $Res Function(_VehicleRenewal) _then) = __$VehicleRenewalCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleId, VehicleRenewalKind kind, DateTime validTill, DateTime createdAt, DateTime updatedAt, int reminderOffsetDays, String? documentId
});




}
/// @nodoc
class __$VehicleRenewalCopyWithImpl<$Res>
    implements _$VehicleRenewalCopyWith<$Res> {
  __$VehicleRenewalCopyWithImpl(this._self, this._then);

  final _VehicleRenewal _self;
  final $Res Function(_VehicleRenewal) _then;

/// Create a copy of VehicleRenewal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? kind = null,Object? validTill = null,Object? createdAt = null,Object? updatedAt = null,Object? reminderOffsetDays = null,Object? documentId = freezed,}) {
  return _then(_VehicleRenewal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as VehicleRenewalKind,validTill: null == validTill ? _self.validTill : validTill // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
