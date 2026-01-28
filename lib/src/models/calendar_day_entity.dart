import 'calendar_config.dart';

/// Entity representing a single day in the calendar.
///
/// This class encapsulates a calendar day with its date and position context,
/// providing helper methods and properties for working with calendar logic.
class CalendarDayEntity {
  /// DATE
  ///
  /// The actual date this entity represents.
  final DateTime date;

  /// POSITION
  ///
  /// The position of this day relative to the displayed month.
  /// Can be: inMonth, beforeMonth, or afterMonth.
  final DayPosition position;

  /// CONSTRUCTOR
  CalendarDayEntity({
    required this.date,
    required this.position,
  });

  /// DAY OF WEEK GETTER
  ///
  /// Returns the day of the week for this date as a [DayOfWeek] enum value.
  /// Converts from DateTime.weekday (1-7, Monday-Sunday) to DayOfWeek enum.
  DayOfWeek get dayOfWeek {
    return DayOfWeek.values[date.weekday - 1];
  }

  /// TO STRING
  ///
  /// Returns a string representation of this entity for debugging.
  @override
  String toString() => 'CalendarDayEntity(date: $date, position: $position)';

  /// EQUALITY OPERATOR
  ///
  /// Two CalendarDayEntity objects are equal if they have the same
  /// date and position.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDayEntity &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          position == other.position;

  /// HASH CODE
  ///
  /// Generates hash code based on date and position for use in collections.
  @override
  int get hashCode => date.hashCode ^ position.hashCode;
}
