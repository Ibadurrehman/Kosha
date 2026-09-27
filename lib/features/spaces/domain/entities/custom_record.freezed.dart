// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomRecord {

 String get id; String get templateId; String get title; DateTime get createdAt; DateTime get updatedAt; Map<String, String> get values;/// The pill a record with no renewal date shows — "Active", "Lapsed",
/// whatever the user types. A record that *has* a renewal date derives its
/// pill instead ([recordRenewalStatus]): a stored label and a date would
/// otherwise be two sources for one pill, and the stored one goes stale.
 String? get statusLabel;/// Drives the reminder, and the only thing about a record that can change
/// on its own.
 DateTime? get renewalDate;/// A `Document` this record points at, set from a
/// [RecordFieldType.documentLink] field.
 String? get documentId; DateTime? get deletedAt;
/// Create a copy of CustomRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomRecordCopyWith<CustomRecord> get copyWith => _$CustomRecordCopyWithImpl<CustomRecord>(this as CustomRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.renewalDate, renewalDate) || other.renewalDate == renewalDate)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,templateId,title,createdAt,updatedAt,const DeepCollectionEquality().hash(values),statusLabel,renewalDate,documentId,deletedAt);

@override
String toString() {
  return 'CustomRecord(id: $id, templateId: $templateId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, values: $values, statusLabel: $statusLabel, renewalDate: $renewalDate, documentId: $documentId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $CustomRecordCopyWith<$Res>  {
  factory $CustomRecordCopyWith(CustomRecord value, $Res Function(CustomRecord) _then) = _$CustomRecordCopyWithImpl;
@useResult
$Res call({
 String id, String templateId, String title, DateTime createdAt, DateTime updatedAt, Map<String, String> values, String? statusLabel, DateTime? renewalDate, String? documentId, DateTime? deletedAt
});




}
/// @nodoc
class _$CustomRecordCopyWithImpl<$Res>
    implements $CustomRecordCopyWith<$Res> {
  _$CustomRecordCopyWithImpl(this._self, this._then);

  final CustomRecord _self;
  final $Res Function(CustomRecord) _then;

/// Create a copy of CustomRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? templateId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? values = null,Object? statusLabel = freezed,Object? renewalDate = freezed,Object? documentId = freezed,Object? deletedAt = freezed,}) {
  return _then(CustomRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,renewalDate: freezed == renewalDate ? _self.renewalDate : renewalDate // ignore: cast_nullable_to_non_nullable
as DateTime?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomRecord].
extension CustomRecordPatterns on CustomRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomRecord value)  $default,){
final _that = this;
switch (_that) {
case _CustomRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CustomRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String templateId,  String title,  DateTime createdAt,  DateTime updatedAt,  Map<String, String> values,  String? statusLabel,  DateTime? renewalDate,  String? documentId,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomRecord() when $default != null:
return $default(_that.id,_that.templateId,_that.title,_that.createdAt,_that.updatedAt,_that.values,_that.statusLabel,_that.renewalDate,_that.documentId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String templateId,  String title,  DateTime createdAt,  DateTime updatedAt,  Map<String, String> values,  String? statusLabel,  DateTime? renewalDate,  String? documentId,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomRecord():
return $default(_that.id,_that.templateId,_that.title,_that.createdAt,_that.updatedAt,_that.values,_that.statusLabel,_that.renewalDate,_that.documentId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String templateId,  String title,  DateTime createdAt,  DateTime updatedAt,  Map<String, String> values,  String? statusLabel,  DateTime? renewalDate,  String? documentId,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomRecord() when $default != null:
return $default(_that.id,_that.templateId,_that.title,_that.createdAt,_that.updatedAt,_that.values,_that.statusLabel,_that.renewalDate,_that.documentId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CustomRecord extends CustomRecord {
  const _CustomRecord({required this.id, required this.templateId, required this.title, required this.createdAt, required this.updatedAt,  Map<String, String> values = const <String, String>{}, this.statusLabel, this.renewalDate, this.documentId, this.deletedAt}): _values = values,super._();
  

@override final  String id;
@override final  String templateId;
@override final  String title;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  Map<String, String> _values;
@override@JsonKey() Map<String, String> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}

/// The pill a record with no renewal date shows — "Active", "Lapsed",
/// whatever the user types. A record that *has* a renewal date derives its
/// pill instead ([recordRenewalStatus]): a stored label and a date would
/// otherwise be two sources for one pill, and the stored one goes stale.
@override final  String? statusLabel;
/// Drives the reminder, and the only thing about a record that can change
/// on its own.
@override final  DateTime? renewalDate;
/// A `Document` this record points at, set from a
/// [RecordFieldType.documentLink] field.
@override final  String? documentId;
@override final  DateTime? deletedAt;

/// Create a copy of CustomRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomRecordCopyWith<_CustomRecord> get copyWith => __$CustomRecordCopyWithImpl<_CustomRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._values, _values)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.renewalDate, renewalDate) || other.renewalDate == renewalDate)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,templateId,title,createdAt,updatedAt,const DeepCollectionEquality().hash(_values),statusLabel,renewalDate,documentId,deletedAt);

@override
String toString() {
  return 'CustomRecord(id: $id, templateId: $templateId, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, values: $values, statusLabel: $statusLabel, renewalDate: $renewalDate, documentId: $documentId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomRecordCopyWith<$Res> implements $CustomRecordCopyWith<$Res> {
  factory _$CustomRecordCopyWith(_CustomRecord value, $Res Function(_CustomRecord) _then) = __$CustomRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String templateId, String title, DateTime createdAt, DateTime updatedAt, Map<String, String> values, String? statusLabel, DateTime? renewalDate, String? documentId, DateTime? deletedAt
});




}
/// @nodoc
class __$CustomRecordCopyWithImpl<$Res>
    implements _$CustomRecordCopyWith<$Res> {
  __$CustomRecordCopyWithImpl(this._self, this._then);

  final _CustomRecord _self;
  final $Res Function(_CustomRecord) _then;

/// Create a copy of CustomRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? templateId = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? values = null,Object? statusLabel = freezed,Object? renewalDate = freezed,Object? documentId = freezed,Object? deletedAt = freezed,}) {
  return _then(_CustomRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,renewalDate: freezed == renewalDate ? _self.renewalDate : renewalDate // ignore: cast_nullable_to_non_nullable
as DateTime?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
