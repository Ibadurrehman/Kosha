// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SharedExpense {

 String get id; String get groupId; String get label;/// Minor units, the way every other amount in the app is stored.
 int get amountMinor; String get paidByMemberId; DateTime get date; DateTime get createdAt; DateTime get updatedAt; SplitMode get splitMode; String get iconKey;/// The Finance transaction this expense also wrote, if any. Null in v1:
/// a shared expense is money moved between friends, not household
/// spending, and §6.14 never asks for one. The column is §5.1's.
 String? get transactionId; DateTime? get deletedAt;
/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedExpenseCopyWith<SharedExpense> get copyWith => _$SharedExpenseCopyWithImpl<SharedExpense>(this as SharedExpense, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidByMemberId, paidByMemberId) || other.paidByMemberId == paidByMemberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.splitMode, splitMode) || other.splitMode == splitMode)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,label,amountMinor,paidByMemberId,date,createdAt,updatedAt,splitMode,iconKey,transactionId,deletedAt);

@override
String toString() {
  return 'SharedExpense(id: $id, groupId: $groupId, label: $label, amountMinor: $amountMinor, paidByMemberId: $paidByMemberId, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, splitMode: $splitMode, iconKey: $iconKey, transactionId: $transactionId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $SharedExpenseCopyWith<$Res>  {
  factory $SharedExpenseCopyWith(SharedExpense value, $Res Function(SharedExpense) _then) = _$SharedExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String label, int amountMinor, String paidByMemberId, DateTime date, DateTime createdAt, DateTime updatedAt, SplitMode splitMode, String iconKey, String? transactionId, DateTime? deletedAt
});




}
/// @nodoc
class _$SharedExpenseCopyWithImpl<$Res>
    implements $SharedExpenseCopyWith<$Res> {
  _$SharedExpenseCopyWithImpl(this._self, this._then);

  final SharedExpense _self;
  final $Res Function(SharedExpense) _then;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? label = null,Object? amountMinor = null,Object? paidByMemberId = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? splitMode = null,Object? iconKey = null,Object? transactionId = freezed,Object? deletedAt = freezed,}) {
  return _then(SharedExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidByMemberId: null == paidByMemberId ? _self.paidByMemberId : paidByMemberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,splitMode: null == splitMode ? _self.splitMode : splitMode // ignore: cast_nullable_to_non_nullable
as SplitMode,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedExpense].
extension SharedExpensePatterns on SharedExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedExpense value)  $default,){
final _that = this;
switch (_that) {
case _SharedExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedExpense value)?  $default,){
final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String label,  int amountMinor,  String paidByMemberId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  SplitMode splitMode,  String iconKey,  String? transactionId,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that.id,_that.groupId,_that.label,_that.amountMinor,_that.paidByMemberId,_that.date,_that.createdAt,_that.updatedAt,_that.splitMode,_that.iconKey,_that.transactionId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String label,  int amountMinor,  String paidByMemberId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  SplitMode splitMode,  String iconKey,  String? transactionId,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _SharedExpense():
return $default(_that.id,_that.groupId,_that.label,_that.amountMinor,_that.paidByMemberId,_that.date,_that.createdAt,_that.updatedAt,_that.splitMode,_that.iconKey,_that.transactionId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String label,  int amountMinor,  String paidByMemberId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  SplitMode splitMode,  String iconKey,  String? transactionId,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that.id,_that.groupId,_that.label,_that.amountMinor,_that.paidByMemberId,_that.date,_that.createdAt,_that.updatedAt,_that.splitMode,_that.iconKey,_that.transactionId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SharedExpense extends SharedExpense {
  const _SharedExpense({required this.id, required this.groupId, required this.label, required this.amountMinor, required this.paidByMemberId, required this.date, required this.createdAt, required this.updatedAt, this.splitMode = SplitMode.equally, this.iconKey = 'receipt_long', this.transactionId, this.deletedAt}): super._();
  

@override final  String id;
@override final  String groupId;
@override final  String label;
/// Minor units, the way every other amount in the app is stored.
@override final  int amountMinor;
@override final  String paidByMemberId;
@override final  DateTime date;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SplitMode splitMode;
@override@JsonKey() final  String iconKey;
/// The Finance transaction this expense also wrote, if any. Null in v1:
/// a shared expense is money moved between friends, not household
/// spending, and §6.14 never asks for one. The column is §5.1's.
@override final  String? transactionId;
@override final  DateTime? deletedAt;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedExpenseCopyWith<_SharedExpense> get copyWith => __$SharedExpenseCopyWithImpl<_SharedExpense>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.paidByMemberId, paidByMemberId) || other.paidByMemberId == paidByMemberId)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.splitMode, splitMode) || other.splitMode == splitMode)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,label,amountMinor,paidByMemberId,date,createdAt,updatedAt,splitMode,iconKey,transactionId,deletedAt);

