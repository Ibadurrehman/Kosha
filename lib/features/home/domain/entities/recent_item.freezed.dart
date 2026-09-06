// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecentItem {

 String get id; HomeItemKind get kind; String get title; String get subtitle; DateTime get at;
/// Create a copy of RecentItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentItemCopyWith<RecentItem> get copyWith => _$RecentItemCopyWithImpl<RecentItem>(this as RecentItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,subtitle,at);

@override
String toString() {
  return 'RecentItem(id: $id, kind: $kind, title: $title, subtitle: $subtitle, at: $at)';
}


}

/// @nodoc
abstract mixin class $RecentItemCopyWith<$Res>  {
  factory $RecentItemCopyWith(RecentItem value, $Res Function(RecentItem) _then) = _$RecentItemCopyWithImpl;
@useResult
$Res call({
 String id, HomeItemKind kind, String title, String subtitle, DateTime at
});




}
/// @nodoc
class _$RecentItemCopyWithImpl<$Res>
    implements $RecentItemCopyWith<$Res> {
  _$RecentItemCopyWithImpl(this._self, this._then);

  final RecentItem _self;
  final $Res Function(RecentItem) _then;

/// Create a copy of RecentItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? subtitle = null,Object? at = null,}) {
  return _then(RecentItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HomeItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentItem].
extension RecentItemPatterns on RecentItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentItem value)  $default,){
final _that = this;
switch (_that) {
case _RecentItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecentItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  HomeItemKind kind,  String title,  String subtitle,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.subtitle,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  HomeItemKind kind,  String title,  String subtitle,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _RecentItem():
return $default(_that.id,_that.kind,_that.title,_that.subtitle,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  HomeItemKind kind,  String title,  String subtitle,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _RecentItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.subtitle,_that.at);case _:
  return null;

}
}

}

/// @nodoc


class _RecentItem implements RecentItem {
  const _RecentItem({required this.id, required this.kind, required this.title, required this.subtitle, required this.at});
  

@override final  String id;
@override final  HomeItemKind kind;
@override final  String title;
@override final  String subtitle;
@override final  DateTime at;

/// Create a copy of RecentItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentItemCopyWith<_RecentItem> get copyWith => __$RecentItemCopyWithImpl<_RecentItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,subtitle,at);

@override
String toString() {
  return 'RecentItem(id: $id, kind: $kind, title: $title, subtitle: $subtitle, at: $at)';
}


}

/// @nodoc
abstract mixin class _$RecentItemCopyWith<$Res> implements $RecentItemCopyWith<$Res> {
  factory _$RecentItemCopyWith(_RecentItem value, $Res Function(_RecentItem) _then) = __$RecentItemCopyWithImpl;
@override @useResult
$Res call({
 String id, HomeItemKind kind, String title, String subtitle, DateTime at
});




}
/// @nodoc
class __$RecentItemCopyWithImpl<$Res>
    implements _$RecentItemCopyWith<$Res> {
  __$RecentItemCopyWithImpl(this._self, this._then);

  final _RecentItem _self;
  final $Res Function(_RecentItem) _then;

/// Create a copy of RecentItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? subtitle = null,Object? at = null,}) {
  return _then(_RecentItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HomeItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
