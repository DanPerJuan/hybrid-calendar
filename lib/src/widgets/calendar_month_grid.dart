import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_bloc.dart';
import 'calendar_day_cell.dart';
import '../models/calendar_config.dart';
import '../models/calendar_day_entity.dart';
import '../utils/calendar_utils.dart';

/// Widget displaying the main calendar grid of days.
///
/// This widget renders the weeks of the month as a grid, where each
/// week is a row and each day is a cell. It handles:
/// - Rendering all day cells with appropriate states
/// - Checking selectability for each day
/// - Checking if days are in a selected range
/// - Forwarding tap events to the parent
class CalendarMonthGrid extends StatelessWidget {
  /// WEEKS
  ///
  /// List of weeks to display. Each week is a list of 7 day entities.
  final List<List<CalendarDayEntity>> weeks;

  /// SELECTED DATE
  ///
  /// The currently selected date (for single selection mode).
  final DateTime selectedDate;

  /// CONFIGURATION
  ///
  /// Calendar configuration for accessing settings and styles.
  final CalendarConfig config;

  /// DATE SELECTION CALLBACK
  ///
  /// Callback invoked when a day cell is tapped.
  final Function(CalendarDayEntity) onSelectedDate;

  /// CONSTRUCTOR
  const CalendarMonthGrid({
    super.key,
    required this.weeks,
    required this.selectedDate,
    required this.config,
    required this.onSelectedDate,
  });

  @override
  Widget build(BuildContext context) {
    /// ACCESS CALENDAR BLOC
    ///
    /// Needed to check range selection state for each day.
    CalendarBloc bloc = context.read<CalendarBloc>();

    /// CALENDAR GRID
    ///
    /// Column of rows, where each row represents a week.
    return Column(
      children: weeks.map((week) {
        /// WEEK ROW
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: week.map((day) {
            /// DAY CELL
            ///
            /// Each day in the week is rendered as a CalendarDayCell
            /// with appropriate state properties.
            return CalendarDayCell(
              day: day,

              /// IS SELECTED
              ///
              /// Check if this day matches the selected date.
              isSelected: day.date.isAtSameMomentAs(selectedDate),

              /// IS SELECTABLE
              ///
              /// Check if this day can be selected based on config rules.
              isSelectable: CalendarUtils.isDateSelectable(
                day: day,
                config: config,
              ),

              /// SHOW ADJACENT MONTH DAYS
              showAdjacentMonthDays: config.showAdjacentMonthDays,

              /// ON TAP
              ///
              /// Forward the tap event to parent with the day entity.
              onTap: () => onSelectedDate(day),

              /// CONFIGURATION
              config: config,

              /// IS IN RANGE
              ///
              /// Check if this day is between firstDay and lastDay.
              isInRange: CalendarUtils.isDateInRange(
                date: day.date,
                firstDay: bloc.state.data.firstDay,
                lastDay: bloc.state.data.lastDay,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
