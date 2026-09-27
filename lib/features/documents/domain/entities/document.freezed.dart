// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Document {

 String get id; String get name; DocumentCategory get category; DateTime get createdAt; DateTime get updatedAt;/// Passport number, policy number, account reference — whatever
/// identifies this document to the body that issued it.
 String? get number; DateTime? get issuedOn;/// Local midnight of the day it stops being valid, or null for something
/// that never expires (a degree certificate, a birth certificate).
 DateTime? get expiresOn; int get reminderOffsetDays; String? get notes; String? get spaceId;/// When the user archived it. Archiving is the only removal a document
/// has — section 6.8's actions are View file / Replace / Set reminder /
/// Archive, with no delete — so this table has no `deletedAt`, for the
/// reason ADR 0008 gives for Spaces.
 DateTime? get archivedAt;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.number, number) || other.number == number)&&(identical(other.issuedOn, issuedOn) || other.issuedOn == issuedOn)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,createdAt,updatedAt,number,issuedOn,expiresOn,reminderOffsetDays,notes,spaceId,archivedAt);

@override
String toString() {
  return 'Document(id: $id, name: $name, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, number: $number, issuedOn: $issuedOn, expiresOn: $expiresOn, reminderOffsetDays: $reminderOffsetDays, notes: $notes, spaceId: $spaceId, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String id, String name, DocumentCategory category, DateTime createdAt, DateTime updatedAt, String? number, DateTime? issuedOn, DateTime? expiresOn, int reminderOffsetDays, String? notes, String? spaceId, DateTime? archivedAt
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? createdAt = null,Object? updatedAt = null,Object? number = freezed,Object? issuedOn = freezed,Object? expiresOn = freezed,Object? reminderOffsetDays = null,Object? notes = freezed,Object? spaceId = freezed,Object? archivedAt = freezed,}) {
  return _then(Document(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DocumentCategory,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,issuedOn: freezed == issuedOn ? _self.issuedOn : issuedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DocumentCategory category,  DateTime createdAt,  DateTime updatedAt,  String? number,  DateTime? issuedOn,  DateTime? expiresOn,  int reminderOffsetDays,  String? notes,  String? spaceId,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.createdAt,_that.updatedAt,_that.number,_that.issuedOn,_that.expiresOn,_that.reminderOffsetDays,_that.notes,_that.spaceId,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DocumentCategory category,  DateTime createdAt,  DateTime updatedAt,  String? number,  DateTime? issuedOn,  DateTime? expiresOn,  int reminderOffsetDays,  String? notes,  String? spaceId,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.id,_that.name,_that.category,_that.createdAt,_that.updatedAt,_that.number,_that.issuedOn,_that.expiresOn,_that.reminderOffsetDays,_that.notes,_that.spaceId,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DocumentCategory category,  DateTime createdAt,  DateTime updatedAt,  String? number,  DateTime? issuedOn,  DateTime? expiresOn,  int reminderOffsetDays,  String? notes,  String? spaceId,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.createdAt,_that.updatedAt,_that.number,_that.issuedOn,_that.expiresOn,_that.reminderOffsetDays,_that.notes,_that.spaceId,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Document extends Document {
  const _Document({required this.id, required this.name, required this.category, required this.createdAt, required this.updatedAt, this.number, this.issuedOn, this.expiresOn, this.reminderOffsetDays = defaultDocumentReminderDays, this.notes, this.spaceId, this.archivedAt}): super._();
  

@override final  String id;
@override final  String name;
@override final  DocumentCategory category;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Passport number, policy number, account reference — whatever
/// identifies this document to the body that issued it.
@override final  String? number;
@override final  DateTime? issuedOn;
/// Local midnight of the day it stops being valid, or null for something
/// that never expires (a degree certificate, a birth certificate).
@override final  DateTime? expiresOn;
@override@JsonKey() final  int reminderOffsetDays;
@override final  String? notes;
@override final  String? spaceId;
/// When the user archived it. Archiving is the only removal a document
/// has — section 6.8's actions are View file / Replace / Set reminder /
/// Archive, with no delete — so this table has no `deletedAt`, for the
/// reason ADR 0008 gives for Spaces.
@override final  DateTime? archivedAt;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.number, number) || other.number == number)&&(identical(other.issuedOn, issuedOn) || other.issuedOn == issuedOn)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.reminderOffsetDays, reminderOffsetDays) || other.reminderOffsetDays == reminderOffsetDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,createdAt,updatedAt,number,issuedOn,expiresOn,reminderOffsetDays,notes,spaceId,archivedAt);

@override
String toString() {
  return 'Document(id: $id, name: $name, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, number: $number, issuedOn: $issuedOn, expiresOn: $expiresOn, reminderOffsetDays: $reminderOffsetDays, notes: $notes, spaceId: $spaceId, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DocumentCategory category, DateTime createdAt, DateTime updatedAt, String? number, DateTime? issuedOn, DateTime? expiresOn, int reminderOffsetDays, String? notes, String? spaceId, DateTime? archivedAt
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? createdAt = null,Object? updatedAt = null,Object? number = freezed,Object? issuedOn = freezed,Object? expiresOn = freezed,Object? reminderOffsetDays = null,Object? notes = freezed,Object? spaceId = freezed,Object? archivedAt = freezed,}) {
  return _then(_Document(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DocumentCategory,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,issuedOn: freezed == issuedOn ? _self.issuedOn : issuedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,reminderOffsetDays: null == reminderOffsetDays ? _self.reminderOffsetDays : reminderOffsetDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