@override
String toString() {
  return 'SharedExpense(id: $id, groupId: $groupId, label: $label, amountMinor: $amountMinor, paidByMemberId: $paidByMemberId, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, splitMode: $splitMode, iconKey: $iconKey, transactionId: $transactionId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$SharedExpenseCopyWith<$Res> implements $SharedExpenseCopyWith<$Res> {
  factory _$SharedExpenseCopyWith(_SharedExpense value, $Res Function(_SharedExpense) _then) = __$SharedExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String label, int amountMinor, String paidByMemberId, DateTime date, DateTime createdAt, DateTime updatedAt, SplitMode splitMode, String iconKey, String? transactionId, DateTime? deletedAt
});




}
/// @nodoc
class __$SharedExpenseCopyWithImpl<$Res>
    implements _$SharedExpenseCopyWith<$Res> {
  __$SharedExpenseCopyWithImpl(this._self, this._then);

  final _SharedExpense _self;
  final $Res Function(_SharedExpense) _then;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? label = null,Object? amountMinor = null,Object? paidByMemberId = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? splitMode = null,Object? iconKey = null,Object? transactionId = freezed,Object? deletedAt = freezed,}) {
  return _then(_SharedExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,paidByMemberId: null == paidByMemberId ? _self.paidByMemberId : paidByMemberId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,splitMode: null == splitMode ? _self.splitMode : splitMode // ignore: cast_nullable_to_non_nullable
as SplitMode,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ExpenseShare {

 String get id; String get sharedExpenseId; String get memberId; int get amountMinor;
/// Create a copy of ExpenseShare
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseShareCopyWith<ExpenseShare> get copyWith => _$ExpenseShareCopyWithImpl<ExpenseShare>(this as ExpenseShare, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseShare&&(identical(other.id, id) || other.id == id)&&(identical(other.sharedExpenseId, sharedExpenseId) || other.sharedExpenseId == sharedExpenseId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,sharedExpenseId,memberId,amountMinor);

@override
String toString() {
  return 'ExpenseShare(id: $id, sharedExpenseId: $sharedExpenseId, memberId: $memberId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class $ExpenseShareCopyWith<$Res>  {
  factory $ExpenseShareCopyWith(ExpenseShare value, $Res Function(ExpenseShare) _then) = _$ExpenseShareCopyWithImpl;
@useResult
$Res call({
 String id, String sharedExpenseId, String memberId, int amountMinor
});




}
/// @nodoc
class _$ExpenseShareCopyWithImpl<$Res>
    implements $ExpenseShareCopyWith<$Res> {
  _$ExpenseShareCopyWithImpl(this._self, this._then);

  final ExpenseShare _self;
  final $Res Function(ExpenseShare) _then;

/// Create a copy of ExpenseShare
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sharedExpenseId = null,Object? memberId = null,Object? amountMinor = null,}) {
  return _then(ExpenseShare(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sharedExpenseId: null == sharedExpenseId ? _self.sharedExpenseId : sharedExpenseId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseShare].
extension ExpenseSharePatterns on ExpenseShare {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseShare value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseShare() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseShare value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseShare():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseShare value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseShare() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sharedExpenseId,  String memberId,  int amountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseShare() when $default != null:
return $default(_that.id,_that.sharedExpenseId,_that.memberId,_that.amountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sharedExpenseId,  String memberId,  int amountMinor)  $default,) {final _that = this;
switch (_that) {
case _ExpenseShare():
return $default(_that.id,_that.sharedExpenseId,_that.memberId,_that.amountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sharedExpenseId,  String memberId,  int amountMinor)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseShare() when $default != null:
return $default(_that.id,_that.sharedExpenseId,_that.memberId,_that.amountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseShare extends ExpenseShare {
  const _ExpenseShare({required this.id, required this.sharedExpenseId, required this.memberId, required this.amountMinor}): super._();
  

@override final  String id;
@override final  String sharedExpenseId;
@override final  String memberId;
@override final  int amountMinor;

/// Create a copy of ExpenseShare
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseShareCopyWith<_ExpenseShare> get copyWith => __$ExpenseShareCopyWithImpl<_ExpenseShare>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseShare&&(identical(other.id, id) || other.id == id)&&(identical(other.sharedExpenseId, sharedExpenseId) || other.sharedExpenseId == sharedExpenseId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,sharedExpenseId,memberId,amountMinor);

@override
String toString() {
  return 'ExpenseShare(id: $id, sharedExpenseId: $sharedExpenseId, memberId: $memberId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class _$ExpenseShareCopyWith<$Res> implements $ExpenseShareCopyWith<$Res> {
  factory _$ExpenseShareCopyWith(_ExpenseShare value, $Res Function(_ExpenseShare) _then) = __$ExpenseShareCopyWithImpl;
@override @useResult
$Res call({
 String id, String sharedExpenseId, String memberId, int amountMinor
});




}
/// @nodoc
class __$ExpenseShareCopyWithImpl<$Res>
    implements _$ExpenseShareCopyWith<$Res> {
  __$ExpenseShareCopyWithImpl(this._self, this._then);

  final _ExpenseShare _self;
  final $Res Function(_ExpenseShare) _then;

/// Create a copy of ExpenseShare
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sharedExpenseId = null,Object? memberId = null,Object? amountMinor = null,}) {
  return _then(_ExpenseShare(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sharedExpenseId: null == sharedExpenseId ? _self.sharedExpenseId : sharedExpenseId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
