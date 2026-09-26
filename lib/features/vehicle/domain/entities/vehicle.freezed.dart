// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Vehicle {

 String get id; String get name; String get makeModel; String get registration; int get odometerKm; String get spaceId; DateTime get createdAt; DateTime get updatedAt; DateTime? get purchaseDate;/// Soft delete, so an undone creation or a removed vehicle can come back —
/// the same shape as `Tasks`/`Bills`. Nothing in v1's UI exposes removing
/// the one vehicle it manages, but the model does not assume that stays
/// true.
 DateTime? get deletedAt;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.makeModel, makeModel) || other.makeModel == makeModel)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,makeModel,registration,odometerKm,spaceId,createdAt,updatedAt,purchaseDate,deletedAt);

@override
String toString() {
  return 'Vehicle(id: $id, name: $name, makeModel: $makeModel, registration: $registration, odometerKm: $odometerKm, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, purchaseDate: $purchaseDate, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String makeModel, String registration, int odometerKm, String spaceId, DateTime createdAt, DateTime updatedAt, DateTime? purchaseDate, DateTime? deletedAt
});




}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? makeModel = null,Object? registration = null,Object? odometerKm = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? purchaseDate = freezed,Object? deletedAt = freezed,}) {
  return _then(Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,makeModel: null == makeModel ? _self.makeModel : makeModel // ignore: cast_nullable_to_non_nullable
as String,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String makeModel,  String registration,  int odometerKm,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  DateTime? purchaseDate,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.name,_that.makeModel,_that.registration,_that.odometerKm,_that.spaceId,_that.createdAt,_that.updatedAt,_that.purchaseDate,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String makeModel,  String registration,  int odometerKm,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  DateTime? purchaseDate,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.name,_that.makeModel,_that.registration,_that.odometerKm,_that.spaceId,_that.createdAt,_that.updatedAt,_that.purchaseDate,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String makeModel,  String registration,  int odometerKm,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  DateTime? purchaseDate,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.name,_that.makeModel,_that.registration,_that.odometerKm,_that.spaceId,_that.createdAt,_that.updatedAt,_that.purchaseDate,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Vehicle extends Vehicle {
  const _Vehicle({required this.id, required this.name, required this.makeModel, required this.registration, required this.odometerKm, required this.spaceId, required this.createdAt, required this.updatedAt, this.purchaseDate, this.deletedAt}): super._();
  

@override final  String id;
@override final  String name;
@override final  String makeModel;
@override final  String registration;
@override final  int odometerKm;
@override final  String spaceId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? purchaseDate;
/// Soft delete, so an undone creation or a removed vehicle can come back —
/// the same shape as `Tasks`/`Bills`. Nothing in v1's UI exposes removing
/// the one vehicle it manages, but the model does not assume that stays
/// true.
@override final  DateTime? deletedAt;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.makeModel, makeModel) || other.makeModel == makeModel)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,makeModel,registration,odometerKm,spaceId,createdAt,updatedAt,purchaseDate,deletedAt);

@override
String toString() {
  return 'Vehicle(id: $id, name: $name, makeModel: $makeModel, registration: $registration, odometerKm: $odometerKm, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, purchaseDate: $purchaseDate, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String makeModel, String registration, int odometerKm, String spaceId, DateTime createdAt, DateTime updatedAt, DateTime? purchaseDate, DateTime? deletedAt
});




}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? makeModel = null,Object? registration = null,Object? odometerKm = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? purchaseDate = freezed,Object? deletedAt = freezed,}) {
  return _then(_Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,makeModel: null == makeModel ? _self.makeModel : makeModel // ignore: cast_nullable_to_non_nullable
as String,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
