// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Event {

 String get id; String get title; DateTime get startAt; DateTime get createdAt; DateTime get updatedAt; String? get description; DateTime? get endAt; bool get allDay;/// Minutes before [startAt] to fire a reminder; null means no reminder.
 int? get reminderOffsetMinutes; String? get spaceId;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,createdAt,updatedAt,description,endAt,allDay,reminderOffsetMinutes,spaceId);

@override
String toString() {
  return 'Event(id: $id, title: $title, startAt: $startAt, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, endAt: $endAt, allDay: $allDay, reminderOffsetMinutes: $reminderOffsetMinutes, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime startAt, DateTime createdAt, DateTime updatedAt, String? description, DateTime? endAt, bool allDay, int? reminderOffsetMinutes, String? spaceId
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startAt = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? endAt = freezed,Object? allDay = null,Object? reminderOffsetMinutes = freezed,Object? spaceId = freezed,}) {
  return _then(Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startAt,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? endAt,  bool allDay,  int? reminderOffsetMinutes,  String? spaceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.createdAt,_that.updatedAt,_that.description,_that.endAt,_that.allDay,_that.reminderOffsetMinutes,_that.spaceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startAt,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? endAt,  bool allDay,  int? reminderOffsetMinutes,  String? spaceId)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.title,_that.startAt,_that.createdAt,_that.updatedAt,_that.description,_that.endAt,_that.allDay,_that.reminderOffsetMinutes,_that.spaceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime startAt,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? endAt,  bool allDay,  int? reminderOffsetMinutes,  String? spaceId)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.createdAt,_that.updatedAt,_that.description,_that.endAt,_that.allDay,_that.reminderOffsetMinutes,_that.spaceId);case _:
  return null;

}
}

}

/// @nodoc


class _Event implements Event {
  const _Event({required this.id, required this.title, required this.startAt, required this.createdAt, required this.updatedAt, this.description, this.endAt, this.allDay = false, this.reminderOffsetMinutes, this.spaceId});
  

@override final  String id;
@override final  String title;
@override final  DateTime startAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override final  DateTime? endAt;
@override@JsonKey() final  bool allDay;
/// Minutes before [startAt] to fire a reminder; null means no reminder.
@override final  int? reminderOffsetMinutes;
@override final  String? spaceId;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,createdAt,updatedAt,description,endAt,allDay,reminderOffsetMinutes,spaceId);

@override
String toString() {
  return 'Event(id: $id, title: $title, startAt: $startAt, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, endAt: $endAt, allDay: $allDay, reminderOffsetMinutes: $reminderOffsetMinutes, spaceId: $spaceId)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime startAt, DateTime createdAt, DateTime updatedAt, String? description, DateTime? endAt, bool allDay, int? reminderOffsetMinutes, String? spaceId
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startAt = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? endAt = freezed,Object? allDay = null,Object? reminderOffsetMinutes = freezed,Object? spaceId = freezed,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
