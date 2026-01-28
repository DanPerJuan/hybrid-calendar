import '../models/calendar_day_entity.dart';

/// Base sealed class for all calendar events.
///
/// This sealed class ensures type safety and exhaustive pattern matching
/// for all possible calendar events that can be dispatched to CalendarBloc.
sealed class CalendarEvent {}

/// CALENDAR STARTED EVENT
///
/// Dispatched when the calendar is first initialized.
/// Triggers the setup of the initial calendar state including
/// week generation and date calculations.
class CalendarStarted extends CalendarEvent {}

/// DATE SELECTED EVENT
///
/// Dispatched when a user taps on a date cell.
///
/// Depending on configuration, this event may trigger:
/// - Single date selection (mustActivateDateRanges = false)
/// - Range selection logic (mustActivateDateRanges = true)
class CalendarDateSelected extends CalendarEvent {
  /// The day entity that was selected by the user.
  final CalendarDayEntity selectedDate;

  CalendarDateSelected({required this.selectedDate});
}

/// PREVIOUS MONTH PRESSED EVENT
///
/// Dispatched when the user presses the left navigation arrow
/// to go to the previous month.
///
/// Includes the minimum navigable date to prevent navigation
/// beyond allowed boundaries.
class CalendarPreviousMonthPressed extends CalendarEvent {
  /// Optional minimum date boundary for navigation.
  final DateTime? minDate;

  CalendarPreviousMonthPressed({required this.minDate});
}

/// NEXT MONTH PRESSED EVENT
///
/// Dispatched when the user presses the right navigation arrow
/// to go to the next month.
///
/// Includes the maximum navigable date to prevent navigation
/// beyond allowed boundaries.
class CalendarNextMonthPressed extends CalendarEvent {
  /// Optional maximum date boundary for navigation.
  final DateTime? maxDate;

  CalendarNextMonthPressed({this.maxDate});
}

/// MONTH CHANGED EVENT
///
/// Dispatched when the user selects a specific month from the picker dialog.
/// Navigates directly to the selected month.
class CalendarMonthChanged extends CalendarEvent {
  /// The selected month to navigate to.
  final DateTime selectedMonth;

  CalendarMonthChanged({required this.selectedMonth});
}

/// FIRST DAY SELECTED EVENT
///
/// Dispatched in range selection mode when selecting the first day
/// of a date range (start date).
class CalendarFirstDaySelected extends CalendarEvent {
  /// The first day entity in the range.
  final CalendarDayEntity firstDay;

  CalendarFirstDaySelected({required this.firstDay});
}

/// LAST DAY SELECTED EVENT
///
/// Dispatched in range selection mode when selecting the last day
/// of a date range (end date).
class CalendarLastDaySelected extends CalendarEvent {
  /// The last day entity in the range.
  final CalendarDayEntity lastDay;

  CalendarLastDaySelected({required this.lastDay});
}

/// RANGE DAY SELECTED EVENT
///
/// Internal event used in range selection mode to handle the logic
/// of selecting start and end dates for a range.
///
/// This event determines whether the selected day should be:
/// - The first day of a new range
/// - The last day of the current range
/// - A replacement for the current first day
class CalendarRangeDaySelected extends CalendarEvent {
  /// The day entity selected for range logic.
  final CalendarDayEntity day;

  CalendarRangeDaySelected({required this.day});
}

/// DAY CHANGED EVENT
///
/// Dispatched in single selection mode when a valid date is selected.
/// Updates the selected date in the calendar state.
class CalendarDayChanged extends CalendarEvent {
  /// The newly selected day entity.
  final CalendarDayEntity selectedDate;

  CalendarDayChanged({required this.selectedDate});
}
