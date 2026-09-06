// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 String get id;/// Integer minor units (paise) — see `core/utils/formatters.dart`'s
/// `Money`. Always positive; [type] carries the sign.
 int get amountMinor; TransactionType get type; DateTime get date; DateTime get createdAt; DateTime get updatedAt; String? get category; TransactionMethod? get method; String? get label; String? get note; String? get spaceId; String? get billId; String? get vehicleId;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.method, method) || other.method == method)&&(identical(other.label, label) || other.label == label)&&(identical(other.note, note) || other.note == note)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMinor,type,date,createdAt,updatedAt,category,method,label,note,spaceId,billId,vehicleId);

@override
String toString() {
  return 'Transaction(id: $id, amountMinor: $amountMinor, type: $type, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, method: $method, label: $label, note: $note, spaceId: $spaceId, billId: $billId, vehicleId: $vehicleId)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, int amountMinor, TransactionType type, DateTime date, DateTime createdAt, DateTime updatedAt, String? category, TransactionMethod? method, String? label, String? note, String? spaceId, String? billId, String? vehicleId
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amountMinor = null,Object? type = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? category = freezed,Object? method = freezed,Object? label = freezed,Object? note = freezed,Object? spaceId = freezed,Object? billId = freezed,Object? vehicleId = freezed,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as TransactionMethod?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int amountMinor,  TransactionType type,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? category,  TransactionMethod? method,  String? label,  String? note,  String? spaceId,  String? billId,  String? vehicleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.amountMinor,_that.type,_that.date,_that.createdAt,_that.updatedAt,_that.category,_that.method,_that.label,_that.note,_that.spaceId,_that.billId,_that.vehicleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int amountMinor,  TransactionType type,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? category,  TransactionMethod? method,  String? label,  String? note,  String? spaceId,  String? billId,  String? vehicleId)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.amountMinor,_that.type,_that.date,_that.createdAt,_that.updatedAt,_that.category,_that.method,_that.label,_that.note,_that.spaceId,_that.billId,_that.vehicleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int amountMinor,  TransactionType type,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? category,  TransactionMethod? method,  String? label,  String? note,  String? spaceId,  String? billId,  String? vehicleId)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.amountMinor,_that.type,_that.date,_that.createdAt,_that.updatedAt,_that.category,_that.method,_that.label,_that.note,_that.spaceId,_that.billId,_that.vehicleId);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.amountMinor, required this.type, required this.date, required this.createdAt, required this.updatedAt, this.category, this.method, this.label, this.note, this.spaceId, this.billId, this.vehicleId});
  

@override final  String id;
/// Integer minor units (paise) — see `core/utils/formatters.dart`'s
/// `Money`. Always positive; [type] carries the sign.
@override final  int amountMinor;
@override final  TransactionType type;
@override final  DateTime date;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? category;
@override final  TransactionMethod? method;
@override final  String? label;
@override final  String? note;
@override final  String? spaceId;
@override final  String? billId;
@override final  String? vehicleId;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.category, category) || other.category == category)&&(identical(other.method, method) || other.method == method)&&(identical(other.label, label) || other.label == label)&&(identical(other.note, note) || other.note == note)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMinor,type,date,createdAt,updatedAt,category,method,label,note,spaceId,billId,vehicleId);

@override
String toString() {
  return 'Transaction(id: $id, amountMinor: $amountMinor, type: $type, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, method: $method, label: $label, note: $note, spaceId: $spaceId, billId: $billId, vehicleId: $vehicleId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, int amountMinor, TransactionType type, DateTime date, DateTime createdAt, DateTime updatedAt, String? category, TransactionMethod? method, String? label, String? note, String? spaceId, String? billId, String? vehicleId
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amountMinor = null,Object? type = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? category = freezed,Object? method = freezed,Object? label = freezed,Object? note = freezed,Object? spaceId = freezed,Object? billId = freezed,Object? vehicleId = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as TransactionMethod?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
