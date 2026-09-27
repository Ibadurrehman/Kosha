// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordField {

 String get key; String get label; RecordFieldType get type;/// Blocks Save in the record editor while it is empty. Named `isRequired`
/// rather than `required` only because the latter reads badly next to
/// Dart's own keyword; the JSON spelling stays `required` (§5.1).
 bool get isRequired;
/// Create a copy of RecordField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordFieldCopyWith<RecordField> get copyWith => _$RecordFieldCopyWithImpl<RecordField>(this as RecordField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,isRequired);

@override
String toString() {
  return 'RecordField(key: $key, label: $label, type: $type, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $RecordFieldCopyWith<$Res>  {
  factory $RecordFieldCopyWith(RecordField value, $Res Function(RecordField) _then) = _$RecordFieldCopyWithImpl;
@useResult
$Res call({
 String key, String label, RecordFieldType type, bool isRequired
});




}
/// @nodoc
class _$RecordFieldCopyWithImpl<$Res>
    implements $RecordFieldCopyWith<$Res> {
  _$RecordFieldCopyWithImpl(this._self, this._then);

  final RecordField _self;
  final $Res Function(RecordField) _then;

/// Create a copy of RecordField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? type = null,Object? isRequired = null,}) {
  return _then(RecordField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RecordFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordField].
extension RecordFieldPatterns on RecordField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordField value)  $default,){
final _that = this;
switch (_that) {
case _RecordField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordField value)?  $default,){
final _that = this;
switch (_that) {
case _RecordField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  RecordFieldType type,  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  RecordFieldType type,  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _RecordField():
return $default(_that.key,_that.label,_that.type,_that.isRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  RecordFieldType type,  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _RecordField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc


class _RecordField extends RecordField {
  const _RecordField({required this.key, required this.label, required this.type, this.isRequired = false}): super._();
  

@override final  String key;
@override final  String label;
@override final  RecordFieldType type;
/// Blocks Save in the record editor while it is empty. Named `isRequired`
/// rather than `required` only because the latter reads badly next to
/// Dart's own keyword; the JSON spelling stays `required` (§5.1).
@override@JsonKey() final  bool isRequired;

/// Create a copy of RecordField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordFieldCopyWith<_RecordField> get copyWith => __$RecordFieldCopyWithImpl<_RecordField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,isRequired);

@override
String toString() {
  return 'RecordField(key: $key, label: $label, type: $type, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$RecordFieldCopyWith<$Res> implements $RecordFieldCopyWith<$Res> {
  factory _$RecordFieldCopyWith(_RecordField value, $Res Function(_RecordField) _then) = __$RecordFieldCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, RecordFieldType type, bool isRequired
});




}
/// @nodoc
class __$RecordFieldCopyWithImpl<$Res>
    implements _$RecordFieldCopyWith<$Res> {
  __$RecordFieldCopyWithImpl(this._self, this._then);

  final _RecordField _self;
  final $Res Function(_RecordField) _then;

/// Create a copy of RecordField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? type = null,Object? isRequired = null,}) {
  return _then(_RecordField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RecordFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$RecordTemplate {

 String get id; String get name; String get iconKey; DateTime get createdAt; DateTime get updatedAt; List<RecordField> get fields;/// The space this record type belongs to, or null for one that stands on
/// its own in the Spaces grid. Nullable and unused by v1's screens: it is
/// the hook G29 needs to back a "Health" space's Records section without a
/// second migration, and it costs one column to leave open.
 String? get spaceId; DateTime? get deletedAt;
/// Create a copy of RecordTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordTemplateCopyWith<RecordTemplate> get copyWith => _$RecordTemplateCopyWithImpl<RecordTemplate>(this as RecordTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,createdAt,updatedAt,const DeepCollectionEquality().hash(fields),spaceId,deletedAt);

@override
String toString() {
  return 'RecordTemplate(id: $id, name: $name, iconKey: $iconKey, createdAt: $createdAt, updatedAt: $updatedAt, fields: $fields, spaceId: $spaceId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $RecordTemplateCopyWith<$Res>  {
  factory $RecordTemplateCopyWith(RecordTemplate value, $Res Function(RecordTemplate) _then) = _$RecordTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String iconKey, DateTime createdAt, DateTime updatedAt, List<RecordField> fields, String? spaceId, DateTime? deletedAt
});




}
/// @nodoc
class _$RecordTemplateCopyWithImpl<$Res>
    implements $RecordTemplateCopyWith<$Res> {
  _$RecordTemplateCopyWithImpl(this._self, this._then);

  final RecordTemplate _self;
  final $Res Function(RecordTemplate) _then;

/// Create a copy of RecordTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? createdAt = null,Object? updatedAt = null,Object? fields = null,Object? spaceId = freezed,Object? deletedAt = freezed,}) {
  return _then(RecordTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<RecordField>,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordTemplate].
extension RecordTemplatePatterns on RecordTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordTemplate value)  $default,){
final _that = this;
switch (_that) {
case _RecordTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _RecordTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String iconKey,  DateTime createdAt,  DateTime updatedAt,  List<RecordField> fields,  String? spaceId,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordTemplate() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.createdAt,_that.updatedAt,_that.fields,_that.spaceId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String iconKey,  DateTime createdAt,  DateTime updatedAt,  List<RecordField> fields,  String? spaceId,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _RecordTemplate():
return $default(_that.id,_that.name,_that.iconKey,_that.createdAt,_that.updatedAt,_that.fields,_that.spaceId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String iconKey,  DateTime createdAt,  DateTime updatedAt,  List<RecordField> fields,  String? spaceId,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecordTemplate() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.createdAt,_that.updatedAt,_that.fields,_that.spaceId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RecordTemplate extends RecordTemplate {
  const _RecordTemplate({required this.id, required this.name, required this.iconKey, required this.createdAt, required this.updatedAt,  List<RecordField> fields = const <RecordField>[], this.spaceId, this.deletedAt}): _fields = fields,super._();
  

@override final  String id;
@override final  String name;
@override final  String iconKey;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<RecordField> _fields;
@override@JsonKey() List<RecordField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

/// The space this record type belongs to, or null for one that stands on
/// its own in the Spaces grid. Nullable and unused by v1's screens: it is
/// the hook G29 needs to back a "Health" space's Records section without a
/// second migration, and it costs one column to leave open.
@override final  String? spaceId;
@override final  DateTime? deletedAt;

/// Create a copy of RecordTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordTemplateCopyWith<_RecordTemplate> get copyWith => __$RecordTemplateCopyWithImpl<_RecordTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,createdAt,updatedAt,const DeepCollectionEquality().hash(_fields),spaceId,deletedAt);

@override
String toString() {
  return 'RecordTemplate(id: $id, name: $name, iconKey: $iconKey, createdAt: $createdAt, updatedAt: $updatedAt, fields: $fields, spaceId: $spaceId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$RecordTemplateCopyWith<$Res> implements $RecordTemplateCopyWith<$Res> {
  factory _$RecordTemplateCopyWith(_RecordTemplate value, $Res Function(_RecordTemplate) _then) = __$RecordTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String iconKey, DateTime createdAt, DateTime updatedAt, List<RecordField> fields, String? spaceId, DateTime? deletedAt
});




}
/// @nodoc
class __$RecordTemplateCopyWithImpl<$Res>
    implements _$RecordTemplateCopyWith<$Res> {
  __$RecordTemplateCopyWithImpl(this._self, this._then);

  final _RecordTemplate _self;
  final $Res Function(_RecordTemplate) _then;

/// Create a copy of RecordTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? createdAt = null,Object? updatedAt = null,Object? fields = null,Object? spaceId = freezed,Object? deletedAt = freezed,}) {
  return _then(_RecordTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<RecordField>,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
