import '../models/calendar_config.dart';
import '../models/calendar_day_entity.dart';
import '../utils/calendar_utils.dart';
import 'source/calendar_weeks_builder.dart';

/// Default implementation of the calendar weeks builder service.
///
/// This service generates the complete week structure for a calendar month,
/// including days from adjacent months to fill complete weeks.
///
/// The generation algorithm:
/// 1. Determines the first and last day of the target month
/// 2. Calculates the start date (may be in previous month)
/// 3. Calculates the end date (may be in next month)
/// 4. Generates complete weeks (7 days each) between start and end
/// 5. Assigns position (inMonth, beforeMonth, afterMonth) to each day
class CalendarWeeksBuilderImpl implements CalendarWeeksBuilder {
  @override
  List<List<CalendarDayEntity>> call({
    required int year,
    required int month,
    required CalendarConfig config,
  }) {
    /// MONTH BOUNDARIES
    ///
    /// Calculate the first and last day of the target month.
    final DateTime firstDayOfMonth = DateTime.utc(year, month, 1);
    final DateTime lastDayOfMonth = DateTime.utc(year, month + 1, 0);

    /// FIRST DAY OF WEEK POSITION
    ///
    /// Convert DayOfWeek enum to weekday integer (1-7, Monday-Sunday).
    final int dayPosition = config.firstDayOfWeek.index + 1;

    /// CALCULATE START DATE
    ///
    /// The start date is the first day to display in the calendar,
    /// which may be in the previous month if the month doesn't start
    /// on the configured first day of week.
    ///
    /// Example: If month starts on Wednesday but firstDayOfWeek is Monday,
    /// start date will be the Monday before the 1st.
    final int weekdayOffset = (firstDayOfMonth.weekday - dayPosition + 7) % 7;
    DateTime startDate = firstDayOfMonth.subtract(Duration(days: weekdayOffset));

    /// CALCULATE END DATE
    ///
    /// The end date is the last day to display in the calendar,
    /// which may be in the next month to complete the final week.
    ///
    /// The calendar should end on the day before the first day of week.
    final int lastWeekday = ((dayPosition + 6 - 1) % 7) + 1;
    final int weekdayToAdd = (lastWeekday - lastDayOfMonth.weekday + 7) % 7;
    DateTime endDate = lastDayOfMonth.add(Duration(days: weekdayToAdd));

    /// GENERATE WEEKS
    ///
    /// Iterate through dates from start to end, creating weeks of 7 days.
    final List<List<CalendarDayEntity>> weeks = [];
    DateTime currentDate = startDate;

    /// ITERATE UNTIL END DATE
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final List<CalendarDayEntity> week = [];

      /// GENERATE ONE WEEK (7 DAYS)
      for (int i = 0; i < 7; i++) {
        /// DETERMINE DAY POSITION
        ///
        /// Calculate whether this day is in the target month,
        /// before it, or after it.
        final monthPosition = CalendarUtils.getPosition(
          currentDate,
          year,
          month,
        );

        /// CREATE DAY ENTITY
        week.add(
          CalendarDayEntity(
            date: currentDate,
            position: monthPosition,
          ),
        );

        /// ADVANCE TO NEXT DAY
        currentDate = currentDate.add(const Duration(days: 1));
      }

      /// ADD COMPLETED WEEK
      weeks.add(week);
    }

    return weeks;
  }
}
