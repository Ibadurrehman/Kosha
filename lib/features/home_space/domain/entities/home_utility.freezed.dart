// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_utility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeUtility {

 String get id; String get name; String get iconKey; String get billId; String get spaceId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of HomeUtility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeUtilityCopyWith<HomeUtility> get copyWith => _$HomeUtilityCopyWithImpl<HomeUtility>(this as HomeUtility, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeUtility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,billId,spaceId,createdAt,updatedAt);

@override
String toString() {
  return 'HomeUtility(id: $id, name: $name, iconKey: $iconKey, billId: $billId, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HomeUtilityCopyWith<$Res>  {
  factory $HomeUtilityCopyWith(HomeUtility value, $Res Function(HomeUtility) _then) = _$HomeUtilityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String iconKey, String billId, String spaceId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$HomeUtilityCopyWithImpl<$Res>
    implements $HomeUtilityCopyWith<$Res> {
  _$HomeUtilityCopyWithImpl(this._self, this._then);

  final HomeUtility _self;
  final $Res Function(HomeUtility) _then;

/// Create a copy of HomeUtility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? billId = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(HomeUtility(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeUtility].
extension HomeUtilityPatterns on HomeUtility {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeUtility value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeUtility() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeUtility value)  $default,){
final _that = this;
switch (_that) {
case _HomeUtility():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeUtility value)?  $default,){
final _that = this;
switch (_that) {
case _HomeUtility() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String iconKey,  String billId,  String spaceId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeUtility() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.billId,_that.spaceId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String iconKey,  String billId,  String spaceId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HomeUtility():
return $default(_that.id,_that.name,_that.iconKey,_that.billId,_that.spaceId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String iconKey,  String billId,  String spaceId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HomeUtility() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.billId,_that.spaceId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _HomeUtility implements HomeUtility {
  const _HomeUtility({required this.id, required this.name, required this.iconKey, required this.billId, required this.spaceId, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String name;
@override final  String iconKey;
@override final  String billId;
@override final  String spaceId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of HomeUtility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeUtilityCopyWith<_HomeUtility> get copyWith => __$HomeUtilityCopyWithImpl<_HomeUtility>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeUtility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,billId,spaceId,createdAt,updatedAt);

@override
String toString() {
  return 'HomeUtility(id: $id, name: $name, iconKey: $iconKey, billId: $billId, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HomeUtilityCopyWith<$Res> implements $HomeUtilityCopyWith<$Res> {
  factory _$HomeUtilityCopyWith(_HomeUtility value, $Res Function(_HomeUtility) _then) = __$HomeUtilityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String iconKey, String billId, String spaceId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$HomeUtilityCopyWithImpl<$Res>
    implements _$HomeUtilityCopyWith<$Res> {
  __$HomeUtilityCopyWithImpl(this._self, this._then);

  final _HomeUtility _self;
  final $Res Function(_HomeUtility) _then;

/// Create a copy of HomeUtility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? billId = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_HomeUtility(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
