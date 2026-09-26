// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FuelLog {

 String get id; String get vehicleId; DateTime get date; double get litres; int get costMinor; int get odometerKm; DateTime get createdAt;
/// Create a copy of FuelLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FuelLogCopyWith<FuelLog> get copyWith => _$FuelLogCopyWithImpl<FuelLog>(this as FuelLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FuelLog&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.litres, litres) || other.litres == litres)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,litres,costMinor,odometerKm,createdAt);

@override
String toString() {
  return 'FuelLog(id: $id, vehicleId: $vehicleId, date: $date, litres: $litres, costMinor: $costMinor, odometerKm: $odometerKm, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FuelLogCopyWith<$Res>  {
  factory $FuelLogCopyWith(FuelLog value, $Res Function(FuelLog) _then) = _$FuelLogCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleId, DateTime date, double litres, int costMinor, int odometerKm, DateTime createdAt
});




}
/// @nodoc
class _$FuelLogCopyWithImpl<$Res>
    implements $FuelLogCopyWith<$Res> {
  _$FuelLogCopyWithImpl(this._self, this._then);

  final FuelLog _self;
  final $Res Function(FuelLog) _then;

/// Create a copy of FuelLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? litres = null,Object? costMinor = null,Object? odometerKm = null,Object? createdAt = null,}) {
  return _then(FuelLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,litres: null == litres ? _self.litres : litres // ignore: cast_nullable_to_non_nullable
as double,costMinor: null == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FuelLog].
extension FuelLogPatterns on FuelLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FuelLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FuelLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FuelLog value)  $default,){
final _that = this;
switch (_that) {
case _FuelLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FuelLog value)?  $default,){
final _that = this;
switch (_that) {
case _FuelLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  double litres,  int costMinor,  int odometerKm,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FuelLog() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.litres,_that.costMinor,_that.odometerKm,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  double litres,  int costMinor,  int odometerKm,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FuelLog():
return $default(_that.id,_that.vehicleId,_that.date,_that.litres,_that.costMinor,_that.odometerKm,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleId,  DateTime date,  double litres,  int costMinor,  int odometerKm,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FuelLog() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.litres,_that.costMinor,_that.odometerKm,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FuelLog implements FuelLog {
  const _FuelLog({required this.id, required this.vehicleId, required this.date, required this.litres, required this.costMinor, required this.odometerKm, required this.createdAt});
  

@override final  String id;
@override final  String vehicleId;
@override final  DateTime date;
@override final  double litres;
@override final  int costMinor;
@override final  int odometerKm;
@override final  DateTime createdAt;

/// Create a copy of FuelLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FuelLogCopyWith<_FuelLog> get copyWith => __$FuelLogCopyWithImpl<_FuelLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FuelLog&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.litres, litres) || other.litres == litres)&&(identical(other.costMinor, costMinor) || other.costMinor == costMinor)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,litres,costMinor,odometerKm,createdAt);

@override
String toString() {
  return 'FuelLog(id: $id, vehicleId: $vehicleId, date: $date, litres: $litres, costMinor: $costMinor, odometerKm: $odometerKm, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FuelLogCopyWith<$Res> implements $FuelLogCopyWith<$Res> {
  factory _$FuelLogCopyWith(_FuelLog value, $Res Function(_FuelLog) _then) = __$FuelLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleId, DateTime date, double litres, int costMinor, int odometerKm, DateTime createdAt
});




}
/// @nodoc
class __$FuelLogCopyWithImpl<$Res>
    implements _$FuelLogCopyWith<$Res> {
  __$FuelLogCopyWithImpl(this._self, this._then);

  final _FuelLog _self;
  final $Res Function(_FuelLog) _then;

/// Create a copy of FuelLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? litres = null,Object? costMinor = null,Object? odometerKm = null,Object? createdAt = null,}) {
  return _then(_FuelLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,litres: null == litres ? _self.litres : litres // ignore: cast_nullable_to_non_nullable
as double,costMinor: null == costMinor ? _self.costMinor : costMinor // ignore: cast_nullable_to_non_nullable
as int,odometerKm: null == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
