// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupMember {

 String get id; String get groupId; String get displayName; DateTime get createdAt; DateTime get updatedAt;/// Two letters, shown white on [colourIndex]'s fill.
 String get initials;/// An index into `KoshaColors.avatarTones`, not a colour.
///
/// The four tones are fixed and theme-independent (§7.1) so white initials
/// keep 4.5:1 in both themes. Storing the index rather than the value is
/// the same indirection `Space.iconKey` uses: a stored 0xFF415DB7 would
/// freeze today's palette into every old row.
 int get colourIndex; MemberRole get role;/// The local profile this member *is*, once there is an account behind
/// them (Phase 5). Null for every member v1 creates except "You".
 String? get profileId; String? get inviteToken; DateTime? get deletedAt;
/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberCopyWith<GroupMember> get copyWith => _$GroupMemberCopyWithImpl<GroupMember>(this as GroupMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMember&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.colourIndex, colourIndex) || other.colourIndex == colourIndex)&&(identical(other.role, role) || other.role == role)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.inviteToken, inviteToken) || other.inviteToken == inviteToken)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,displayName,createdAt,updatedAt,initials,colourIndex,role,profileId,inviteToken,deletedAt);

@override
String toString() {
  return 'GroupMember(id: $id, groupId: $groupId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, initials: $initials, colourIndex: $colourIndex, role: $role, profileId: $profileId, inviteToken: $inviteToken, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $GroupMemberCopyWith<$Res>  {
  factory $GroupMemberCopyWith(GroupMember value, $Res Function(GroupMember) _then) = _$GroupMemberCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String displayName, DateTime createdAt, DateTime updatedAt, String initials, int colourIndex, MemberRole role, String? profileId, String? inviteToken, DateTime? deletedAt
});




}
/// @nodoc
class _$GroupMemberCopyWithImpl<$Res>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._self, this._then);

  final GroupMember _self;
  final $Res Function(GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? displayName = null,Object? createdAt = null,Object? updatedAt = null,Object? initials = null,Object? colourIndex = null,Object? role = null,Object? profileId = freezed,Object? inviteToken = freezed,Object? deletedAt = freezed,}) {
  return _then(GroupMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,colourIndex: null == colourIndex ? _self.colourIndex : colourIndex // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,inviteToken: freezed == inviteToken ? _self.inviteToken : inviteToken // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMember].
extension GroupMemberPatterns on GroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMember value)  $default,){
final _that = this;
switch (_that) {
case _GroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String initials,  int colourIndex,  MemberRole role,  String? profileId,  String? inviteToken,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.id,_that.groupId,_that.displayName,_that.createdAt,_that.updatedAt,_that.initials,_that.colourIndex,_that.role,_that.profileId,_that.inviteToken,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String initials,  int colourIndex,  MemberRole role,  String? profileId,  String? inviteToken,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _GroupMember():
return $default(_that.id,_that.groupId,_that.displayName,_that.createdAt,_that.updatedAt,_that.initials,_that.colourIndex,_that.role,_that.profileId,_that.inviteToken,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String initials,  int colourIndex,  MemberRole role,  String? profileId,  String? inviteToken,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.id,_that.groupId,_that.displayName,_that.createdAt,_that.updatedAt,_that.initials,_that.colourIndex,_that.role,_that.profileId,_that.inviteToken,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _GroupMember extends GroupMember {
  const _GroupMember({required this.id, required this.groupId, required this.displayName, required this.createdAt, required this.updatedAt, required this.initials, this.colourIndex = 0, this.role = MemberRole.member, this.profileId, this.inviteToken, this.deletedAt}): super._();
  

@override final  String id;
@override final  String groupId;
@override final  String displayName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Two letters, shown white on [colourIndex]'s fill.
@override final  String initials;
/// An index into `KoshaColors.avatarTones`, not a colour.
///
/// The four tones are fixed and theme-independent (§7.1) so white initials
/// keep 4.5:1 in both themes. Storing the index rather than the value is
/// the same indirection `Space.iconKey` uses: a stored 0xFF415DB7 would
/// freeze today's palette into every old row.
@override@JsonKey() final  int colourIndex;
@override@JsonKey() final  MemberRole role;
/// The local profile this member *is*, once there is an account behind
/// them (Phase 5). Null for every member v1 creates except "You".
@override final  String? profileId;
@override final  String? inviteToken;
@override final  DateTime? deletedAt;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberCopyWith<_GroupMember> get copyWith => __$GroupMemberCopyWithImpl<_GroupMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMember&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.colourIndex, colourIndex) || other.colourIndex == colourIndex)&&(identical(other.role, role) || other.role == role)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.inviteToken, inviteToken) || other.inviteToken == inviteToken)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,displayName,createdAt,updatedAt,initials,colourIndex,role,profileId,inviteToken,deletedAt);

@override
String toString() {
  return 'GroupMember(id: $id, groupId: $groupId, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, initials: $initials, colourIndex: $colourIndex, role: $role, profileId: $profileId, inviteToken: $inviteToken, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberCopyWith<$Res> implements $GroupMemberCopyWith<$Res> {
  factory _$GroupMemberCopyWith(_GroupMember value, $Res Function(_GroupMember) _then) = __$GroupMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String displayName, DateTime createdAt, DateTime updatedAt, String initials, int colourIndex, MemberRole role, String? profileId, String? inviteToken, DateTime? deletedAt
});




}
/// @nodoc
class __$GroupMemberCopyWithImpl<$Res>
    implements _$GroupMemberCopyWith<$Res> {
  __$GroupMemberCopyWithImpl(this._self, this._then);

  final _GroupMember _self;
  final $Res Function(_GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? displayName = null,Object? createdAt = null,Object? updatedAt = null,Object? initials = null,Object? colourIndex = null,Object? role = null,Object? profileId = freezed,Object? inviteToken = freezed,Object? deletedAt = freezed,}) {
  return _then(_GroupMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,colourIndex: null == colourIndex ? _self.colourIndex : colourIndex // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,inviteToken: freezed == inviteToken ? _self.inviteToken : inviteToken // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
