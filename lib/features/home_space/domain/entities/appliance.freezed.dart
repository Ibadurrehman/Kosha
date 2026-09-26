// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appliance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Appliance {

 String get id; String get name; String get spaceId; DateTime get createdAt; DateTime get updatedAt; String? get makeModel; DateTime? get purchasedOn; DateTime? get warrantyTill; DateTime? get nextServiceOn;/// The invoice, if the user filed one under Documents.
 String? get documentId; DateTime? get deletedAt;
/// Create a copy of Appliance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplianceCopyWith<Appliance> get copyWith => _$ApplianceCopyWithImpl<Appliance>(this as Appliance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appliance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.makeModel, makeModel) || other.makeModel == makeModel)&&(identical(other.purchasedOn, purchasedOn) || other.purchasedOn == purchasedOn)&&(identical(other.warrantyTill, warrantyTill) || other.warrantyTill == warrantyTill)&&(identical(other.nextServiceOn, nextServiceOn) || other.nextServiceOn == nextServiceOn)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,spaceId,createdAt,updatedAt,makeModel,purchasedOn,warrantyTill,nextServiceOn,documentId,deletedAt);

@override
String toString() {
  return 'Appliance(id: $id, name: $name, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, makeModel: $makeModel, purchasedOn: $purchasedOn, warrantyTill: $warrantyTill, nextServiceOn: $nextServiceOn, documentId: $documentId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $ApplianceCopyWith<$Res>  {
  factory $ApplianceCopyWith(Appliance value, $Res Function(Appliance) _then) = _$ApplianceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String spaceId, DateTime createdAt, DateTime updatedAt, String? makeModel, DateTime? purchasedOn, DateTime? warrantyTill, DateTime? nextServiceOn, String? documentId, DateTime? deletedAt
});




}
/// @nodoc
class _$ApplianceCopyWithImpl<$Res>
    implements $ApplianceCopyWith<$Res> {
  _$ApplianceCopyWithImpl(this._self, this._then);

  final Appliance _self;
  final $Res Function(Appliance) _then;

/// Create a copy of Appliance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? makeModel = freezed,Object? purchasedOn = freezed,Object? warrantyTill = freezed,Object? nextServiceOn = freezed,Object? documentId = freezed,Object? deletedAt = freezed,}) {
  return _then(Appliance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,makeModel: freezed == makeModel ? _self.makeModel : makeModel // ignore: cast_nullable_to_non_nullable
as String?,purchasedOn: freezed == purchasedOn ? _self.purchasedOn : purchasedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,warrantyTill: freezed == warrantyTill ? _self.warrantyTill : warrantyTill // ignore: cast_nullable_to_non_nullable
as DateTime?,nextServiceOn: freezed == nextServiceOn ? _self.nextServiceOn : nextServiceOn // ignore: cast_nullable_to_non_nullable
as DateTime?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Appliance].
extension AppliancePatterns on Appliance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appliance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appliance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appliance value)  $default,){
final _that = this;
switch (_that) {
case _Appliance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appliance value)?  $default,){
final _that = this;
switch (_that) {
case _Appliance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  String? makeModel,  DateTime? purchasedOn,  DateTime? warrantyTill,  DateTime? nextServiceOn,  String? documentId,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appliance() when $default != null:
return $default(_that.id,_that.name,_that.spaceId,_that.createdAt,_that.updatedAt,_that.makeModel,_that.purchasedOn,_that.warrantyTill,_that.nextServiceOn,_that.documentId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  String? makeModel,  DateTime? purchasedOn,  DateTime? warrantyTill,  DateTime? nextServiceOn,  String? documentId,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Appliance():
return $default(_that.id,_that.name,_that.spaceId,_that.createdAt,_that.updatedAt,_that.makeModel,_that.purchasedOn,_that.warrantyTill,_that.nextServiceOn,_that.documentId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String spaceId,  DateTime createdAt,  DateTime updatedAt,  String? makeModel,  DateTime? purchasedOn,  DateTime? warrantyTill,  DateTime? nextServiceOn,  String? documentId,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Appliance() when $default != null:
return $default(_that.id,_that.name,_that.spaceId,_that.createdAt,_that.updatedAt,_that.makeModel,_that.purchasedOn,_that.warrantyTill,_that.nextServiceOn,_that.documentId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Appliance extends Appliance {
  const _Appliance({required this.id, required this.name, required this.spaceId, required this.createdAt, required this.updatedAt, this.makeModel, this.purchasedOn, this.warrantyTill, this.nextServiceOn, this.documentId, this.deletedAt}): super._();
  

@override final  String id;
@override final  String name;
@override final  String spaceId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? makeModel;
@override final  DateTime? purchasedOn;
@override final  DateTime? warrantyTill;
@override final  DateTime? nextServiceOn;
/// The invoice, if the user filed one under Documents.
@override final  String? documentId;
@override final  DateTime? deletedAt;

/// Create a copy of Appliance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplianceCopyWith<_Appliance> get copyWith => __$ApplianceCopyWithImpl<_Appliance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appliance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.makeModel, makeModel) || other.makeModel == makeModel)&&(identical(other.purchasedOn, purchasedOn) || other.purchasedOn == purchasedOn)&&(identical(other.warrantyTill, warrantyTill) || other.warrantyTill == warrantyTill)&&(identical(other.nextServiceOn, nextServiceOn) || other.nextServiceOn == nextServiceOn)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,spaceId,createdAt,updatedAt,makeModel,purchasedOn,warrantyTill,nextServiceOn,documentId,deletedAt);

@override
String toString() {
  return 'Appliance(id: $id, name: $name, spaceId: $spaceId, createdAt: $createdAt, updatedAt: $updatedAt, makeModel: $makeModel, purchasedOn: $purchasedOn, warrantyTill: $warrantyTill, nextServiceOn: $nextServiceOn, documentId: $documentId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$ApplianceCopyWith<$Res> implements $ApplianceCopyWith<$Res> {
  factory _$ApplianceCopyWith(_Appliance value, $Res Function(_Appliance) _then) = __$ApplianceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String spaceId, DateTime createdAt, DateTime updatedAt, String? makeModel, DateTime? purchasedOn, DateTime? warrantyTill, DateTime? nextServiceOn, String? documentId, DateTime? deletedAt
});




}
/// @nodoc
class __$ApplianceCopyWithImpl<$Res>
    implements _$ApplianceCopyWith<$Res> {
  __$ApplianceCopyWithImpl(this._self, this._then);

  final _Appliance _self;
  final $Res Function(_Appliance) _then;

/// Create a copy of Appliance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? spaceId = null,Object? createdAt = null,Object? updatedAt = null,Object? makeModel = freezed,Object? purchasedOn = freezed,Object? warrantyTill = freezed,Object? nextServiceOn = freezed,Object? documentId = freezed,Object? deletedAt = freezed,}) {
  return _then(_Appliance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,makeModel: freezed == makeModel ? _self.makeModel : makeModel // ignore: cast_nullable_to_non_nullable
as String?,purchasedOn: freezed == purchasedOn ? _self.purchasedOn : purchasedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,warrantyTill: freezed == warrantyTill ? _self.warrantyTill : warrantyTill // ignore: cast_nullable_to_non_nullable
as DateTime?,nextServiceOn: freezed == nextServiceOn ? _self.nextServiceOn : nextServiceOn // ignore: cast_nullable_to_non_nullable
as DateTime?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
