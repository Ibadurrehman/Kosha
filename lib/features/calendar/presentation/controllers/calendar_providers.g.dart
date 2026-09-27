// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCalendarView)
final selectedCalendarViewProvider = SelectedCalendarViewProvider._();

final class SelectedCalendarViewProvider
    extends $NotifierProvider<SelectedCalendarView, CalendarView> {
  SelectedCalendarViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCalendarViewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCalendarViewHash();

  @$internal
  @override
  SelectedCalendarView create() => SelectedCalendarView();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarView>(value),
    );
  }
}

String _$selectedCalendarViewHash() =>
    r'e75dbc19f884f3aaf57e0152d7205b42db28ddfc';

abstract class _$SelectedCalendarView extends $Notifier<CalendarView> {
  CalendarView build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CalendarView, CalendarView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalendarView, CalendarView>,
              CalendarView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The day the Month/Week grid is centred on and the Agenda is showing.

@ProviderFor(SelectedCalendarDate)
final selectedCalendarDateProvider = SelectedCalendarDateProvider._();

/// The day the Month/Week grid is centred on and the Agenda is showing.
final class SelectedCalendarDateProvider
    extends $NotifierProvider<SelectedCalendarDate, DateTime> {
  /// The day the Month/Week grid is centred on and the Agenda is showing.
  SelectedCalendarDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCalendarDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCalendarDateHash();

  @$internal
  @override
  SelectedCalendarDate create() => SelectedCalendarDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedCalendarDateHash() =>
    r'f1dfdd2d260f34c8cf11d707fe059ebf83e547c9';

/// The day the Month/Week grid is centred on and the Agenda is showing.

abstract class _$SelectedCalendarDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Every task with a due date, every event starting, and every bill falling
/// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
/// than in the widget so a 500-item month renders without re-scanning the
/// full list per cell (section 6.4's stated performance target).
///
/// Only open tasks are included, the same rule Home's Upcoming section uses:
/// a completed task drops off the calendar the way it drops off every other
/// list once it is done.

@ProviderFor(calendarItemsByDay)
final calendarItemsByDayProvider = CalendarItemsByDayFamily._();

/// Every task with a due date, every event starting, and every bill falling
/// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
/// than in the widget so a 500-item month renders without re-scanning the
/// full list per cell (section 6.4's stated performance target).
///
/// Only open tasks are included, the same rule Home's Upcoming section uses:
/// a completed task drops off the calendar the way it drops off every other
/// list once it is done.

final class CalendarItemsByDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, List<CalendarItem>>>,
          Map<DateTime, List<CalendarItem>>,
          Stream<Map<DateTime, List<CalendarItem>>>
        >
    with
        $FutureModifier<Map<DateTime, List<CalendarItem>>>,
        $StreamProvider<Map<DateTime, List<CalendarItem>>> {
  /// Every task with a due date, every event starting, and every bill falling
  /// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
  /// than in the widget so a 500-item month renders without re-scanning the
  /// full list per cell (section 6.4's stated performance target).
  ///
  /// Only open tasks are included, the same rule Home's Upcoming section uses:
  /// a completed task drops off the calendar the way it drops off every other
  /// list once it is done.
  CalendarItemsByDayProvider._({
    required CalendarItemsByDayFamily super.from,
    required (DateTime, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'calendarItemsByDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calendarItemsByDayHash();

  @override
  String toString() {
    return r'calendarItemsByDayProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Map<DateTime, List<CalendarItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<DateTime, List<CalendarItem>>> create(Ref ref) {
    final argument = this.argument as (DateTime, DateTime);
    return calendarItemsByDay(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarItemsByDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarItemsByDayHash() =>
    r'ba9e818e45984ceb83d967d597dcb74d31df1281';

/// Every task with a due date, every event starting, and every bill falling
/// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
/// than in the widget so a 500-item month renders without re-scanning the
/// full list per cell (section 6.4's stated performance target).
///
/// Only open tasks are included, the same rule Home's Upcoming section uses:
/// a completed task drops off the calendar the way it drops off every other
/// list once it is done.

final class CalendarItemsByDayFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<DateTime, List<CalendarItem>>>,
          (DateTime, DateTime)
        > {
  CalendarItemsByDayFamily._()
    : super(
        retry: null,
        name: r'calendarItemsByDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every task with a due date, every event starting, and every bill falling
  /// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
  /// than in the widget so a 500-item month renders without re-scanning the
  /// full list per cell (section 6.4's stated performance target).
  ///
  /// Only open tasks are included, the same rule Home's Upcoming section uses:
  /// a completed task drops off the calendar the way it drops off every other
  /// list once it is done.

  CalendarItemsByDayProvider call(DateTime from, DateTime to) =>
      CalendarItemsByDayProvider._(argument: (from, to), from: this);

  @override
  String toString() => r'calendarItemsByDayProvider';
}
