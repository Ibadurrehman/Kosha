// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSection {

 HomeSectionKey get key; bool get enabled; int get sortOrder;
/// Create a copy of DashboardSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSectionCopyWith<DashboardSection> get copyWith => _$DashboardSectionCopyWithImpl<DashboardSection>(this as DashboardSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSection&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,key,enabled,sortOrder);

@override
String toString() {
  return 'DashboardSection(key: $key, enabled: $enabled, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $DashboardSectionCopyWith<$Res>  {
  factory $DashboardSectionCopyWith(DashboardSection value, $Res Function(DashboardSection) _then) = _$DashboardSectionCopyWithImpl;
@useResult
$Res call({
 HomeSectionKey key, bool enabled, int sortOrder
});




}
/// @nodoc
class _$DashboardSectionCopyWithImpl<$Res>
    implements $DashboardSectionCopyWith<$Res> {
  _$DashboardSectionCopyWithImpl(this._self, this._then);

  final DashboardSection _self;
  final $Res Function(DashboardSection) _then;

/// Create a copy of DashboardSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? enabled = null,Object? sortOrder = null,}) {
  return _then(DashboardSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as HomeSectionKey,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSection].
extension DashboardSectionPatterns on DashboardSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSection value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSection value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeSectionKey key,  bool enabled,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSection() when $default != null:
return $default(_that.key,_that.enabled,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeSectionKey key,  bool enabled,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _DashboardSection():
return $default(_that.key,_that.enabled,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeSectionKey key,  bool enabled,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSection() when $default != null:
return $default(_that.key,_that.enabled,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSection implements DashboardSection {
  const _DashboardSection({required this.key, required this.enabled, required this.sortOrder});
  

@override final  HomeSectionKey key;
@override final  bool enabled;
@override final  int sortOrder;

/// Create a copy of DashboardSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSectionCopyWith<_DashboardSection> get copyWith => __$DashboardSectionCopyWithImpl<_DashboardSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSection&&(identical(other.key, key) || other.key == key)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,key,enabled,sortOrder);

@override
String toString() {
  return 'DashboardSection(key: $key, enabled: $enabled, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$DashboardSectionCopyWith<$Res> implements $DashboardSectionCopyWith<$Res> {
  factory _$DashboardSectionCopyWith(_DashboardSection value, $Res Function(_DashboardSection) _then) = __$DashboardSectionCopyWithImpl;
@override @useResult
$Res call({
 HomeSectionKey key, bool enabled, int sortOrder
});




}
/// @nodoc
class __$DashboardSectionCopyWithImpl<$Res>
    implements _$DashboardSectionCopyWith<$Res> {
  __$DashboardSectionCopyWithImpl(this._self, this._then);

  final _DashboardSection _self;
  final $Res Function(_DashboardSection) _then;

/// Create a copy of DashboardSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? enabled = null,Object? sortOrder = null,}) {
  return _then(_DashboardSection(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as HomeSectionKey,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
