// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Space {

 String get id; String get name; SpaceKind get kind; Set<SpaceHolds> get holds;/// Position in the Spaces grid, ascending.
 int get sortOrder; DateTime get createdAt; DateTime get updatedAt;/// Set for [SpaceKind.system] rows, null for user-made ones.
 SystemSpace? get systemKey;/// A key from [spaceIconKeys]; null falls back to the folder icon.
 String? get iconKey;/// When the user archived it. Archiving *is* deletion here — see the
/// table's doc comment.
 DateTime? get archivedAt;
/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceCopyWith<Space> get copyWith => _$SpaceCopyWithImpl<Space>(this as Space, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Space&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.holds, holds)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.systemKey, systemKey) || other.systemKey == systemKey)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,const DeepCollectionEquality().hash(holds),sortOrder,createdAt,updatedAt,systemKey,iconKey,archivedAt);

@override
String toString() {
  return 'Space(id: $id, name: $name, kind: $kind, holds: $holds, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, systemKey: $systemKey, iconKey: $iconKey, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $SpaceCopyWith<$Res>  {
  factory $SpaceCopyWith(Space value, $Res Function(Space) _then) = _$SpaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, SpaceKind kind, Set<SpaceHolds> holds, int sortOrder, DateTime createdAt, DateTime updatedAt, SystemSpace? systemKey, String? iconKey, DateTime? archivedAt
});




}
/// @nodoc
class _$SpaceCopyWithImpl<$Res>
    implements $SpaceCopyWith<$Res> {
  _$SpaceCopyWithImpl(this._self, this._then);

  final Space _self;
  final $Res Function(Space) _then;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? holds = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,Object? systemKey = freezed,Object? iconKey = freezed,Object? archivedAt = freezed,}) {
  return _then(Space(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpaceKind,holds: null == holds ? _self.holds : holds // ignore: cast_nullable_to_non_nullable
as Set<SpaceHolds>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,systemKey: freezed == systemKey ? _self.systemKey : systemKey // ignore: cast_nullable_to_non_nullable
as SystemSpace?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Space].
extension SpacePatterns on Space {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Space value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Space() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Space value)  $default,){
final _that = this;
switch (_that) {
case _Space():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Space value)?  $default,){
final _that = this;
switch (_that) {
case _Space() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  SpaceKind kind,  Set<SpaceHolds> holds,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  SystemSpace? systemKey,  String? iconKey,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.holds,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.systemKey,_that.iconKey,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  SpaceKind kind,  Set<SpaceHolds> holds,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  SystemSpace? systemKey,  String? iconKey,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Space():
return $default(_that.id,_that.name,_that.kind,_that.holds,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.systemKey,_that.iconKey,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  SpaceKind kind,  Set<SpaceHolds> holds,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  SystemSpace? systemKey,  String? iconKey,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.holds,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.systemKey,_that.iconKey,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Space extends Space {
  const _Space({required this.id, required this.name, required this.kind, required  Set<SpaceHolds> holds, required this.sortOrder, required this.createdAt, required this.updatedAt, this.systemKey, this.iconKey, this.archivedAt}): _holds = holds,super._();
  

@override final  String id;
@override final  String name;
@override final  SpaceKind kind;
 final  Set<SpaceHolds> _holds;
@override Set<SpaceHolds> get holds {
  if (_holds is EqualUnmodifiableSetView) return _holds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_holds);
}

/// Position in the Spaces grid, ascending.
@override final  int sortOrder;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Set for [SpaceKind.system] rows, null for user-made ones.
@override final  SystemSpace? systemKey;
/// A key from [spaceIconKeys]; null falls back to the folder icon.
@override final  String? iconKey;
/// When the user archived it. Archiving *is* deletion here — see the
/// table's doc comment.
@override final  DateTime? archivedAt;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceCopyWith<_Space> get copyWith => __$SpaceCopyWithImpl<_Space>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Space&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other._holds, _holds)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.systemKey, systemKey) || other.systemKey == systemKey)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,const DeepCollectionEquality().hash(_holds),sortOrder,createdAt,updatedAt,systemKey,iconKey,archivedAt);

@override
String toString() {
  return 'Space(id: $id, name: $name, kind: $kind, holds: $holds, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, systemKey: $systemKey, iconKey: $iconKey, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$SpaceCopyWith<$Res> implements $SpaceCopyWith<$Res> {
  factory _$SpaceCopyWith(_Space value, $Res Function(_Space) _then) = __$SpaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, SpaceKind kind, Set<SpaceHolds> holds, int sortOrder, DateTime createdAt, DateTime updatedAt, SystemSpace? systemKey, String? iconKey, DateTime? archivedAt
});




}
/// @nodoc
class __$SpaceCopyWithImpl<$Res>
    implements _$SpaceCopyWith<$Res> {
  __$SpaceCopyWithImpl(this._self, this._then);

  final _Space _self;
  final $Res Function(_Space) _then;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? holds = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,Object? systemKey = freezed,Object? iconKey = freezed,Object? archivedAt = freezed,}) {
  return _then(_Space(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpaceKind,holds: null == holds ? _self._holds : holds // ignore: cast_nullable_to_non_nullable
as Set<SpaceHolds>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,systemKey: freezed == systemKey ? _self.systemKey : systemKey // ignore: cast_nullable_to_non_nullable
as SystemSpace?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
