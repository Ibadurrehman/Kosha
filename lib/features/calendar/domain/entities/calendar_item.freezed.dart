// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalendarItem {

 String get id; CalendarItemKind get kind; String get title;/// Local midnight of the day this item falls on — the grouping key.
 DateTime get date;/// Minutes since midnight, or null for "all day" / "no time".
 int? get minutes;
/// Create a copy of CalendarItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarItemCopyWith<CalendarItem> get copyWith => _$CalendarItemCopyWithImpl<CalendarItem>(this as CalendarItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,date,minutes);

@override
String toString() {
  return 'CalendarItem(id: $id, kind: $kind, title: $title, date: $date, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class $CalendarItemCopyWith<$Res>  {
  factory $CalendarItemCopyWith(CalendarItem value, $Res Function(CalendarItem) _then) = _$CalendarItemCopyWithImpl;
@useResult
$Res call({
 String id, CalendarItemKind kind, String title, DateTime date, int? minutes
});




}
/// @nodoc
class _$CalendarItemCopyWithImpl<$Res>
    implements $CalendarItemCopyWith<$Res> {
  _$CalendarItemCopyWithImpl(this._self, this._then);

  final CalendarItem _self;
  final $Res Function(CalendarItem) _then;

/// Create a copy of CalendarItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? date = null,Object? minutes = freezed,}) {
  return _then(CalendarItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarItem].
extension CalendarItemPatterns on CalendarItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarItem value)  $default,){
final _that = this;
switch (_that) {
case _CalendarItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarItem value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CalendarItemKind kind,  String title,  DateTime date,  int? minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.date,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CalendarItemKind kind,  String title,  DateTime date,  int? minutes)  $default,) {final _that = this;
switch (_that) {
case _CalendarItem():
return $default(_that.id,_that.kind,_that.title,_that.date,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CalendarItemKind kind,  String title,  DateTime date,  int? minutes)?  $default,) {final _that = this;
switch (_that) {
case _CalendarItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.date,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc


class _CalendarItem implements CalendarItem {
  const _CalendarItem({required this.id, required this.kind, required this.title, required this.date, this.minutes});
  

@override final  String id;
@override final  CalendarItemKind kind;
@override final  String title;
/// Local midnight of the day this item falls on — the grouping key.
@override final  DateTime date;
/// Minutes since midnight, or null for "all day" / "no time".
@override final  int? minutes;

/// Create a copy of CalendarItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarItemCopyWith<_CalendarItem> get copyWith => __$CalendarItemCopyWithImpl<_CalendarItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,date,minutes);

@override
String toString() {
  return 'CalendarItem(id: $id, kind: $kind, title: $title, date: $date, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$CalendarItemCopyWith<$Res> implements $CalendarItemCopyWith<$Res> {
  factory _$CalendarItemCopyWith(_CalendarItem value, $Res Function(_CalendarItem) _then) = __$CalendarItemCopyWithImpl;
@override @useResult
$Res call({
 String id, CalendarItemKind kind, String title, DateTime date, int? minutes
});




}
/// @nodoc
class __$CalendarItemCopyWithImpl<$Res>
    implements _$CalendarItemCopyWith<$Res> {
  __$CalendarItemCopyWithImpl(this._self, this._then);

  final _CalendarItem _self;
  final $Res Function(_CalendarItem) _then;

/// Create a copy of CalendarItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? date = null,Object? minutes = freezed,}) {
  return _then(_CalendarItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
