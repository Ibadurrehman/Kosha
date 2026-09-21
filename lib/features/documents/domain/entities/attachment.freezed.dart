// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Attachment {

 String get id; String get ownerType; String get ownerId;/// What to call the file in the UI and in a share sheet — the name the
/// user's file had, or one built for a scan ("Passport scan.pdf").
 String get fileName; String get mime; int get sizeBytes;/// Relative to the attachments directory, e.g. `a1b2c3.pdf`.
 String get relativePath; DateTime get createdAt;/// Hex sha256 of the bytes, for the dedupe §8.4 asks for. Null for a file
/// written before hashing, never for one this app wrote.
 String? get sha256;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerType, ownerType) || other.ownerType == ownerType)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerType,ownerId,fileName,mime,sizeBytes,relativePath,createdAt,sha256);

@override
String toString() {
  return 'Attachment(id: $id, ownerType: $ownerType, ownerId: $ownerId, fileName: $fileName, mime: $mime, sizeBytes: $sizeBytes, relativePath: $relativePath, createdAt: $createdAt, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 String id, String ownerType, String ownerId, String fileName, String mime, int sizeBytes, String relativePath, DateTime createdAt, String? sha256
});




}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerType = null,Object? ownerId = null,Object? fileName = null,Object? mime = null,Object? sizeBytes = null,Object? relativePath = null,Object? createdAt = null,Object? sha256 = freezed,}) {
  return _then(Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerType: null == ownerType ? _self.ownerType : ownerType // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,relativePath: null == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerType,  String ownerId,  String fileName,  String mime,  int sizeBytes,  String relativePath,  DateTime createdAt,  String? sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.ownerType,_that.ownerId,_that.fileName,_that.mime,_that.sizeBytes,_that.relativePath,_that.createdAt,_that.sha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerType,  String ownerId,  String fileName,  String mime,  int sizeBytes,  String relativePath,  DateTime createdAt,  String? sha256)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.id,_that.ownerType,_that.ownerId,_that.fileName,_that.mime,_that.sizeBytes,_that.relativePath,_that.createdAt,_that.sha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerType,  String ownerId,  String fileName,  String mime,  int sizeBytes,  String relativePath,  DateTime createdAt,  String? sha256)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.ownerType,_that.ownerId,_that.fileName,_that.mime,_that.sizeBytes,_that.relativePath,_that.createdAt,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc


class _Attachment extends Attachment {
  const _Attachment({required this.id, required this.ownerType, required this.ownerId, required this.fileName, required this.mime, required this.sizeBytes, required this.relativePath, required this.createdAt, this.sha256}): super._();
  

@override final  String id;
@override final  String ownerType;
@override final  String ownerId;
/// What to call the file in the UI and in a share sheet — the name the
/// user's file had, or one built for a scan ("Passport scan.pdf").
@override final  String fileName;
@override final  String mime;
@override final  int sizeBytes;
/// Relative to the attachments directory, e.g. `a1b2c3.pdf`.
@override final  String relativePath;
@override final  DateTime createdAt;
/// Hex sha256 of the bytes, for the dedupe §8.4 asks for. Null for a file
/// written before hashing, never for one this app wrote.
@override final  String? sha256;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerType, ownerType) || other.ownerType == ownerType)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.relativePath, relativePath) || other.relativePath == relativePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerType,ownerId,fileName,mime,sizeBytes,relativePath,createdAt,sha256);

@override
String toString() {
  return 'Attachment(id: $id, ownerType: $ownerType, ownerId: $ownerId, fileName: $fileName, mime: $mime, sizeBytes: $sizeBytes, relativePath: $relativePath, createdAt: $createdAt, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerType, String ownerId, String fileName, String mime, int sizeBytes, String relativePath, DateTime createdAt, String? sha256
});




}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerType = null,Object? ownerId = null,Object? fileName = null,Object? mime = null,Object? sizeBytes = null,Object? relativePath = null,Object? createdAt = null,Object? sha256 = freezed,}) {
  return _then(_Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerType: null == ownerType ? _self.ownerType : ownerType // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,relativePath: null == relativePath ? _self.relativePath : relativePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sha256: freezed == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
