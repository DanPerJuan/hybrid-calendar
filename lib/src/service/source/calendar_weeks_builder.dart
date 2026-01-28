import '../../models/calendar_config.dart';
import '../../models/calendar_day_entity.dart';

/// Abstract interface for calendar week generation service.
///
/// This interface defines the contract for services that generate
/// the week structure for a calendar month.
///
/// Implementations must provide a method to generate a 2D list of
/// CalendarDayEntity objects representing weeks and days.
abstract interface class CalendarWeeksBuilder {
  /// GENERATE WEEKS
  ///
  /// Generates the calendar week structure for a given month.
  ///
  /// Parameters:
  /// - [year]: The year of the month to generate
  /// - [month]: The month to generate (1-12)
  /// - [config]: Calendar configuration affecting generation (firstDayOfWeek, etc.)
  ///
  /// Returns:
  /// A list of weeks, where each week is a list of 7 [CalendarDayEntity] objects.
  /// Includes days from adjacent months as needed to fill complete weeks.
  List<List<CalendarDayEntity>> call({
    required int year,
    required int month,
    required CalendarConfig config,
  });
}
