import 'package:easy_localization/easy_localization.dart';

import '../models/calendar_config.dart';
import '../models/calendar_day_entity.dart';

/// Utility class providing helper methods for calendar operations.
///
/// This class contains static methods for:
/// - Checking if dates are selectable
/// - Checking if dates are in a selected range
/// - Determining day position relative to a month
/// - Formatting month and day names with localization
class CalendarUtils {
  /// IS DATE SELECTABLE
  ///
  /// Determines whether a given day can be selected by the user based on
  /// the calendar configuration rules.
  ///
  /// A date is NOT selectable if:
  /// - It's from an adjacent month (not in the displayed month)
  /// - It's before the minimum navigable/selectable date
  /// - It's after the maximum navigable/selectable date
  /// - It's in the disabled dates set
  /// - Its day of week is in the disabled days set
  ///
  /// Returns true if the date can be selected, false otherwise.
  static bool isDateSelectable({
    required CalendarDayEntity day,
    required CalendarConfig config,
  }) {
    /// Create date without time component for accurate comparison
    final DateTime date = DateTime(day.date.year, day.date.month, day.date.day);

    /// CHECK IF DAY IS IN DISPLAYED MONTH
    if (day.position != DayPosition.inMonth) {
      return false;
    }

    /// CHECK MINIMUM NAVIGABLE MONTH
    if (config.minNavigableMonth != null) {
      final minDateOnly = DateTime(
        config.minNavigableMonth!.year,
        config.minNavigableMonth!.month,
        config.minNavigableMonth!.day,
      );

      if (date.isBefore(minDateOnly)) return false;
    }

    /// CHECK MINIMUM SELECTABLE DATE
    if (config.minSelectableDate != null) {
      final minDateOnly = DateTime(
        config.minSelectableDate!.year,
        config.minSelectableDate!.month,
        config.minSelectableDate!.day,
      );

      if (date.isBefore(minDateOnly)) return false;
    }

    /// CHECK MAXIMUM NAVIGABLE MONTH
    if (config.maxNavigableMonth != null) {
      final maxDateOnly = DateTime(
        config.maxNavigableMonth!.year,
        config.maxNavigableMonth!.month + 1,
        config.maxNavigableMonth!.day,
      );
      if (date.isAfter(maxDateOnly)) return false;
    }

    /// CHECK MAXIMUM SELECTABLE DATE
    if (config.maxSelectableDate != null) {
      final maxDateOnly = DateTime(
        config.maxSelectableDate!.year,
        config.maxSelectableDate!.month,
        config.maxSelectableDate!.day,
      );
      if (date.isAfter(maxDateOnly)) return false;
    }

    /// CHECK IF DATE IS IN DISABLED DATES SET
    if (config.disabledDates.any(
      (d) => d.year == day.date.year && d.month == day.date.month && d.day == day.date.day,
    )) {
      return false;
    }

    /// CHECK IF DAY OF WEEK IS DISABLED
    if (config.disabledDaysOfWeek.contains(day.dayOfWeek)) return false;

    /// DATE IS SELECTABLE
    return true;
  }

  /// IS DATE IN RANGE
  ///
  /// Checks if a date falls within a selected date range.
  ///
  /// Returns true if the date is strictly between the first and last day
  /// (exclusive of boundaries). Returns false if either boundary is null.
  static bool isDateInRange({
    required DateTime date,
    required CalendarDayEntity? firstDay,
    required CalendarDayEntity? lastDay,
  }) {
    if (firstDay == null || lastDay == null) return false;

    return date.isAfter(firstDay.date) && date.isBefore(lastDay.date);
  }

  /// GET POSITION
  ///
  /// Determines the position of a date relative to a target month.
  ///
  /// Returns:
  /// - [DayPosition.inMonth] if the date is in the target month
  /// - [DayPosition.beforeMonth] if the date is before the target month
  /// - [DayPosition.afterMonth] if the date is after the target month
  static DayPosition getPosition(
    DateTime date,
    int targetYear,
    int targetMonth,
  ) {
    if (date.year == targetYear && date.month == targetMonth) {
      return DayPosition.inMonth;
    } else if (date.isBefore(DateTime(targetYear, targetMonth))) {
      return DayPosition.beforeMonth;
    } else {
      return DayPosition.afterMonth;
    }
  }

  /// GET MONTH NAME
  ///
  /// Returns the localized full month name for a given date.
  ///
  /// Uses easy_localization package to format the month name according
  /// to the provided locale, with the first letter capitalized.
  ///
  /// Example: "January", "Enero", "Janvier" depending on locale.
  static String getMonthName({
    required DateTime month,
    required String locale,
  }) {
    final date = DateFormat('MMMM', locale).format(
      DateTime(month.year, month.month, 1),
    );

    final monthName = date[0].toUpperCase() + date.substring(1);
    return monthName;
  }

  /// GET DAY NAME
  ///
  /// Returns the localized abbreviated day name for a given date.
  ///
  /// Uses easy_localization package to format the day name according
  /// to the provided locale, with the first letter capitalized.
  ///
  /// Example: "Mon", "Lun", "Lun" depending on locale.
  static String getDayName({
    required DateTime date,
    required String locale,
  }) {
    final day = DateFormat('EEE', locale).format(date);

    final dayName = day[0].toUpperCase() + day.substring(1);
    return dayName;
  }

  /// Returns a list of all available years based on the provided [CalendarConfig].
  ///
  /// If [config.minNavigableMonth] is set, the first year will be that year.
  /// Otherwise, defaults to 100 years before the current year.
  /// If [config.maxNavigableMonth] is set, the last year will be that year.
  /// Otherwise, defaults to 100 years after the current year.
  List<int> availableYears({required CalendarConfig config}) {
    final minYear = config.minNavigableMonth?.year ?? (DateTime.now().year - 100);
    final maxYear = config.maxNavigableMonth?.year ?? (DateTime.now().year + 100);

    return [for (int y = minYear; y <= maxYear; y++) y];
  }

  /// Returns a list of all months (1 to 12).
  List<int> get availableMonths => List.generate(12, (i) => i + 1);

  /// Checks if a given [year] is selectable based on the provided [CalendarConfig].
  ///
  /// A year is considered selectable if **at least one month** in that year
  /// falls within the min and max navigable dates.
  bool isYearSelectable({required int year, required CalendarConfig config}) {
    for (var month in availableMonths) {
      final date = DateTime(year, month);

      if (config.minNavigableMonth != null && date.isBefore(config.minNavigableMonth!)) continue;

      if (config.maxNavigableMonth != null && date.isAfter(config.maxNavigableMonth!)) continue;

      return true;
    }
    return false;
  }

  /// Checks if a specific [month] in a [year] is selectable based on the [CalendarConfig].
  ///
  /// Returns true if the DateTime(year, month) falls within the min and max navigable months.
  bool isMonthSelectable({required int year, required int month, required CalendarConfig config}) {
    final date = DateTime(year, month);

    if (config.minNavigableMonth != null && date.isBefore(config.minNavigableMonth!)) return false;

    if (config.maxNavigableMonth != null && date.isAfter(config.maxNavigableMonth!)) return false;

    return true;
  }
}
