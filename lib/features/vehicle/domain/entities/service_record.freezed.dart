// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServiceRecord {

 String get id; String get vehicleId; DateTime get date; int get odometerKm; String get description; int get costMinor; DateTime get createdAt;
/// Create a copy of ServiceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceRecordCopyWith<ServiceRecord> get copyWith => _$ServiceRecordCopyWithImpl<ServiceRecord>(this as ServiceRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.description, description) || other.description == description)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,odometerKm,description,costMinor,createdAt);

@override
String toString() {
  return 'ServiceRecord(id: $id, vehicleId: $vehicleId, date: $date, odometerKm: $odometerKm, description: $description, costMinor: $costMinor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ServiceRecordCopyWith<$Res>  {
  factory $ServiceRecordCopyWith(ServiceRecord value, $Res Function(ServiceRecord) _then) = _$ServiceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleId, DateTime date, int odometerKm, String description, int costMinor, DateTime createdAt
});




}
/// @nodoc
class _$ServiceRecordCopyWithImpl<$Res>
    implements $ServiceRecordCopyWith<$Res> {
  _$ServiceRecordCopyWithImpl(this._self, this._then);

  final ServiceRecord _self;
  final $Res Function(ServiceRecord) _then;

/// Create a copy of ServiceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? odometerKm = null,Object? description = null,Object? costMinor = null,Object? createdAt = null,}) {
  return _then(ServiceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,costMinor: null == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceRecord].
extension ServiceRecordPatterns on ServiceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceRecord value)  $default,){
final _that = this;
switch (_that) {
case _ServiceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  int odometerKm,  String description,  int costMinor,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceRecord() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.odometerKm,_that.description,_that.costMinor,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  int odometerKm,  String description,  int costMinor,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ServiceRecord():
return $default(_that.id,_that.vehicleId,_that.date,_that.odometerKm,_that.description,_that.costMinor,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleId,  DateTime date,  int odometerKm,  String description,  int costMinor,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ServiceRecord() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.odometerKm,_that.description,_that.costMinor,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceRecord implements ServiceRecord {
  const _ServiceRecord({required this.id, required this.vehicleId, required this.date, required this.odometerKm, required this.description, required this.costMinor, required this.createdAt});
  

@override final  String id;
@override final  String vehicleId;
@override final  DateTime date;
@override final  int odometerKm;
@override final  String description;
@override final  int costMinor;
@override final  DateTime createdAt;

/// Create a copy of ServiceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceRecordCopyWith<_ServiceRecord> get copyWith => __$ServiceRecordCopyWithImpl<_ServiceRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.description, description) || other.description == description)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,odometerKm,description,costMinor,createdAt);

@override
String toString() {
  return 'ServiceRecord(id: $id, vehicleId: $vehicleId, date: $date, odometerKm: $odometerKm, description: $description, costMinor: $costMinor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ServiceRecordCopyWith<$Res> implements $ServiceRecordCopyWith<$Res> {
  factory _$ServiceRecordCopyWith(_ServiceRecord value, $Res Function(_ServiceRecord) _then) = __$ServiceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleId, DateTime date, int odometerKm, String description, int costMinor, DateTime createdAt
});




}
/// @nodoc
class __$ServiceRecordCopyWithImpl<$Res>
    implements _$ServiceRecordCopyWith<$Res> {
  __$ServiceRecordCopyWithImpl(this._self, this._then);

  final _ServiceRecord _self;
  final $Res Function(_ServiceRecord) _then;

/// Create a copy of ServiceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? odometerKm = null,Object? description = null,Object? costMinor = null,Object? createdAt = null,}) {
  return _then(_ServiceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,costMinor: null == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
