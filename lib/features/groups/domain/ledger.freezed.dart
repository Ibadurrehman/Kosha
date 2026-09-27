// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LedgerBalance {

 String get memberId;/// Positive when the group owes them, negative when they owe the group.
 int get netMinor; int get paidMinor; int get shareMinor;
/// Create a copy of LedgerBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerBalanceCopyWith<LedgerBalance> get copyWith => _$LedgerBalanceCopyWithImpl<LedgerBalance>(this as LedgerBalance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerBalance&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.netMinor, netMinor) || other.netMinor == netMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.shareMinor, shareMinor) || other.shareMinor == shareMinor));
}


@override
int get hashCode => Object.hash(runtimeType,memberId,netMinor,paidMinor,shareMinor);

@override
String toString() {
  return 'LedgerBalance(memberId: $memberId, netMinor: $netMinor, paidMinor: $paidMinor, shareMinor: $shareMinor)';
}


}

/// @nodoc
abstract mixin class $LedgerBalanceCopyWith<$Res>  {
  factory $LedgerBalanceCopyWith(LedgerBalance value, $Res Function(LedgerBalance) _then) = _$LedgerBalanceCopyWithImpl;
@useResult
$Res call({
 String memberId, int netMinor, int paidMinor, int shareMinor
});




}
/// @nodoc
class _$LedgerBalanceCopyWithImpl<$Res>
    implements $LedgerBalanceCopyWith<$Res> {
  _$LedgerBalanceCopyWithImpl(this._self, this._then);

  final LedgerBalance _self;
  final $Res Function(LedgerBalance) _then;

/// Create a copy of LedgerBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? netMinor = null,Object? paidMinor = null,Object? shareMinor = null,}) {
  return _then(LedgerBalance(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,netMinor: null == netMinor ? _self.netMinor : netMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,shareMinor: null == shareMinor ? _self.shareMinor : shareMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerBalance].
extension LedgerBalancePatterns on LedgerBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerBalance value)  $default,){
final _that = this;
switch (_that) {
case _LedgerBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String memberId,  int netMinor,  int paidMinor,  int shareMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerBalance() when $default != null:
return $default(_that.memberId,_that.netMinor,_that.paidMinor,_that.shareMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String memberId,  int netMinor,  int paidMinor,  int shareMinor)  $default,) {final _that = this;
switch (_that) {
case _LedgerBalance():
return $default(_that.memberId,_that.netMinor,_that.paidMinor,_that.shareMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String memberId,  int netMinor,  int paidMinor,  int shareMinor)?  $default,) {final _that = this;
switch (_that) {
case _LedgerBalance() when $default != null:
return $default(_that.memberId,_that.netMinor,_that.paidMinor,_that.shareMinor);case _:
  return null;

}
}

}

/// @nodoc


class _LedgerBalance extends LedgerBalance {
  const _LedgerBalance({required this.memberId, required this.netMinor, required this.paidMinor, required this.shareMinor}): super._();
  

@override final  String memberId;
/// Positive when the group owes them, negative when they owe the group.
@override final  int netMinor;
@override final  int paidMinor;
@override final  int shareMinor;

/// Create a copy of LedgerBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerBalanceCopyWith<_LedgerBalance> get copyWith => __$LedgerBalanceCopyWithImpl<_LedgerBalance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerBalance&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.netMinor, netMinor) || other.netMinor == netMinor)&&(identical(other.paidMinor, paidMinor) || other.paidMinor == paidMinor)&&(identical(other.shareMinor, shareMinor) || other.shareMinor == shareMinor));
}


@override
int get hashCode => Object.hash(runtimeType,memberId,netMinor,paidMinor,shareMinor);

@override
String toString() {
  return 'LedgerBalance(memberId: $memberId, netMinor: $netMinor, paidMinor: $paidMinor, shareMinor: $shareMinor)';
}


}

