// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upcoming_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpcomingItem {

 String get id; HomeItemKind get kind; String get title; DateTime get date;
/// Create a copy of UpcomingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingItemCopyWith<UpcomingItem> get copyWith => _$UpcomingItemCopyWithImpl<UpcomingItem>(this as UpcomingItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,date);

@override
String toString() {
  return 'UpcomingItem(id: $id, kind: $kind, title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class $UpcomingItemCopyWith<$Res>  {
  factory $UpcomingItemCopyWith(UpcomingItem value, $Res Function(UpcomingItem) _then) = _$UpcomingItemCopyWithImpl;
@useResult
$Res call({
 String id, HomeItemKind kind, String title, DateTime date
});




}
/// @nodoc
class _$UpcomingItemCopyWithImpl<$Res>
    implements $UpcomingItemCopyWith<$Res> {
  _$UpcomingItemCopyWithImpl(this._self, this._then);

  final UpcomingItem _self;
  final $Res Function(UpcomingItem) _then;

/// Create a copy of UpcomingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? date = null,}) {
  return _then(UpcomingItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HomeItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UpcomingItem].
extension UpcomingItemPatterns on UpcomingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpcomingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpcomingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpcomingItem value)  $default,){
final _that = this;
switch (_that) {
case _UpcomingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpcomingItem value)?  $default,){
final _that = this;
switch (_that) {
case _UpcomingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  HomeItemKind kind,  String title,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpcomingItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  HomeItemKind kind,  String title,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _UpcomingItem():
return $default(_that.id,_that.kind,_that.title,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  HomeItemKind kind,  String title,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _UpcomingItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _UpcomingItem implements UpcomingItem {
  const _UpcomingItem({required this.id, required this.kind, required this.title, required this.date});
  

@override final  String id;
@override final  HomeItemKind kind;
@override final  String title;
@override final  DateTime date;

/// Create a copy of UpcomingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpcomingItemCopyWith<_UpcomingItem> get copyWith => __$UpcomingItemCopyWithImpl<_UpcomingItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpcomingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,date);

@override
String toString() {
  return 'UpcomingItem(id: $id, kind: $kind, title: $title, date: $date)';
}


}

/// @nodoc
abstract mixin class _$UpcomingItemCopyWith<$Res> implements $UpcomingItemCopyWith<$Res> {
  factory _$UpcomingItemCopyWith(_UpcomingItem value, $Res Function(_UpcomingItem) _then) = __$UpcomingItemCopyWithImpl;
@override @useResult
$Res call({
 String id, HomeItemKind kind, String title, DateTime date
});




}
/// @nodoc
class __$UpcomingItemCopyWithImpl<$Res>
    implements _$UpcomingItemCopyWith<$Res> {
  __$UpcomingItemCopyWithImpl(this._self, this._then);

  final _UpcomingItem _self;
  final $Res Function(_UpcomingItem) _then;

/// Create a copy of UpcomingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? date = null,}) {
  return _then(_UpcomingItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HomeItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
