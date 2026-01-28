part of 'calendar_bloc.dart';

/// Data model containing all calendar state information.
///
/// This immutable class holds the complete state of the calendar including:
/// - Current displayed month
/// - Selected date(s)
/// - Generated weeks for current, previous, and next months
/// - Week day labels
/// - Range selection boundaries (firstDay, lastDay)
class CalendarData {
  /// DISPLAYED MONTH
  ///
  /// The currently displayed month in the calendar.
  final DateTime month;

  /// SELECTED DATE
  ///
  /// The currently selected date (for single selection mode).
  final DateTime selectedDate;

  /// CURRENT MONTH WEEKS
  ///
  /// List of weeks for the currently displayed month.
  /// Each week is a list of 7 [CalendarDayEntity] objects.
  final List<List<CalendarDayEntity>> weeks;

  /// PREVIOUS MONTH WEEKS
  ///
  /// Pre-generated weeks for the previous month.
  /// Used for swipe navigation to avoid lag.
  final List<List<CalendarDayEntity>> prevWeeks;

  /// NEXT MONTH WEEKS
  ///
  /// Pre-generated weeks for the next month.
  /// Used for swipe navigation to avoid lag.
  final List<List<CalendarDayEntity>> nextWeeks;

  /// WEEK DAY LABELS
  ///
  /// List of 7 dates representing the week day headers
  /// (e.g., Mon, Tue, Wed, etc.) based on firstDayOfWeek config.
  final List<DateTime> weekDays;

  /// FIRST DAY OF RANGE
  ///
  /// The start date of a selected range (for range selection mode).
  /// Null if no range is being selected.
  final CalendarDayEntity? firstDay;

  /// LAST DAY OF RANGE
  ///
  /// The end date of a selected range (for range selection mode).
  /// Null if range is incomplete or not in range mode.
  final CalendarDayEntity? lastDay;

  /// CONSTRUCTOR
  const CalendarData({
    required this.month,
    required this.prevWeeks,
    required this.nextWeeks,
    required this.selectedDate,
    required this.weeks,
    required this.weekDays,
    required this.firstDay,
    required this.lastDay,
  });

  /// COPY WITH
  ///
  /// Creates a new [CalendarData] instance with updated values.
  ///
  /// This is the standard pattern for immutable state updates in BLoC.
  /// The [mustReload] parameter is a special flag that clears the lastDay
  /// when starting a new range selection.
  CalendarData copyWith({
    DateTime? month,
    DateTime? selectedDate,
    List<List<CalendarDayEntity>>? weeks,
    List<List<CalendarDayEntity>>? nextWeeks,
    List<List<CalendarDayEntity>>? prevWeeks,
    List<DateTime>? weekDays,
    CalendarDayEntity? firstDay,
    CalendarDayEntity? lastDay,
    bool? mustReload,
  }) {
    return CalendarData(
      month: month ?? this.month,
      selectedDate: selectedDate ?? this.selectedDate,
      weeks: weeks ?? this.weeks,
      prevWeeks: prevWeeks ?? this.prevWeeks,
      nextWeeks: nextWeeks ?? this.nextWeeks,
      weekDays: weekDays ?? this.weekDays,
      firstDay: firstDay ?? this.firstDay,

      /// SPECIAL HANDLING FOR LAST DAY
      /// If mustReload is true, reset lastDay to null (start new range)
      lastDay: mustReload != null && mustReload ? null : lastDay ?? this.lastDay,
    );
  }
}

/// Base sealed class for all calendar states.
///
/// Ensures type safety and exhaustive pattern matching for state handling.
sealed class CalendarState {
  /// CALENDAR DATA
  ///
  /// All states contain calendar data, allowing access to current state
  /// information regardless of the specific state type.
  final CalendarData data;

  const CalendarState({
    required this.data,
  });
}

/// INITIAL STATE
///
/// The starting state when the calendar is first created.
/// Initializes with empty weeks and provided or current month.
final class CalendarInitial extends CalendarState {
  CalendarInitial(DateTime? initialMonth)
    : super(
        data: CalendarData(
          month: initialMonth ?? DateTime.now(),
          selectedDate: DateTime.now(),
          weeks: [],
          prevWeeks: [],
          nextWeeks: [],
          weekDays: [],
          firstDay: null,
          lastDay: null,
        ),
      );
}

/// SUCCESS STATE
///
/// The state after successful operations (initialization, navigation, selection).
/// Contains fully populated calendar data ready for display.
final class CalendarSuccess extends CalendarState {
  CalendarSuccess({required super.data});
}
