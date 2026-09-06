// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const Setting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      Setting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMinutesMeta = const VerificationMeta(
    'dueMinutes',
  );
  @override
  late final GeneratedColumn<int> dueMinutes = GeneratedColumn<int>(
    'due_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Priority, int> priority =
      GeneratedColumn<int>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Priority>($TasksTable.$converterpriority);
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
    'reminder_offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentTaskIdMeta = const VerificationMeta(
    'parentTaskId',
  );
  @override
  late final GeneratedColumn<String> parentTaskId = GeneratedColumn<String>(
    'parent_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskSource>($TasksTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDate,
    dueMinutes,
    priority,
    done,
    completedAt,
    recurrenceRule,
    reminderOffsetMinutes,
    category,
    spaceId,
    parentTaskId,
    source,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_minutes')) {
      context.handle(
        _dueMinutesMeta,
        dueMinutes.isAcceptableOrUnknown(data['due_minutes']!, _dueMinutesMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
        _reminderOffsetMinutesMeta,
        reminderOffsetMinutes.isAcceptableOrUnknown(
          data['reminder_offset_minutes']!,
          _reminderOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    }
    if (data.containsKey('parent_task_id')) {
      context.handle(
        _parentTaskIdMeta,
        parentTaskId.isAcceptableOrUnknown(
          data['parent_task_id']!,
          _parentTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_minutes'],
      ),
      priority: $TasksTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}priority'],
        )!,
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset_minutes'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      ),
      parentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_task_id'],
      ),
      source: $TasksTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Priority, int, int> $converterpriority =
      const EnumIndexConverter<Priority>(Priority.values);
  static JsonTypeConverter2<TaskSource, int, int> $convertersource =
      const EnumIndexConverter<TaskSource>(TaskSource.values);
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int? dueMinutes;
  final Priority priority;
  final bool done;
  final DateTime? completedAt;
  final String? recurrenceRule;
  final int? reminderOffsetMinutes;
  final String? category;
  final String? spaceId;
  final String? parentTaskId;
  final TaskSource source;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Set instead of removing the row, so a delete can be undone and so the
  /// Phase 5 sync layer can propagate the deletion.
  final DateTime? deletedAt;
  const TaskRow({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.dueMinutes,
    required this.priority,
    required this.done,
    this.completedAt,
    this.recurrenceRule,
    this.reminderOffsetMinutes,
    this.category,
    this.spaceId,
    this.parentTaskId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueMinutes != null) {
      map['due_minutes'] = Variable<int>(dueMinutes);
    }
    {
      map['priority'] = Variable<int>(
        $TasksTable.$converterpriority.toSql(priority),
      );
    }
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || reminderOffsetMinutes != null) {
      map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || spaceId != null) {
      map['space_id'] = Variable<String>(spaceId);
    }
    if (!nullToAbsent || parentTaskId != null) {
      map['parent_task_id'] = Variable<String>(parentTaskId);
    }
    {
      map['source'] = Variable<int>($TasksTable.$convertersource.toSql(source));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueMinutes: dueMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dueMinutes),
      priority: Value(priority),
      done: Value(done),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      reminderOffsetMinutes: reminderOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffsetMinutes),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      spaceId: spaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(spaceId),
      parentTaskId: parentTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTaskId),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueMinutes: serializer.fromJson<int?>(json['dueMinutes']),
      priority: $TasksTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      done: serializer.fromJson<bool>(json['done']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      reminderOffsetMinutes: serializer.fromJson<int?>(
        json['reminderOffsetMinutes'],
      ),
      category: serializer.fromJson<String?>(json['category']),
      spaceId: serializer.fromJson<String?>(json['spaceId']),
      parentTaskId: serializer.fromJson<String?>(json['parentTaskId']),
      source: $TasksTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueMinutes': serializer.toJson<int?>(dueMinutes),
      'priority': serializer.toJson<int>(
        $TasksTable.$converterpriority.toJson(priority),
      ),
      'done': serializer.toJson<bool>(done),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'reminderOffsetMinutes': serializer.toJson<int?>(reminderOffsetMinutes),
      'category': serializer.toJson<String?>(category),
      'spaceId': serializer.toJson<String?>(spaceId),
      'parentTaskId': serializer.toJson<String?>(parentTaskId),
      'source': serializer.toJson<int>(
        $TasksTable.$convertersource.toJson(source),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<int?> dueMinutes = const Value.absent(),
    Priority? priority,
    bool? done,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> recurrenceRule = const Value.absent(),
    Value<int?> reminderOffsetMinutes = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> spaceId = const Value.absent(),
    Value<String?> parentTaskId = const Value.absent(),
    TaskSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueMinutes: dueMinutes.present ? dueMinutes.value : this.dueMinutes,
    priority: priority ?? this.priority,
    done: done ?? this.done,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    reminderOffsetMinutes: reminderOffsetMinutes.present
        ? reminderOffsetMinutes.value
        : this.reminderOffsetMinutes,
    category: category.present ? category.value : this.category,
    spaceId: spaceId.present ? spaceId.value : this.spaceId,
    parentTaskId: parentTaskId.present ? parentTaskId.value : this.parentTaskId,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueMinutes: data.dueMinutes.present
          ? data.dueMinutes.value
          : this.dueMinutes,
      priority: data.priority.present ? data.priority.value : this.priority,
      done: data.done.present ? data.done.value : this.done,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
      category: data.category.present ? data.category.value : this.category,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      parentTaskId: data.parentTaskId.present
          ? data.parentTaskId.value
          : this.parentTaskId,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueMinutes: $dueMinutes, ')
          ..write('priority: $priority, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('category: $category, ')
          ..write('spaceId: $spaceId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDate,
    dueMinutes,
    priority,
    done,
    completedAt,
    recurrenceRule,
    reminderOffsetMinutes,
    category,
    spaceId,
    parentTaskId,
    source,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.dueMinutes == this.dueMinutes &&
          other.priority == this.priority &&
          other.done == this.done &&
          other.completedAt == this.completedAt &&
          other.recurrenceRule == this.recurrenceRule &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes &&
          other.category == this.category &&
          other.spaceId == this.spaceId &&
          other.parentTaskId == this.parentTaskId &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDate;
  final Value<int?> dueMinutes;
  final Value<Priority> priority;
  final Value<bool> done;
  final Value<DateTime?> completedAt;
  final Value<String?> recurrenceRule;
  final Value<int?> reminderOffsetMinutes;
  final Value<String?> category;
  final Value<String?> spaceId;
  final Value<String?> parentTaskId;
  final Value<TaskSource> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.category = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.category = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<int>? dueMinutes,
    Expression<int>? priority,
    Expression<bool>? done,
    Expression<DateTime>? completedAt,
    Expression<String>? recurrenceRule,
    Expression<int>? reminderOffsetMinutes,
    Expression<String>? category,
    Expression<String>? spaceId,
    Expression<String>? parentTaskId,
    Expression<int>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (dueMinutes != null) 'due_minutes': dueMinutes,
      if (priority != null) 'priority': priority,
      if (done != null) 'done': done,
      if (completedAt != null) 'completed_at': completedAt,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
      if (category != null) 'category': category,
      if (spaceId != null) 'space_id': spaceId,
      if (parentTaskId != null) 'parent_task_id': parentTaskId,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueDate,
    Value<int?>? dueMinutes,
    Value<Priority>? priority,
    Value<bool>? done,
    Value<DateTime?>? completedAt,
    Value<String?>? recurrenceRule,
    Value<int?>? reminderOffsetMinutes,
    Value<String?>? category,
    Value<String?>? spaceId,
    Value<String?>? parentTaskId,
    Value<TaskSource>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueMinutes: dueMinutes ?? this.dueMinutes,
      priority: priority ?? this.priority,
      done: done ?? this.done,
      completedAt: completedAt ?? this.completedAt,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      category: category ?? this.category,
      spaceId: spaceId ?? this.spaceId,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueMinutes.present) {
      map['due_minutes'] = Variable<int>(dueMinutes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $TasksTable.$converterpriority.toSql(priority.value),
      );
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] = Variable<int>(
        reminderOffsetMinutes.value,
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (parentTaskId.present) {
      map['parent_task_id'] = Variable<String>(parentTaskId.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $TasksTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueMinutes: $dueMinutes, ')
          ..write('priority: $priority, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('category: $category, ')
          ..write('spaceId: $spaceId, ')
          ..write('parentTaskId: $parentTaskId, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEntriesTable extends ActivityEntries
    with TableInfo<$ActivityEntriesTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityEvent, int> event =
      GeneratedColumn<int>(
        'event',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ActivityEvent>($ActivityEntriesTable.$converterevent);
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerType,
    ownerId,
    event,
    detail,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      event: $ActivityEntriesTable.$converterevent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}event'],
        )!,
      ),
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $ActivityEntriesTable createAlias(String alias) {
    return $ActivityEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityEvent, int, int> $converterevent =
      const EnumIndexConverter<ActivityEvent>(ActivityEvent.values);
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  final String id;
  final String ownerType;
  final String ownerId;
  final ActivityEvent event;

  /// Short human context, e.g. the date a task was moved to.
  final String? detail;
  final DateTime at;
  const ActivityRow({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.event,
    this.detail,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_type'] = Variable<String>(ownerType);
    map['owner_id'] = Variable<String>(ownerId);
    {
      map['event'] = Variable<int>(
        $ActivityEntriesTable.$converterevent.toSql(event),
      );
    }
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  ActivityEntriesCompanion toCompanion(bool nullToAbsent) {
    return ActivityEntriesCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: Value(ownerId),
      event: Value(event),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      at: Value(at),
    );
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(
      id: serializer.fromJson<String>(json['id']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      event: $ActivityEntriesTable.$converterevent.fromJson(
        serializer.fromJson<int>(json['event']),
      ),
      detail: serializer.fromJson<String?>(json['detail']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<String>(ownerId),
      'event': serializer.toJson<int>(
        $ActivityEntriesTable.$converterevent.toJson(event),
      ),
      'detail': serializer.toJson<String?>(detail),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  ActivityRow copyWith({
    String? id,
    String? ownerType,
    String? ownerId,
    ActivityEvent? event,
    Value<String?> detail = const Value.absent(),
    DateTime? at,
  }) => ActivityRow(
    id: id ?? this.id,
    ownerType: ownerType ?? this.ownerType,
    ownerId: ownerId ?? this.ownerId,
    event: event ?? this.event,
    detail: detail.present ? detail.value : this.detail,
    at: at ?? this.at,
  );
  ActivityRow copyWithCompanion(ActivityEntriesCompanion data) {
    return ActivityRow(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      event: data.event.present ? data.event.value : this.event,
      detail: data.detail.present ? data.detail.value : this.detail,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('event: $event, ')
          ..write('detail: $detail, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerType, ownerId, event, detail, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRow &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.event == this.event &&
          other.detail == this.detail &&
          other.at == this.at);
}

class ActivityEntriesCompanion extends UpdateCompanion<ActivityRow> {
  final Value<String> id;
  final Value<String> ownerType;
  final Value<String> ownerId;
  final Value<ActivityEvent> event;
  final Value<String?> detail;
  final Value<DateTime> at;
  final Value<int> rowid;
  const ActivityEntriesCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.event = const Value.absent(),
    this.detail = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityEntriesCompanion.insert({
    required String id,
    required String ownerType,
    required String ownerId,
    required ActivityEvent event,
    this.detail = const Value.absent(),
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerType = Value(ownerType),
       ownerId = Value(ownerId),
       event = Value(event),
       at = Value(at);
  static Insertable<ActivityRow> custom({
    Expression<String>? id,
    Expression<String>? ownerType,
    Expression<String>? ownerId,
    Expression<int>? event,
    Expression<String>? detail,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (event != null) 'event': event,
      if (detail != null) 'detail': detail,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerType,
    Value<String>? ownerId,
    Value<ActivityEvent>? event,
    Value<String?>? detail,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return ActivityEntriesCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      event: event ?? this.event,
      detail: detail ?? this.detail,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (event.present) {
      map['event'] = Variable<int>(
        $ActivityEntriesTable.$converterevent.toSql(event.value),
      );
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('event: $event, ')
          ..write('detail: $detail, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('You'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarInitialsMeta = const VerificationMeta(
    'avatarInitials',
  );
  @override
  late final GeneratedColumn<String> avatarInitials = GeneratedColumn<String>(
    'avatar_initials',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Y'),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _dateFormatMeta = const VerificationMeta(
    'dateFormat',
  );
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
    'date_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('d MMM yyyy'),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<int> weekStart = GeneratedColumn<int>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    avatarInitials,
    joinedAt,
    currency,
    dateFormat,
    weekStart,
    locale,
    onboardingCompleted,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('avatar_initials')) {
      context.handle(
        _avatarInitialsMeta,
        avatarInitials.isAcceptableOrUnknown(
          data['avatar_initials']!,
          _avatarInitialsMeta,
        ),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('date_format')) {
      context.handle(
        _dateFormatMeta,
        dateFormat.isAcceptableOrUnknown(data['date_format']!, _dateFormatMeta),
      );
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      avatarInitials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_initials'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      dateFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_format'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_start'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String name;
  final String? email;
  final String avatarInitials;
  final DateTime joinedAt;
  final String currency;
  final String dateFormat;
  final int weekStart;
  final String locale;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ProfileRow({
    required this.id,
    required this.name,
    this.email,
    required this.avatarInitials,
    required this.joinedAt,
    required this.currency,
    required this.dateFormat,
    required this.weekStart,
    required this.locale,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['avatar_initials'] = Variable<String>(avatarInitials);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['currency'] = Variable<String>(currency);
    map['date_format'] = Variable<String>(dateFormat);
    map['week_start'] = Variable<int>(weekStart);
    map['locale'] = Variable<String>(locale);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      avatarInitials: Value(avatarInitials),
      joinedAt: Value(joinedAt),
      currency: Value(currency),
      dateFormat: Value(dateFormat),
      weekStart: Value(weekStart),
      locale: Value(locale),
      onboardingCompleted: Value(onboardingCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      avatarInitials: serializer.fromJson<String>(json['avatarInitials']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      currency: serializer.fromJson<String>(json['currency']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      weekStart: serializer.fromJson<int>(json['weekStart']),
      locale: serializer.fromJson<String>(json['locale']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'avatarInitials': serializer.toJson<String>(avatarInitials),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'currency': serializer.toJson<String>(currency),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'weekStart': serializer.toJson<int>(weekStart),
      'locale': serializer.toJson<String>(locale),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? name,
    Value<String?> email = const Value.absent(),
    String? avatarInitials,
    DateTime? joinedAt,
    String? currency,
    String? dateFormat,
    int? weekStart,
    String? locale,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email.present ? email.value : this.email,
    avatarInitials: avatarInitials ?? this.avatarInitials,
    joinedAt: joinedAt ?? this.joinedAt,
    currency: currency ?? this.currency,
    dateFormat: dateFormat ?? this.dateFormat,
    weekStart: weekStart ?? this.weekStart,
    locale: locale ?? this.locale,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      avatarInitials: data.avatarInitials.present
          ? data.avatarInitials.value
          : this.avatarInitials,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      currency: data.currency.present ? data.currency.value : this.currency,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      locale: data.locale.present ? data.locale.value : this.locale,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarInitials: $avatarInitials, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('currency: $currency, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('weekStart: $weekStart, ')
          ..write('locale: $locale, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    avatarInitials,
    joinedAt,
    currency,
    dateFormat,
    weekStart,
    locale,
    onboardingCompleted,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.avatarInitials == this.avatarInitials &&
          other.joinedAt == this.joinedAt &&
          other.currency == this.currency &&
          other.dateFormat == this.dateFormat &&
          other.weekStart == this.weekStart &&
          other.locale == this.locale &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<String> avatarInitials;
  final Value<DateTime> joinedAt;
  final Value<String> currency;
  final Value<String> dateFormat;
  final Value<int> weekStart;
  final Value<String> locale;
  final Value<bool> onboardingCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarInitials = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.currency = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.locale = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarInitials = const Value.absent(),
    required DateTime joinedAt,
    this.currency = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.locale = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       joinedAt = Value(joinedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? avatarInitials,
    Expression<DateTime>? joinedAt,
    Expression<String>? currency,
    Expression<String>? dateFormat,
    Expression<int>? weekStart,
    Expression<String>? locale,
    Expression<bool>? onboardingCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarInitials != null) 'avatar_initials': avatarInitials,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (currency != null) 'currency': currency,
      if (dateFormat != null) 'date_format': dateFormat,
      if (weekStart != null) 'week_start': weekStart,
      if (locale != null) 'locale': locale,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? email,
    Value<String>? avatarInitials,
    Value<DateTime>? joinedAt,
    Value<String>? currency,
    Value<String>? dateFormat,
    Value<int>? weekStart,
    Value<String>? locale,
    Value<bool>? onboardingCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      joinedAt: joinedAt ?? this.joinedAt,
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      weekStart: weekStart ?? this.weekStart,
      locale: locale ?? this.locale,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarInitials.present) {
      map['avatar_initials'] = Variable<String>(avatarInitials.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<int>(weekStart.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarInitials: $avatarInitials, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('currency: $currency, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('weekStart: $weekStart, ')
          ..write('locale: $locale, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardSectionsTable extends DashboardSections
    with TableInfo<$DashboardSectionsTable, DashboardSectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, enabled, sortOrder, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashboardSectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DashboardSectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardSectionRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DashboardSectionsTable createAlias(String alias) {
    return $DashboardSectionsTable(attachedDatabase, alias);
  }
}

class DashboardSectionRow extends DataClass
    implements Insertable<DashboardSectionRow> {
  final String key;
  final bool enabled;
  final int sortOrder;
  final DateTime updatedAt;
  const DashboardSectionRow({
    required this.key,
    required this.enabled,
    required this.sortOrder,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['enabled'] = Variable<bool>(enabled);
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DashboardSectionsCompanion toCompanion(bool nullToAbsent) {
    return DashboardSectionsCompanion(
      key: Value(key),
      enabled: Value(enabled),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
    );
  }

  factory DashboardSectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardSectionRow(
      key: serializer.fromJson<String>(json['key']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'enabled': serializer.toJson<bool>(enabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DashboardSectionRow copyWith({
    String? key,
    bool? enabled,
    int? sortOrder,
    DateTime? updatedAt,
  }) => DashboardSectionRow(
    key: key ?? this.key,
    enabled: enabled ?? this.enabled,
    sortOrder: sortOrder ?? this.sortOrder,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DashboardSectionRow copyWithCompanion(DashboardSectionsCompanion data) {
    return DashboardSectionRow(
      key: data.key.present ? data.key.value : this.key,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardSectionRow(')
          ..write('key: $key, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, enabled, sortOrder, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardSectionRow &&
          other.key == this.key &&
          other.enabled == this.enabled &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt);
}

class DashboardSectionsCompanion extends UpdateCompanion<DashboardSectionRow> {
  final Value<String> key;
  final Value<bool> enabled;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DashboardSectionsCompanion({
    this.key = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardSectionsCompanion.insert({
    required String key,
    this.enabled = const Value.absent(),
    required int sortOrder,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       sortOrder = Value(sortOrder),
       updatedAt = Value(updatedAt);
  static Insertable<DashboardSectionRow> custom({
    Expression<String>? key,
    Expression<bool>? enabled,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (enabled != null) 'enabled': enabled,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardSectionsCompanion copyWith({
    Value<String>? key,
    Value<bool>? enabled,
    Value<int>? sortOrder,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DashboardSectionsCompanion(
      key: key ?? this.key,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardSectionsCompanion(')
          ..write('key: $key, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
    'reminder_offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    startAt,
    endAt,
    allDay,
    reminderOffsetMinutes,
    spaceId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
        _reminderOffsetMinutesMeta,
        reminderOffsetMinutes.isAcceptableOrUnknown(
          data['reminder_offset_minutes']!,
          _reminderOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset_minutes'],
      ),
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final String id;
  final String title;
  final String? description;
  final DateTime startAt;
  final DateTime? endAt;
  final bool allDay;
  final int? reminderOffsetMinutes;
  final String? spaceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Set instead of removing the row, so a delete can be undone.
  final DateTime? deletedAt;
  const EventRow({
    required this.id,
    required this.title,
    this.description,
    required this.startAt,
    this.endAt,
    required this.allDay,
    this.reminderOffsetMinutes,
    this.spaceId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_at'] = Variable<DateTime>(startAt);
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    map['all_day'] = Variable<bool>(allDay);
    if (!nullToAbsent || reminderOffsetMinutes != null) {
      map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    }
    if (!nullToAbsent || spaceId != null) {
      map['space_id'] = Variable<String>(spaceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startAt: Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      allDay: Value(allDay),
      reminderOffsetMinutes: reminderOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffsetMinutes),
      spaceId: spaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(spaceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      reminderOffsetMinutes: serializer.fromJson<int?>(
        json['reminderOffsetMinutes'],
      ),
      spaceId: serializer.fromJson<String?>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'allDay': serializer.toJson<bool>(allDay),
      'reminderOffsetMinutes': serializer.toJson<int?>(reminderOffsetMinutes),
      'spaceId': serializer.toJson<String?>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EventRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? startAt,
    Value<DateTime?> endAt = const Value.absent(),
    bool? allDay,
    Value<int?> reminderOffsetMinutes = const Value.absent(),
    Value<String?> spaceId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EventRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    startAt: startAt ?? this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    allDay: allDay ?? this.allDay,
    reminderOffsetMinutes: reminderOffsetMinutes.present
        ? reminderOffsetMinutes.value
        : this.reminderOffsetMinutes,
    spaceId: spaceId.present ? spaceId.value : this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    startAt,
    endAt,
    allDay,
    reminderOffsetMinutes,
    spaceId,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.allDay == this.allDay &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> startAt;
  final Value<DateTime?> endAt;
  final Value<bool> allDay;
  final Value<int?> reminderOffsetMinutes;
  final Value<String?> spaceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime startAt,
    this.endAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.spaceId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       startAt = Value(startAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EventRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<bool>? allDay,
    Expression<int>? reminderOffsetMinutes,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (allDay != null) 'all_day': allDay,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? startAt,
    Value<DateTime?>? endAt,
    Value<bool>? allDay,
    Value<int?>? reminderOffsetMinutes,
    Value<String?>? spaceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      allDay: allDay ?? this.allDay,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] = Variable<int>(
        reminderOffsetMinutes.value,
      );
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, NotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ReminderKind>($NotificationsTable.$converterkind);
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dedupeKeyMeta = const VerificationMeta(
    'dedupeKey',
  );
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
    'dedupe_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    ownerId,
    title,
    body,
    route,
    dedupeKey,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(
        _dedupeKeyMeta,
        dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dedupeKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $NotificationsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      route: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route'],
      ),
      dedupeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderKind, int, int> $converterkind =
      const EnumIndexConverter<ReminderKind>(ReminderKind.values);
}

class NotificationRow extends DataClass implements Insertable<NotificationRow> {
  final String id;
  final ReminderKind kind;
  final String ownerId;
  final String title;
  final String? body;
  final String? route;

  /// `'<kind>:<ownerId>:<fireAt ISO-8601>'` — makes re-running reconciliation
  /// on every launch safe: the same fired moment is never inserted twice.
  final String dedupeKey;
  final DateTime createdAt;
  final DateTime? readAt;
  const NotificationRow({
    required this.id,
    required this.kind,
    required this.ownerId,
    required this.title,
    this.body,
    this.route,
    required this.dedupeKey,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<int>(
        $NotificationsTable.$converterkind.toSql(kind),
      );
    }
    map['owner_id'] = Variable<String>(ownerId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || route != null) {
      map['route'] = Variable<String>(route);
    }
    map['dedupe_key'] = Variable<String>(dedupeKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      kind: Value(kind),
      ownerId: Value(ownerId),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      route: route == null && nullToAbsent
          ? const Value.absent()
          : Value(route),
      dedupeKey: Value(dedupeKey),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory NotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRow(
      id: serializer.fromJson<String>(json['id']),
      kind: $NotificationsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      route: serializer.fromJson<String?>(json['route']),
      dedupeKey: serializer.fromJson<String>(json['dedupeKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<int>(
        $NotificationsTable.$converterkind.toJson(kind),
      ),
      'ownerId': serializer.toJson<String>(ownerId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'route': serializer.toJson<String?>(route),
      'dedupeKey': serializer.toJson<String>(dedupeKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  NotificationRow copyWith({
    String? id,
    ReminderKind? kind,
    String? ownerId,
    String? title,
    Value<String?> body = const Value.absent(),
    Value<String?> route = const Value.absent(),
    String? dedupeKey,
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
  }) => NotificationRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    ownerId: ownerId ?? this.ownerId,
    title: title ?? this.title,
    body: body.present ? body.value : this.body,
    route: route.present ? route.value : this.route,
    dedupeKey: dedupeKey ?? this.dedupeKey,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  NotificationRow copyWithCompanion(NotificationsCompanion data) {
    return NotificationRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      route: data.route.present ? data.route.value : this.route,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('route: $route, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    ownerId,
    title,
    body,
    route,
    dedupeKey,
    createdAt,
    readAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.ownerId == this.ownerId &&
          other.title == this.title &&
          other.body == this.body &&
          other.route == this.route &&
          other.dedupeKey == this.dedupeKey &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class NotificationsCompanion extends UpdateCompanion<NotificationRow> {
  final Value<String> id;
  final Value<ReminderKind> kind;
  final Value<String> ownerId;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> route;
  final Value<String> dedupeKey;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.route = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required ReminderKind kind,
    required String ownerId,
    required String title,
    this.body = const Value.absent(),
    this.route = const Value.absent(),
    required String dedupeKey,
    required DateTime createdAt,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       ownerId = Value(ownerId),
       title = Value(title),
       dedupeKey = Value(dedupeKey),
       createdAt = Value(createdAt);
  static Insertable<NotificationRow> custom({
    Expression<String>? id,
    Expression<int>? kind,
    Expression<String>? ownerId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? route,
    Expression<String>? dedupeKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (ownerId != null) 'owner_id': ownerId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (route != null) 'route': route,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith({
    Value<String>? id,
    Value<ReminderKind>? kind,
    Value<String>? ownerId,
    Value<String>? title,
    Value<String?>? body,
    Value<String?>? route,
    Value<String>? dedupeKey,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
    Value<int>? rowid,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      body: body ?? this.body,
      route: route ?? this.route,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $NotificationsTable.$converterkind.toSql(kind.value),
      );
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('route: $route, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionMethod?, int> method =
      GeneratedColumn<int>(
        'method',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<TransactionMethod?>($TransactionsTable.$convertermethodn);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
    'bill_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountMinor,
    type,
    date,
    category,
    method,
    label,
    note,
    spaceId,
    billId,
    vehicleId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      method: $TransactionsTable.$convertermethodn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}method'],
        ),
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      ),
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_id'],
      ),
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, int, int> $convertertype =
      const EnumIndexConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionMethod, int, int> $convertermethod =
      const EnumIndexConverter<TransactionMethod>(TransactionMethod.values);
  static JsonTypeConverter2<TransactionMethod?, int?, int?> $convertermethodn =
      JsonTypeConverter2.asNullable($convertermethod);
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final int amountMinor;
  final TransactionType type;
  final DateTime date;
  final String? category;
  final TransactionMethod? method;
  final String? label;
  final String? note;
  final String? spaceId;
  final String? billId;
  final String? vehicleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Set instead of removing the row, so a delete can be undone and the
  /// Phase 5 sync layer can propagate the deletion — same pattern as `Tasks`.
  final DateTime? deletedAt;
  const TransactionRow({
    required this.id,
    required this.amountMinor,
    required this.type,
    required this.date,
    this.category,
    this.method,
    this.label,
    this.note,
    this.spaceId,
    this.billId,
    this.vehicleId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_minor'] = Variable<int>(amountMinor);
    {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<int>(
        $TransactionsTable.$convertermethodn.toSql(method),
      );
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || spaceId != null) {
      map['space_id'] = Variable<String>(spaceId);
    }
    if (!nullToAbsent || billId != null) {
      map['bill_id'] = Variable<String>(billId);
    }
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<String>(vehicleId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amountMinor: Value(amountMinor),
      type: Value(type),
      date: Value(date),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      spaceId: spaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(spaceId),
      billId: billId == null && nullToAbsent
          ? const Value.absent()
          : Value(billId),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String?>(json['category']),
      method: $TransactionsTable.$convertermethodn.fromJson(
        serializer.fromJson<int?>(json['method']),
      ),
      label: serializer.fromJson<String?>(json['label']),
      note: serializer.fromJson<String?>(json['note']),
      spaceId: serializer.fromJson<String?>(json['spaceId']),
      billId: serializer.fromJson<String?>(json['billId']),
      vehicleId: serializer.fromJson<String?>(json['vehicleId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'type': serializer.toJson<int>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String?>(category),
      'method': serializer.toJson<int?>(
        $TransactionsTable.$convertermethodn.toJson(method),
      ),
      'label': serializer.toJson<String?>(label),
      'note': serializer.toJson<String?>(note),
      'spaceId': serializer.toJson<String?>(spaceId),
      'billId': serializer.toJson<String?>(billId),
      'vehicleId': serializer.toJson<String?>(vehicleId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    int? amountMinor,
    TransactionType? type,
    DateTime? date,
    Value<String?> category = const Value.absent(),
    Value<TransactionMethod?> method = const Value.absent(),
    Value<String?> label = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> spaceId = const Value.absent(),
    Value<String?> billId = const Value.absent(),
    Value<String?> vehicleId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TransactionRow(
    id: id ?? this.id,
    amountMinor: amountMinor ?? this.amountMinor,
    type: type ?? this.type,
    date: date ?? this.date,
    category: category.present ? category.value : this.category,
    method: method.present ? method.value : this.method,
    label: label.present ? label.value : this.label,
    note: note.present ? note.value : this.note,
    spaceId: spaceId.present ? spaceId.value : this.spaceId,
    billId: billId.present ? billId.value : this.billId,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      method: data.method.present ? data.method.value : this.method,
      label: data.label.present ? data.label.value : this.label,
      note: data.note.present ? data.note.value : this.note,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      billId: data.billId.present ? data.billId.value : this.billId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('method: $method, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('spaceId: $spaceId, ')
          ..write('billId: $billId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountMinor,
    type,
    date,
    category,
    method,
    label,
    note,
    spaceId,
    billId,
    vehicleId,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.amountMinor == this.amountMinor &&
          other.type == this.type &&
          other.date == this.date &&
          other.category == this.category &&
          other.method == this.method &&
          other.label == this.label &&
          other.note == this.note &&
          other.spaceId == this.spaceId &&
          other.billId == this.billId &&
          other.vehicleId == this.vehicleId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<int> amountMinor;
  final Value<TransactionType> type;
  final Value<DateTime> date;
  final Value<String?> category;
  final Value<TransactionMethod?> method;
  final Value<String?> label;
  final Value<String?> note;
  final Value<String?> spaceId;
  final Value<String?> billId;
  final Value<String?> vehicleId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.method = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.billId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required int amountMinor,
    required TransactionType type,
    required DateTime date,
    this.category = const Value.absent(),
    this.method = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.billId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountMinor = Value(amountMinor),
       type = Value(type),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<int>? amountMinor,
    Expression<int>? type,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<int>? method,
    Expression<String>? label,
    Expression<String>? note,
    Expression<String>? spaceId,
    Expression<String>? billId,
    Expression<String>? vehicleId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (method != null) 'method': method,
      if (label != null) 'label': label,
      if (note != null) 'note': note,
      if (spaceId != null) 'space_id': spaceId,
      if (billId != null) 'bill_id': billId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<int>? amountMinor,
    Value<TransactionType>? type,
    Value<DateTime>? date,
    Value<String?>? category,
    Value<TransactionMethod?>? method,
    Value<String?>? label,
    Value<String?>? note,
    Value<String?>? spaceId,
    Value<String?>? billId,
    Value<String?>? vehicleId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amountMinor: amountMinor ?? this.amountMinor,
      type: type ?? this.type,
      date: date ?? this.date,
      category: category ?? this.category,
      method: method ?? this.method,
      label: label ?? this.label,
      note: note ?? this.note,
      spaceId: spaceId ?? this.spaceId,
      billId: billId ?? this.billId,
      vehicleId: vehicleId ?? this.vehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (method.present) {
      map['method'] = Variable<int>(
        $TransactionsTable.$convertermethodn.toSql(method.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('method: $method, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('spaceId: $spaceId, ')
          ..write('billId: $billId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ActivityEntriesTable activityEntries = $ActivityEntriesTable(
    this,
  );
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $DashboardSectionsTable dashboardSections =
      $DashboardSectionsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final Index tasksBucket = Index(
    'tasks_bucket',
    'CREATE INDEX tasks_bucket ON tasks (done, due_date)',
  );
  late final Index tasksSpace = Index(
    'tasks_space',
    'CREATE INDEX tasks_space ON tasks (space_id)',
  );
  late final Index activityOwner = Index(
    'activity_owner',
    'CREATE INDEX activity_owner ON activity_entries (owner_type, owner_id)',
  );
  late final Index eventsStart = Index(
    'events_start',
    'CREATE INDEX events_start ON events (start_at)',
  );
  late final Index notificationsDedupe = Index(
    'notifications_dedupe',
    'CREATE UNIQUE INDEX notifications_dedupe ON notifications (dedupe_key)',
  );
  late final Index notificationsCreated = Index(
    'notifications_created',
    'CREATE INDEX notifications_created ON notifications (created_at)',
  );
  late final Index transactionsDate = Index(
    'transactions_date',
    'CREATE INDEX transactions_date ON transactions (date)',
  );
  late final Index transactionsSpace = Index(
    'transactions_space',
    'CREATE INDEX transactions_space ON transactions (space_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    tasks,
    activityEntries,
    profiles,
    dashboardSections,
    events,
    notifications,
    transactions,
    tasksBucket,
    tasksSpace,
    activityOwner,
    eventsStart,
    notificationsDedupe,
    notificationsCreated,
    transactionsDate,
    transactionsSpace,
  ];
}

typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<int?> dueMinutes,
      Value<Priority> priority,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<String?> recurrenceRule,
      Value<int?> reminderOffsetMinutes,
      Value<String?> category,
      Value<String?> spaceId,
      Value<String?> parentTaskId,
      Value<TaskSource> source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<int?> dueMinutes,
      Value<Priority> priority,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<String?> recurrenceRule,
      Value<int?> reminderOffsetMinutes,
      Value<String?> category,
      Value<String?> spaceId,
      Value<String?> parentTaskId,
      Value<TaskSource> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueMinutes => $composableBuilder(
    column: $table.dueMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Priority, Priority, int> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskSource, TaskSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueMinutes => $composableBuilder(
    column: $table.dueMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueMinutes => $composableBuilder(
    column: $table.dueMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Priority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<String> get parentTaskId => $composableBuilder(
    column: $table.parentTaskId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueMinutes = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<String?> parentTaskId = const Value.absent(),
                Value<TaskSource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueMinutes: dueMinutes,
                priority: priority,
                done: done,
                completedAt: completedAt,
                recurrenceRule: recurrenceRule,
                reminderOffsetMinutes: reminderOffsetMinutes,
                category: category,
                spaceId: spaceId,
                parentTaskId: parentTaskId,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueMinutes = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<String?> parentTaskId = const Value.absent(),
                Value<TaskSource> source = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueMinutes: dueMinutes,
                priority: priority,
                done: done,
                completedAt: completedAt,
                recurrenceRule: recurrenceRule,
                reminderOffsetMinutes: reminderOffsetMinutes,
                category: category,
                spaceId: spaceId,
                parentTaskId: parentTaskId,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TaskRow>(table),
                  BaseReferences<_$AppDatabase, $TasksTable, TaskRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityEntriesTableCreateCompanionBuilder =
    ActivityEntriesCompanion Function({
      required String id,
      required String ownerType,
      required String ownerId,
      required ActivityEvent event,
      Value<String?> detail,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$ActivityEntriesTableUpdateCompanionBuilder =
    ActivityEntriesCompanion Function({
      Value<String> id,
      Value<String> ownerType,
      Value<String> ownerId,
      Value<ActivityEvent> event,
      Value<String?> detail,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$ActivityEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityEvent, ActivityEvent, int> get event =>
      $composableBuilder(
        column: $table.event,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityEvent, int> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$ActivityEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityEntriesTable,
          ActivityRow,
          $$ActivityEntriesTableFilterComposer,
          $$ActivityEntriesTableOrderingComposer,
          $$ActivityEntriesTableAnnotationComposer,
          $$ActivityEntriesTableCreateCompanionBuilder,
          $$ActivityEntriesTableUpdateCompanionBuilder,
          (
            ActivityRow,
            BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityRow>,
          ),
          ActivityRow,
          PrefetchHooks Function()
        > {
  $$ActivityEntriesTableTableManager(
    _$AppDatabase db,
    $ActivityEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<ActivityEvent> event = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                event: event,
                detail: detail,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerType,
                required String ownerId,
                required ActivityEvent event,
                Value<String?> detail = const Value.absent(),
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion.insert(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                event: event,
                detail: detail,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityEntriesTable, ActivityRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityEntriesTable,
                    ActivityRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityEntriesTable,
      ActivityRow,
      $$ActivityEntriesTableFilterComposer,
      $$ActivityEntriesTableOrderingComposer,
      $$ActivityEntriesTableAnnotationComposer,
      $$ActivityEntriesTableCreateCompanionBuilder,
      $$ActivityEntriesTableUpdateCompanionBuilder,
      (
        ActivityRow,
        BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityRow>,
      ),
      ActivityRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      Value<String> name,
      Value<String?> email,
      Value<String> avatarInitials,
      required DateTime joinedAt,
      Value<String> currency,
      Value<String> dateFormat,
      Value<int> weekStart,
      Value<String> locale,
      Value<bool> onboardingCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> email,
      Value<String> avatarInitials,
      Value<DateTime> joinedAt,
      Value<String> currency,
      Value<String> dateFormat,
      Value<int> weekStart,
      Value<String> locale,
      Value<bool> onboardingCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> avatarInitials = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
                Value<int> weekStart = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                email: email,
                avatarInitials: avatarInitials,
                joinedAt: joinedAt,
                currency: currency,
                dateFormat: dateFormat,
                weekStart: weekStart,
                locale: locale,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> avatarInitials = const Value.absent(),
                required DateTime joinedAt,
                Value<String> currency = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
                Value<int> weekStart = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                email: email,
                avatarInitials: avatarInitials,
                joinedAt: joinedAt,
                currency: currency,
                dateFormat: dateFormat,
                weekStart: weekStart,
                locale: locale,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$DashboardSectionsTableCreateCompanionBuilder =
    DashboardSectionsCompanion Function({
      required String key,
      Value<bool> enabled,
      required int sortOrder,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DashboardSectionsTableUpdateCompanionBuilder =
    DashboardSectionsCompanion Function({
      Value<String> key,
      Value<bool> enabled,
      Value<int> sortOrder,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DashboardSectionsTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardSectionsTable> {
  $$DashboardSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardSectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardSectionsTable> {
  $$DashboardSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardSectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardSectionsTable> {
  $$DashboardSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DashboardSectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardSectionsTable,
          DashboardSectionRow,
          $$DashboardSectionsTableFilterComposer,
          $$DashboardSectionsTableOrderingComposer,
          $$DashboardSectionsTableAnnotationComposer,
          $$DashboardSectionsTableCreateCompanionBuilder,
          $$DashboardSectionsTableUpdateCompanionBuilder,
          (
            DashboardSectionRow,
            BaseReferences<
              _$AppDatabase,
              $DashboardSectionsTable,
              DashboardSectionRow
            >,
          ),
          DashboardSectionRow,
          PrefetchHooks Function()
        > {
  $$DashboardSectionsTableTableManager(
    _$AppDatabase db,
    $DashboardSectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DashboardSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DashboardSectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardSectionsCompanion(
                key: key,
                enabled: enabled,
                sortOrder: sortOrder,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<bool> enabled = const Value.absent(),
                required int sortOrder,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DashboardSectionsCompanion.insert(
                key: key,
                enabled: enabled,
                sortOrder: sortOrder,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DashboardSectionsTable, DashboardSectionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DashboardSectionsTable,
                    DashboardSectionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardSectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardSectionsTable,
      DashboardSectionRow,
      $$DashboardSectionsTableFilterComposer,
      $$DashboardSectionsTableOrderingComposer,
      $$DashboardSectionsTableAnnotationComposer,
      $$DashboardSectionsTableCreateCompanionBuilder,
      $$DashboardSectionsTableUpdateCompanionBuilder,
      (
        DashboardSectionRow,
        BaseReferences<
          _$AppDatabase,
          $DashboardSectionsTable,
          DashboardSectionRow
        >,
      ),
      DashboardSectionRow,
      PrefetchHooks Function()
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required DateTime startAt,
      Value<DateTime?> endAt,
      Value<bool> allDay,
      Value<int?> reminderOffsetMinutes,
      Value<String?> spaceId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> startAt,
      Value<DateTime?> endAt,
      Value<bool> allDay,
      Value<int?> reminderOffsetMinutes,
      Value<String?> spaceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventRow,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
          EventRow,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                title: title,
                description: description,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                reminderOffsetMinutes: reminderOffsetMinutes,
                spaceId: spaceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime startAt,
                Value<DateTime?> endAt = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                reminderOffsetMinutes: reminderOffsetMinutes,
                spaceId: spaceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, EventRow>(table),
                  BaseReferences<_$AppDatabase, $EventsTable, EventRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventRow,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
      EventRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      required String id,
      required ReminderKind kind,
      required String ownerId,
      required String title,
      Value<String?> body,
      Value<String?> route,
      required String dedupeKey,
      required DateTime createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<String> id,
      Value<ReminderKind> kind,
      Value<String> ownerId,
      Value<String> title,
      Value<String?> body,
      Value<String?> route,
      Value<String> dedupeKey,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderKind, ReminderKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTable,
          NotificationRow,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (
            NotificationRow,
            BaseReferences<_$AppDatabase, $NotificationsTable, NotificationRow>,
          ),
          NotificationRow,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<ReminderKind> kind = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> route = const Value.absent(),
                Value<String> dedupeKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                kind: kind,
                ownerId: ownerId,
                title: title,
                body: body,
                route: route,
                dedupeKey: dedupeKey,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required ReminderKind kind,
                required String ownerId,
                required String title,
                Value<String?> body = const Value.absent(),
                Value<String?> route = const Value.absent(),
                required String dedupeKey,
                required DateTime createdAt,
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion.insert(
                id: id,
                kind: kind,
                ownerId: ownerId,
                title: title,
                body: body,
                route: route,
                dedupeKey: dedupeKey,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotificationsTable, NotificationRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotificationsTable,
                    NotificationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTable,
      NotificationRow,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (
        NotificationRow,
        BaseReferences<_$AppDatabase, $NotificationsTable, NotificationRow>,
      ),
      NotificationRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required int amountMinor,
      required TransactionType type,
      required DateTime date,
      Value<String?> category,
      Value<TransactionMethod?> method,
      Value<String?> label,
      Value<String?> note,
      Value<String?> spaceId,
      Value<String?> billId,
      Value<String?> vehicleId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<int> amountMinor,
      Value<TransactionType> type,
      Value<DateTime> date,
      Value<String?> category,
      Value<TransactionMethod?> method,
      Value<String?> label,
      Value<String?> note,
      Value<String?> spaceId,
      Value<String?> billId,
      Value<String?> vehicleId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionMethod?, TransactionMethod, int>
  get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billId => $composableBuilder(
    column: $table.billId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billId => $composableBuilder(
    column: $table.billId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionMethod?, int> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<String> get billId =>
      $composableBuilder(column: $table.billId, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<TransactionMethod?> method = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<String?> billId = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amountMinor: amountMinor,
                type: type,
                date: date,
                category: category,
                method: method,
                label: label,
                note: note,
                spaceId: spaceId,
                billId: billId,
                vehicleId: vehicleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amountMinor,
                required TransactionType type,
                required DateTime date,
                Value<String?> category = const Value.absent(),
                Value<TransactionMethod?> method = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<String?> billId = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amountMinor: amountMinor,
                type: type,
                date: date,
                category: category,
                method: method,
                label: label,
                note: note,
                spaceId: spaceId,
                billId: billId,
                vehicleId: vehicleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionsTable,
                    TransactionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ActivityEntriesTableTableManager get activityEntries =>
      $$ActivityEntriesTableTableManager(_db, _db.activityEntries);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$DashboardSectionsTableTableManager get dashboardSections =>
      $$DashboardSectionsTableTableManager(_db, _db.dashboardSections);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
