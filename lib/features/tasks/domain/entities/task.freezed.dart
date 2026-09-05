// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Task {

 String get id; String get title; DateTime get createdAt; DateTime get updatedAt; String? get description;/// Local midnight of the day the task is due; null means "no date".
 DateTime? get dueDate;/// Minutes since midnight, or null for "any time".
 int? get dueMinutes; Priority get priority; bool get done; DateTime? get completedAt;/// RFC 5545 rule, e.g. `FREQ=DAILY`. Empty or null means it never repeats.
 String? get recurrenceRule;/// Minutes before [dueAt] to fire a reminder; null means no reminder.
 int? get reminderOffsetMinutes; String? get category; String? get spaceId; String? get parentTaskId; TaskSource get source;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.done, done) || other.done == done)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.category, category) || other.category == category)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,description,dueDate,dueMinutes,priority,done,completedAt,recurrenceRule,reminderOffsetMinutes,category,spaceId,parentTaskId,source);

@override
String toString() {
  return 'Task(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, done: $done, completedAt: $completedAt, recurrenceRule: $recurrenceRule, reminderOffsetMinutes: $reminderOffsetMinutes, category: $category, spaceId: $spaceId, parentTaskId: $parentTaskId, source: $source)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime updatedAt, String? description, DateTime? dueDate, int? dueMinutes, Priority priority, bool done, DateTime? completedAt, String? recurrenceRule, int? reminderOffsetMinutes, String? category, String? spaceId, String? parentTaskId, TaskSource source
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? done = null,Object? completedAt = freezed,Object? recurrenceRule = freezed,Object? reminderOffsetMinutes = freezed,Object? category = freezed,Object? spaceId = freezed,Object? parentTaskId = freezed,Object? source = null,}) {
  return _then(Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TaskSource,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  bool done,  DateTime? completedAt,  String? recurrenceRule,  int? reminderOffsetMinutes,  String? category,  String? spaceId,  String? parentTaskId,  TaskSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.description,_that.dueDate,_that.dueMinutes,_that.priority,_that.done,_that.completedAt,_that.recurrenceRule,_that.reminderOffsetMinutes,_that.category,_that.spaceId,_that.parentTaskId,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  bool done,  DateTime? completedAt,  String? recurrenceRule,  int? reminderOffsetMinutes,  String? category,  String? spaceId,  String? parentTaskId,  TaskSource source)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.description,_that.dueDate,_that.dueMinutes,_that.priority,_that.done,_that.completedAt,_that.recurrenceRule,_that.reminderOffsetMinutes,_that.category,_that.spaceId,_that.parentTaskId,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? description,  DateTime? dueDate,  int? dueMinutes,  Priority priority,  bool done,  DateTime? completedAt,  String? recurrenceRule,  int? reminderOffsetMinutes,  String? category,  String? spaceId,  String? parentTaskId,  TaskSource source)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.description,_that.dueDate,_that.dueMinutes,_that.priority,_that.done,_that.completedAt,_that.recurrenceRule,_that.reminderOffsetMinutes,_that.category,_that.spaceId,_that.parentTaskId,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _Task extends Task {
  const _Task({required this.id, required this.title, required this.createdAt, required this.updatedAt, this.description, this.dueDate, this.dueMinutes, this.priority = Priority.none, this.done = false, this.completedAt, this.recurrenceRule, this.reminderOffsetMinutes, this.category, this.spaceId, this.parentTaskId, this.source = TaskSource.manual}): super._();
  

@override final  String id;
@override final  String title;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
/// Local midnight of the day the task is due; null means "no date".
@override final  DateTime? dueDate;
/// Minutes since midnight, or null for "any time".
@override final  int? dueMinutes;
@override@JsonKey() final  Priority priority;
@override@JsonKey() final  bool done;
@override final  DateTime? completedAt;
/// RFC 5545 rule, e.g. `FREQ=DAILY`. Empty or null means it never repeats.
@override final  String? recurrenceRule;
/// Minutes before [dueAt] to fire a reminder; null means no reminder.
@override final  int? reminderOffsetMinutes;
@override final  String? category;
@override final  String? spaceId;
@override final  String? parentTaskId;
@override@JsonKey() final  TaskSource source;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueMinutes, dueMinutes) || other.dueMinutes == dueMinutes)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.done, done) || other.done == done)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.reminderOffsetMinutes, reminderOffsetMinutes) || other.reminderOffsetMinutes == reminderOffsetMinutes)&&(identical(other.category, category) || other.category == category)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,description,dueDate,dueMinutes,priority,done,completedAt,recurrenceRule,reminderOffsetMinutes,category,spaceId,parentTaskId,source);

@override
String toString() {
  return 'Task(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, dueDate: $dueDate, dueMinutes: $dueMinutes, priority: $priority, done: $done, completedAt: $completedAt, recurrenceRule: $recurrenceRule, reminderOffsetMinutes: $reminderOffsetMinutes, category: $category, spaceId: $spaceId, parentTaskId: $parentTaskId, source: $source)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime updatedAt, String? description, DateTime? dueDate, int? dueMinutes, Priority priority, bool done, DateTime? completedAt, String? recurrenceRule, int? reminderOffsetMinutes, String? category, String? spaceId, String? parentTaskId, TaskSource source
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? dueDate = freezed,Object? dueMinutes = freezed,Object? priority = null,Object? done = null,Object? completedAt = freezed,Object? recurrenceRule = freezed,Object? reminderOffsetMinutes = freezed,Object? category = freezed,Object? spaceId = freezed,Object? parentTaskId = freezed,Object? source = null,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueMinutes: freezed == dueMinutes ? _self.dueMinutes : dueMinutes // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderOffsetMinutes: freezed == reminderOffsetMinutes ? _self.reminderOffsetMinutes : reminderOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TaskSource,
  ));
}


}

// dart format on
