// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpaceSummary {

 int get openTasks; int get bills;/// Expenses dated inside the current calendar month, in paise.
 int get spentThisMonthMinor;
/// Create a copy of SpaceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceSummaryCopyWith<SpaceSummary> get copyWith => _$SpaceSummaryCopyWithImpl<SpaceSummary>(this as SpaceSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceSummary&&(identical(other.openTasks, openTasks) || other.openTasks == openTasks)&&(identical(other.bills, bills) || other.bills == bills)&&(identical(other.spentThisMonthMinor, spentThisMonthMinor) || other.spentThisMonthMinor == spentThisMonthMinor));
}


@override
int get hashCode => Object.hash(runtimeType,openTasks,bills,spentThisMonthMinor);

@override
String toString() {
  return 'SpaceSummary(openTasks: $openTasks, bills: $bills, spentThisMonthMinor: $spentThisMonthMinor)';
}


}

/// @nodoc
abstract mixin class $SpaceSummaryCopyWith<$Res>  {
  factory $SpaceSummaryCopyWith(SpaceSummary value, $Res Function(SpaceSummary) _then) = _$SpaceSummaryCopyWithImpl;
@useResult
$Res call({
 int openTasks, int bills, int spentThisMonthMinor
});




}
/// @nodoc
class _$SpaceSummaryCopyWithImpl<$Res>
    implements $SpaceSummaryCopyWith<$Res> {
  _$SpaceSummaryCopyWithImpl(this._self, this._then);

  final SpaceSummary _self;
  final $Res Function(SpaceSummary) _then;

/// Create a copy of SpaceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openTasks = null,Object? bills = null,Object? spentThisMonthMinor = null,}) {
  return _then(SpaceSummary(
openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,bills: null == bills ? _self.bills : bills // ignore: cast_nullable_to_non_nullable
as int,spentThisMonthMinor: null == spentThisMonthMinor ? _self.spentThisMonthMinor : spentThisMonthMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceSummary].
extension SpaceSummaryPatterns on SpaceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceSummary value)  $default,){
final _that = this;
switch (_that) {
case _SpaceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int openTasks,  int bills,  int spentThisMonthMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceSummary() when $default != null:
return $default(_that.openTasks,_that.bills,_that.spentThisMonthMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int openTasks,  int bills,  int spentThisMonthMinor)  $default,) {final _that = this;
switch (_that) {
case _SpaceSummary():
return $default(_that.openTasks,_that.bills,_that.spentThisMonthMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int openTasks,  int bills,  int spentThisMonthMinor)?  $default,) {final _that = this;
switch (_that) {
case _SpaceSummary() when $default != null:
return $default(_that.openTasks,_that.bills,_that.spentThisMonthMinor);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceSummary extends SpaceSummary {
  const _SpaceSummary({this.openTasks = 0, this.bills = 0, this.spentThisMonthMinor = 0}): super._();
  

@override@JsonKey() final  int openTasks;
@override@JsonKey() final  int bills;
/// Expenses dated inside the current calendar month, in paise.
@override@JsonKey() final  int spentThisMonthMinor;

/// Create a copy of SpaceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceSummaryCopyWith<_SpaceSummary> get copyWith => __$SpaceSummaryCopyWithImpl<_SpaceSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceSummary&&(identical(other.openTasks, openTasks) || other.openTasks == openTasks)&&(identical(other.bills, bills) || other.bills == bills)&&(identical(other.spentThisMonthMinor, spentThisMonthMinor) || other.spentThisMonthMinor == spentThisMonthMinor));
}


@override
int get hashCode => Object.hash(runtimeType,openTasks,bills,spentThisMonthMinor);

@override
String toString() {
  return 'SpaceSummary(openTasks: $openTasks, bills: $bills, spentThisMonthMinor: $spentThisMonthMinor)';
}


}

/// @nodoc
abstract mixin class _$SpaceSummaryCopyWith<$Res> implements $SpaceSummaryCopyWith<$Res> {
  factory _$SpaceSummaryCopyWith(_SpaceSummary value, $Res Function(_SpaceSummary) _then) = __$SpaceSummaryCopyWithImpl;
@override @useResult
$Res call({
 int openTasks, int bills, int spentThisMonthMinor
});




}
/// @nodoc
class __$SpaceSummaryCopyWithImpl<$Res>
    implements _$SpaceSummaryCopyWith<$Res> {
  __$SpaceSummaryCopyWithImpl(this._self, this._then);

  final _SpaceSummary _self;
  final $Res Function(_SpaceSummary) _then;

/// Create a copy of SpaceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openTasks = null,Object? bills = null,Object? spentThisMonthMinor = null,}) {
  return _then(_SpaceSummary(
openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,bills: null == bills ? _self.bills : bills // ignore: cast_nullable_to_non_nullable
as int,spentThisMonthMinor: null == spentThisMonthMinor ? _self.spentThisMonthMinor : spentThisMonthMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