/// @nodoc
abstract mixin class _$LedgerBalanceCopyWith<$Res> implements $LedgerBalanceCopyWith<$Res> {
  factory _$LedgerBalanceCopyWith(_LedgerBalance value, $Res Function(_LedgerBalance) _then) = __$LedgerBalanceCopyWithImpl;
@override @useResult
$Res call({
 String memberId, int netMinor, int paidMinor, int shareMinor
});




}
/// @nodoc
class __$LedgerBalanceCopyWithImpl<$Res>
    implements _$LedgerBalanceCopyWith<$Res> {
  __$LedgerBalanceCopyWithImpl(this._self, this._then);

  final _LedgerBalance _self;
  final $Res Function(_LedgerBalance) _then;

/// Create a copy of LedgerBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? netMinor = null,Object? paidMinor = null,Object? shareMinor = null,}) {
  return _then(_LedgerBalance(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,netMinor: null == netMinor ? _self.netMinor : netMinor // ignore: cast_nullable_to_non_nullable
as int,paidMinor: null == paidMinor ? _self.paidMinor : paidMinor // ignore: cast_nullable_to_non_nullable
as int,shareMinor: null == shareMinor ? _self.shareMinor : shareMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Transfer {

 String get fromMemberId; String get toMemberId; int get amountMinor;
/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCopyWith<Transfer> get copyWith => _$TransferCopyWithImpl<Transfer>(this as Transfer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transfer&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,fromMemberId,toMemberId,amountMinor);

@override
String toString() {
  return 'Transfer(fromMemberId: $fromMemberId, toMemberId: $toMemberId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class $TransferCopyWith<$Res>  {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) _then) = _$TransferCopyWithImpl;
@useResult
$Res call({
 String fromMemberId, String toMemberId, int amountMinor
});




}
/// @nodoc
class _$TransferCopyWithImpl<$Res>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._self, this._then);

  final Transfer _self;
  final $Res Function(Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromMemberId = null,Object? toMemberId = null,Object? amountMinor = null,}) {
  return _then(Transfer(
fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Transfer].
extension TransferPatterns on Transfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transfer value)  $default,){
final _that = this;
switch (_that) {
case _Transfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transfer value)?  $default,){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromMemberId,  String toMemberId,  int amountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.fromMemberId,_that.toMemberId,_that.amountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromMemberId,  String toMemberId,  int amountMinor)  $default,) {final _that = this;
switch (_that) {
case _Transfer():
return $default(_that.fromMemberId,_that.toMemberId,_that.amountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromMemberId,  String toMemberId,  int amountMinor)?  $default,) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.fromMemberId,_that.toMemberId,_that.amountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _Transfer extends Transfer {
  const _Transfer({required this.fromMemberId, required this.toMemberId, required this.amountMinor}): super._();
  

@override final  String fromMemberId;
@override final  String toMemberId;
@override final  int amountMinor;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCopyWith<_Transfer> get copyWith => __$TransferCopyWithImpl<_Transfer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transfer&&(identical(other.fromMemberId, fromMemberId) || other.fromMemberId == fromMemberId)&&(identical(other.toMemberId, toMemberId) || other.toMemberId == toMemberId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,fromMemberId,toMemberId,amountMinor);

@override
String toString() {
  return 'Transfer(fromMemberId: $fromMemberId, toMemberId: $toMemberId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class _$TransferCopyWith<$Res> implements $TransferCopyWith<$Res> {
  factory _$TransferCopyWith(_Transfer value, $Res Function(_Transfer) _then) = __$TransferCopyWithImpl;
@override @useResult
$Res call({
 String fromMemberId, String toMemberId, int amountMinor
});




}
/// @nodoc
class __$TransferCopyWithImpl<$Res>
    implements _$TransferCopyWith<$Res> {
  __$TransferCopyWithImpl(this._self, this._then);

  final _Transfer _self;
  final $Res Function(_Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromMemberId = null,Object? toMemberId = null,Object? amountMinor = null,}) {
  return _then(_Transfer(
fromMemberId: null == fromMemberId ? _self.fromMemberId : fromMemberId // ignore: cast_nullable_to_non_nullable
as String,toMemberId: null == toMemberId ? _self.toMemberId : toMemberId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Ledger {

 List<LedgerBalance> get balances; List<Transfer> get transfers; int get totalMinor;
/// Create a copy of Ledger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerCopyWith<Ledger> get copyWith => _$LedgerCopyWithImpl<Ledger>(this as Ledger, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ledger&&const DeepCollectionEquality().equals(other.balances, balances)&&const DeepCollectionEquality().equals(other.transfers, transfers)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(balances),const DeepCollectionEquality().hash(transfers),totalMinor);

@override
String toString() {
  return 'Ledger(balances: $balances, transfers: $transfers, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $LedgerCopyWith<$Res>  {
  factory $LedgerCopyWith(Ledger value, $Res Function(Ledger) _then) = _$LedgerCopyWithImpl;
@useResult
$Res call({
 List<LedgerBalance> balances, List<Transfer> transfers, int totalMinor
});




}
/// @nodoc
class _$LedgerCopyWithImpl<$Res>
    implements $LedgerCopyWith<$Res> {
  _$LedgerCopyWithImpl(this._self, this._then);

  final Ledger _self;
  final $Res Function(Ledger) _then;

/// Create a copy of Ledger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balances = null,Object? transfers = null,Object? totalMinor = null,}) {
  return _then(Ledger(
balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as List<LedgerBalance>,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<Transfer>,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Ledger].
extension LedgerPatterns on Ledger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ledger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ledger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ledger value)  $default,){
final _that = this;
switch (_that) {
case _Ledger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ledger value)?  $default,){
final _that = this;
switch (_that) {
case _Ledger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LedgerBalance> balances,  List<Transfer> transfers,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ledger() when $default != null:
return $default(_that.balances,_that.transfers,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LedgerBalance> balances,  List<Transfer> transfers,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _Ledger():
return $default(_that.balances,_that.transfers,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LedgerBalance> balances,  List<Transfer> transfers,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _Ledger() when $default != null:
return $default(_that.balances,_that.transfers,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc


class _Ledger extends Ledger {
  const _Ledger({required  List<LedgerBalance> balances, required  List<Transfer> transfers, required this.totalMinor}): _balances = balances,_transfers = transfers,super._();
  

 final  List<LedgerBalance> _balances;
@override List<LedgerBalance> get balances {
  if (_balances is EqualUnmodifiableListView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_balances);
}

 final  List<Transfer> _transfers;
@override List<Transfer> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

@override final  int totalMinor;

/// Create a copy of Ledger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerCopyWith<_Ledger> get copyWith => __$LedgerCopyWithImpl<_Ledger>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ledger&&const DeepCollectionEquality().equals(other._balances, _balances)&&const DeepCollectionEquality().equals(other._transfers, _transfers)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_balances),const DeepCollectionEquality().hash(_transfers),totalMinor);

@override
String toString() {
  return 'Ledger(balances: $balances, transfers: $transfers, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$LedgerCopyWith<$Res> implements $LedgerCopyWith<$Res> {
  factory _$LedgerCopyWith(_Ledger value, $Res Function(_Ledger) _then) = __$LedgerCopyWithImpl;
@override @useResult
$Res call({
 List<LedgerBalance> balances, List<Transfer> transfers, int totalMinor
});




}
/// @nodoc
class __$LedgerCopyWithImpl<$Res>
    implements _$LedgerCopyWith<$Res> {
  __$LedgerCopyWithImpl(this._self, this._then);

  final _Ledger _self;
  final $Res Function(_Ledger) _then;

/// Create a copy of Ledger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balances = null,Object? transfers = null,Object? totalMinor = null,}) {
  return _then(_Ledger(
balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as List<LedgerBalance>,transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<Transfer>,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
