import '../style/calendar_style.dart';

/// Enum representing the days of the week.
///
/// Used to configure the first day of the week and to disable specific days.
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Enum representing the position of a day relative to the displayed month.
///
/// - [inMonth]: Day belongs to the currently displayed month
/// - [beforeMonth]: Day belongs to the previous month (adjacent days)
/// - [afterMonth]: Day belongs to the next month (adjacent days)
enum DayPosition {
  inMonth,
  beforeMonth,
  afterMonth,
}

/// Configuration class for customizing the calendar behavior and appearance.
///
/// This class provides comprehensive configuration options including:
/// - Navigation limits (min/max navigable months)
/// - Selection limits (min/max selectable dates)
/// - Disabled dates and days of week
/// - Display options (header, week labels, adjacent days)
/// - Styling configuration
/// - Feature toggles (swipe navigation, date ranges)
class CalendarConfig {
  /// NAVIGATION LIMITS

  /// Minimum month that can be navigated to.
  ///
  /// If null, there is no lower limit. Users won't be able to navigate
  /// to months before this date.
  final DateTime? minNavigableMonth;

  /// Maximum month that can be navigated to.
  ///
  /// If null, there is no upper limit. Users won't be able to navigate
  /// to months after this date.
  final DateTime? maxNavigableMonth;

  /// SELECTION LIMITS

  /// Minimum date that can be selected by the user.
  ///
  /// Dates before this date will appear as disabled and cannot be selected.
  /// Also sets [minNavigableMonth] if it's not explicitly provided.
  final DateTime? minSelectableDate;

  /// Maximum date that can be selected by the user.
  ///
  /// Dates after this date will appear as disabled and cannot be selected.
  final DateTime? maxSelectableDate;

  /// DISABLED DATES

  /// Set of specific dates that should be disabled.
  ///
  /// Dates in this set will be shown as disabled regardless of other settings.
  /// Useful for blocking specific holidays, unavailable dates, etc.
  final Set<DateTime> disabledDates;

  /// Set of days of the week that should always be disabled.
  ///
  /// For example, to disable weekends: {DayOfWeek.saturday, DayOfWeek.sunday}
  final Set<DayOfWeek> disabledDaysOfWeek;

  /// DISPLAY OPTIONS

  /// First day of the week to display in the calendar.
  ///
  /// Default is Monday. Change to Sunday for US-style calendars.
  final DayOfWeek firstDayOfWeek;

  /// Whether to show days from adjacent months.
  ///
  /// When true, days from the previous and next month are shown in gray.
  /// When false, those cells are left empty.
  final bool showAdjacentMonthDays;

  /// Whether to show the calendar header with month/year and navigation arrows.
  final bool showHeader;

  /// Whether to show the row with week day labels (Mon, Tue, Wed, etc.).
  final bool showWeekDayLabels;

  /// Whether to show the year picker header.
  final bool showYearPickerHeader;

  /// STYLING

  /// Complete styling configuration for the calendar.
  ///
  /// Includes colors, text styles, icons, sizes, and spacing.
  final CalendarStyle style;

  /// FEATURES

  /// Enable swipe gestures to navigate between months.
  ///
  /// When true, users can swipe left/right to change months.
  /// When false, navigation is only possible through header arrows.
  final bool enableSwipe;

  /// Enable date range selection mode.
  ///
  /// When true, user can select a start date and end date to create a range.
  /// When false, only single date selection is allowed.
  final bool mustActivateDateRanges;

  /// CONSTRUCTOR
  CalendarConfig({
    /// Navigation limits
    DateTime? minNavigableMonth,
    this.maxNavigableMonth,

    /// Selection limits
    this.minSelectableDate,
    this.maxSelectableDate,

    /// Disabled dates
    this.disabledDates = const {},
    this.disabledDaysOfWeek = const {},

    /// Display options
    this.firstDayOfWeek = DayOfWeek.monday,
    this.showAdjacentMonthDays = true,
    this.showHeader = true,
    this.showWeekDayLabels = true,
    this.showYearPickerHeader = true,

    /// Styling
    this.style = const CalendarStyle(),

    /// Features
    this.enableSwipe = false,
    this.mustActivateDateRanges = false,
  }) : minNavigableMonth = minNavigableMonth ?? minSelectableDate;
}
