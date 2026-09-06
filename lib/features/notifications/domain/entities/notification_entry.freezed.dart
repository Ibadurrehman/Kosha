// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationEntry {

 String get id; ReminderKind get kind; String get ownerId; String get title; DateTime get createdAt; String? get body; String? get route; DateTime? get readAt;
/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEntryCopyWith<NotificationEntry> get copyWith => _$NotificationEntryCopyWithImpl<NotificationEntry>(this as NotificationEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.body, body) || other.body == body)&&(identical(other.route, route) || other.route == route)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerId,title,createdAt,body,route,readAt);

@override
String toString() {
  return 'NotificationEntry(id: $id, kind: $kind, ownerId: $ownerId, title: $title, createdAt: $createdAt, body: $body, route: $route, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $NotificationEntryCopyWith<$Res>  {
  factory $NotificationEntryCopyWith(NotificationEntry value, $Res Function(NotificationEntry) _then) = _$NotificationEntryCopyWithImpl;
@useResult
$Res call({
 String id, ReminderKind kind, String ownerId, String title, DateTime createdAt, String? body, String? route, DateTime? readAt
});




}
/// @nodoc
class _$NotificationEntryCopyWithImpl<$Res>
    implements $NotificationEntryCopyWith<$Res> {
  _$NotificationEntryCopyWithImpl(this._self, this._then);

  final NotificationEntry _self;
  final $Res Function(NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? ownerId = null,Object? title = null,Object? createdAt = null,Object? body = freezed,Object? route = freezed,Object? readAt = freezed,}) {
  return _then(NotificationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationEntry].
extension NotificationEntryPatterns on NotificationEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEntry value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ReminderKind kind,  String ownerId,  String title,  DateTime createdAt,  String? body,  String? route,  DateTime? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.kind,_that.ownerId,_that.title,_that.createdAt,_that.body,_that.route,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ReminderKind kind,  String ownerId,  String title,  DateTime createdAt,  String? body,  String? route,  DateTime? readAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry():
return $default(_that.id,_that.kind,_that.ownerId,_that.title,_that.createdAt,_that.body,_that.route,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ReminderKind kind,  String ownerId,  String title,  DateTime createdAt,  String? body,  String? route,  DateTime? readAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEntry() when $default != null:
return $default(_that.id,_that.kind,_that.ownerId,_that.title,_that.createdAt,_that.body,_that.route,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationEntry extends NotificationEntry {
  const _NotificationEntry({required this.id, required this.kind, required this.ownerId, required this.title, required this.createdAt, this.body, this.route, this.readAt}): super._();
  

@override final  String id;
@override final  ReminderKind kind;
@override final  String ownerId;
@override final  String title;
@override final  DateTime createdAt;
@override final  String? body;
@override final  String? route;
@override final  DateTime? readAt;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEntryCopyWith<_NotificationEntry> get copyWith => __$NotificationEntryCopyWithImpl<_NotificationEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.body, body) || other.body == body)&&(identical(other.route, route) || other.route == route)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerId,title,createdAt,body,route,readAt);

@override
String toString() {
  return 'NotificationEntry(id: $id, kind: $kind, ownerId: $ownerId, title: $title, createdAt: $createdAt, body: $body, route: $route, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationEntryCopyWith<$Res> implements $NotificationEntryCopyWith<$Res> {
  factory _$NotificationEntryCopyWith(_NotificationEntry value, $Res Function(_NotificationEntry) _then) = __$NotificationEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, ReminderKind kind, String ownerId, String title, DateTime createdAt, String? body, String? route, DateTime? readAt
});




}
/// @nodoc
class __$NotificationEntryCopyWithImpl<$Res>
    implements _$NotificationEntryCopyWith<$Res> {
  __$NotificationEntryCopyWithImpl(this._self, this._then);

  final _NotificationEntry _self;
  final $Res Function(_NotificationEntry) _then;

/// Create a copy of NotificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? ownerId = null,Object? title = null,Object? createdAt = null,Object? body = freezed,Object? route = freezed,Object? readAt = freezed,}) {
  return _then(_NotificationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
