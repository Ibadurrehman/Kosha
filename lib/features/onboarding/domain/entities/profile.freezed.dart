// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Profile {

 String get id; String get name; String get avatarInitials; DateTime get joinedAt; DateTime get createdAt; DateTime get updatedAt; String? get email; String get currency; String get dateFormat;/// 1 = Monday, matching `DateTime.weekday`.
 int get weekStart; String get locale; bool get onboardingCompleted;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarInitials, avatarInitials) || other.avatarInitials == avatarInitials)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarInitials,joinedAt,createdAt,updatedAt,email,currency,dateFormat,weekStart,locale,onboardingCompleted);

@override
String toString() {
  return 'Profile(id: $id, name: $name, avatarInitials: $avatarInitials, joinedAt: $joinedAt, createdAt: $createdAt, updatedAt: $updatedAt, email: $email, currency: $currency, dateFormat: $dateFormat, weekStart: $weekStart, locale: $locale, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String avatarInitials, DateTime joinedAt, DateTime createdAt, DateTime updatedAt, String? email, String currency, String dateFormat, int weekStart, String locale, bool onboardingCompleted
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarInitials = null,Object? joinedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? email = freezed,Object? currency = null,Object? dateFormat = null,Object? weekStart = null,Object? locale = null,Object? onboardingCompleted = null,}) {
  return _then(Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarInitials: null == avatarInitials ? _self.avatarInitials : avatarInitials // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String avatarInitials,  DateTime joinedAt,  DateTime createdAt,  DateTime updatedAt,  String? email,  String currency,  String dateFormat,  int weekStart,  String locale,  bool onboardingCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.avatarInitials,_that.joinedAt,_that.createdAt,_that.updatedAt,_that.email,_that.currency,_that.dateFormat,_that.weekStart,_that.locale,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String avatarInitials,  DateTime joinedAt,  DateTime createdAt,  DateTime updatedAt,  String? email,  String currency,  String dateFormat,  int weekStart,  String locale,  bool onboardingCompleted)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.name,_that.avatarInitials,_that.joinedAt,_that.createdAt,_that.updatedAt,_that.email,_that.currency,_that.dateFormat,_that.weekStart,_that.locale,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String avatarInitials,  DateTime joinedAt,  DateTime createdAt,  DateTime updatedAt,  String? email,  String currency,  String dateFormat,  int weekStart,  String locale,  bool onboardingCompleted)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.avatarInitials,_that.joinedAt,_that.createdAt,_that.updatedAt,_that.email,_that.currency,_that.dateFormat,_that.weekStart,_that.locale,_that.onboardingCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _Profile implements Profile {
  const _Profile({required this.id, required this.name, required this.avatarInitials, required this.joinedAt, required this.createdAt, required this.updatedAt, this.email, this.currency = 'INR', this.dateFormat = 'd MMM yyyy', this.weekStart = 1, this.locale = 'en', this.onboardingCompleted = false});
  

@override final  String id;
@override final  String name;
@override final  String avatarInitials;
@override final  DateTime joinedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? email;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String dateFormat;
/// 1 = Monday, matching `DateTime.weekday`.
@override@JsonKey() final  int weekStart;
@override@JsonKey() final  String locale;
@override@JsonKey() final  bool onboardingCompleted;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarInitials, avatarInitials) || other.avatarInitials == avatarInitials)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarInitials,joinedAt,createdAt,updatedAt,email,currency,dateFormat,weekStart,locale,onboardingCompleted);

@override
String toString() {
  return 'Profile(id: $id, name: $name, avatarInitials: $avatarInitials, joinedAt: $joinedAt, createdAt: $createdAt, updatedAt: $updatedAt, email: $email, currency: $currency, dateFormat: $dateFormat, weekStart: $weekStart, locale: $locale, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String avatarInitials, DateTime joinedAt, DateTime createdAt, DateTime updatedAt, String? email, String currency, String dateFormat, int weekStart, String locale, bool onboardingCompleted
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarInitials = null,Object? joinedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? email = freezed,Object? currency = null,Object? dateFormat = null,Object? weekStart = null,Object? locale = null,Object? onboardingCompleted = null,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarInitials: null == avatarInitials ? _self.avatarInitials : avatarInitials // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
