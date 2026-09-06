// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionCategory {

 String get id; String get name; CategoryKind get kind;/// Position in the manager and in the sheet's chip row, ascending.
 int get sortOrder; DateTime get createdAt; DateTime get updatedAt;/// A key from [categoryIconKeys], not a raw code point — an `IconData`
/// constant is tree-shaken by icon, so persisting one would break the
/// moment the icon stops being referenced in Dart source.
 String? get iconKey;
/// Create a copy of TransactionCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCategoryCopyWith<TransactionCategory> get copyWith => _$TransactionCategoryCopyWithImpl<TransactionCategory>(this as TransactionCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,sortOrder,createdAt,updatedAt,iconKey);

@override
String toString() {
  return 'TransactionCategory(id: $id, name: $name, kind: $kind, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, iconKey: $iconKey)';
}


}

/// @nodoc
abstract mixin class $TransactionCategoryCopyWith<$Res>  {
  factory $TransactionCategoryCopyWith(TransactionCategory value, $Res Function(TransactionCategory) _then) = _$TransactionCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, CategoryKind kind, int sortOrder, DateTime createdAt, DateTime updatedAt, String? iconKey
});




}
/// @nodoc
class _$TransactionCategoryCopyWithImpl<$Res>
    implements $TransactionCategoryCopyWith<$Res> {
  _$TransactionCategoryCopyWithImpl(this._self, this._then);

  final TransactionCategory _self;
  final $Res Function(TransactionCategory) _then;

/// Create a copy of TransactionCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,Object? iconKey = freezed,}) {
  return _then(TransactionCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CategoryKind,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionCategory].
extension TransactionCategoryPatterns on TransactionCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionCategory value)  $default,){
final _that = this;
switch (_that) {
case _TransactionCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  CategoryKind kind,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  String? iconKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionCategory() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.iconKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  CategoryKind kind,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  String? iconKey)  $default,) {final _that = this;
switch (_that) {
case _TransactionCategory():
return $default(_that.id,_that.name,_that.kind,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.iconKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  CategoryKind kind,  int sortOrder,  DateTime createdAt,  DateTime updatedAt,  String? iconKey)?  $default,) {final _that = this;
switch (_that) {
case _TransactionCategory() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.sortOrder,_that.createdAt,_that.updatedAt,_that.iconKey);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionCategory implements TransactionCategory {
  const _TransactionCategory({required this.id, required this.name, required this.kind, required this.sortOrder, required this.createdAt, required this.updatedAt, this.iconKey});
  

@override final  String id;
@override final  String name;
@override final  CategoryKind kind;
/// Position in the manager and in the sheet's chip row, ascending.
@override final  int sortOrder;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// A key from [categoryIconKeys], not a raw code point — an `IconData`
/// constant is tree-shaken by icon, so persisting one would break the
/// moment the icon stops being referenced in Dart source.
@override final  String? iconKey;

/// Create a copy of TransactionCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCategoryCopyWith<_TransactionCategory> get copyWith => __$TransactionCategoryCopyWithImpl<_TransactionCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,sortOrder,createdAt,updatedAt,iconKey);

@override
String toString() {
  return 'TransactionCategory(id: $id, name: $name, kind: $kind, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt, iconKey: $iconKey)';
}


}

/// @nodoc
abstract mixin class _$TransactionCategoryCopyWith<$Res> implements $TransactionCategoryCopyWith<$Res> {
  factory _$TransactionCategoryCopyWith(_TransactionCategory value, $Res Function(_TransactionCategory) _then) = __$TransactionCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, CategoryKind kind, int sortOrder, DateTime createdAt, DateTime updatedAt, String? iconKey
});




}
/// @nodoc
class __$TransactionCategoryCopyWithImpl<$Res>
    implements _$TransactionCategoryCopyWith<$Res> {
  __$TransactionCategoryCopyWithImpl(this._self, this._then);

  final _TransactionCategory _self;
  final $Res Function(_TransactionCategory) _then;

/// Create a copy of TransactionCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,Object? iconKey = freezed,}) {
  return _then(_TransactionCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CategoryKind,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
