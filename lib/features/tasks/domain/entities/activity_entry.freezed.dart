// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityEntry {

 String get id; ActivityEvent get event; DateTime get at; String? get detail;
/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityEntryCopyWith<ActivityEntry> get copyWith => _$ActivityEntryCopyWithImpl<ActivityEntry>(this as ActivityEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.at, at) || other.at == at)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,event,at,detail);

@override
String toString() {
  return 'ActivityEntry(id: $id, event: $event, at: $at, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ActivityEntryCopyWith<$Res>  {
  factory $ActivityEntryCopyWith(ActivityEntry value, $Res Function(ActivityEntry) _then) = _$ActivityEntryCopyWithImpl;
@useResult
$Res call({
 String id, ActivityEvent event, DateTime at, String? detail
});




}
/// @nodoc
class _$ActivityEntryCopyWithImpl<$Res>
    implements $ActivityEntryCopyWith<$Res> {
  _$ActivityEntryCopyWithImpl(this._self, this._then);

  final ActivityEntry _self;
  final $Res Function(ActivityEntry) _then;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? event = null,Object? at = null,Object? detail = freezed,}) {
  return _then(ActivityEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ActivityEvent,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityEntry].
extension ActivityEntryPatterns on ActivityEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ActivityEvent event,  DateTime at,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that.id,_that.event,_that.at,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ActivityEvent event,  DateTime at,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _ActivityEntry():
return $default(_that.id,_that.event,_that.at,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ActivityEvent event,  DateTime at,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that.id,_that.event,_that.at,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityEntry extends ActivityEntry {
  const _ActivityEntry({required this.id, required this.event, required this.at, this.detail}): super._();
  

@override final  String id;
@override final  ActivityEvent event;
@override final  DateTime at;
@override final  String? detail;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityEntryCopyWith<_ActivityEntry> get copyWith => __$ActivityEntryCopyWithImpl<_ActivityEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.at, at) || other.at == at)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,event,at,detail);

@override
String toString() {
  return 'ActivityEntry(id: $id, event: $event, at: $at, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ActivityEntryCopyWith<$Res> implements $ActivityEntryCopyWith<$Res> {
  factory _$ActivityEntryCopyWith(_ActivityEntry value, $Res Function(_ActivityEntry) _then) = __$ActivityEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, ActivityEvent event, DateTime at, String? detail
});




}
/// @nodoc
class __$ActivityEntryCopyWithImpl<$Res>
    implements _$ActivityEntryCopyWith<$Res> {
  __$ActivityEntryCopyWithImpl(this._self, this._then);

  final _ActivityEntry _self;
  final $Res Function(_ActivityEntry) _then;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? event = null,Object? at = null,Object? detail = freezed,}) {
  return _then(_ActivityEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ActivityEvent,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
