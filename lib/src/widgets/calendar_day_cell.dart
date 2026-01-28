import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_bloc.dart';
import '../models/calendar_config.dart';
import '../models/calendar_day_entity.dart';

/// Widget representing a single day cell in the calendar grid.
///
/// This widget displays a circular cell for each day with appropriate:
/// - Background color based on state (selected, disabled, in range, etc.)
/// - Text color and style based on state
/// - Tap handling for date selection
/// - Visibility based on showAdjacentMonthDays config
///
/// The cell's appearance is highly customizable through [CalendarStyle]
/// and responds to various states including selection, range, and selectability.
class CalendarDayCell extends StatelessWidget {
  /// DAY ENTITY
  ///
  /// The day this cell represents, including date and position info.
  final CalendarDayEntity day;

  /// IS SELECTED
  ///
  /// Whether this day is currently selected (for single selection mode).
  final bool isSelected;

  /// IS SELECTABLE
  ///
  /// Whether this day can be selected based on date restrictions.
  final bool isSelectable;

  /// IS IN RANGE
  ///
  /// Whether this day falls within a selected date range.
  final bool isInRange;

  /// SHOW ADJACENT MONTH DAYS
  ///
  /// Whether to show days from adjacent months or leave them empty.
  final bool showAdjacentMonthDays;

  /// ON TAP CALLBACK
  ///
  /// Callback invoked when the cell is tapped.
  final VoidCallback? onTap;

  /// CONFIGURATION
  ///
  /// Calendar configuration for accessing style and settings.
  final CalendarConfig config;

  /// CONSTRUCTOR
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isSelectable,
    required this.isInRange,
    required this.showAdjacentMonthDays,
    this.onTap,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    /// ACCESS CALENDAR BLOC
    ///
    /// Needed to check range selection state (firstDay, lastDay).
    CalendarBloc bloc = context.read<CalendarBloc>();

    /// HIDE ADJACENT MONTH DAYS
    ///
    /// If showAdjacentMonthDays is false and this day is not in the
    /// displayed month, render an empty sized box instead.
    return !showAdjacentMonthDays && day.position != DayPosition.inMonth
        ? SizedBox(
            width: config.style.dayCellSize,
            height: config.style.dayCellSize,
          )
        : GestureDetector(
            /// TAP HANDLER
            ///
            /// Only enable taps for selectable days in the current month.
            onTap: isSelectable && day.position == DayPosition.inMonth ? onTap : null,
            child: Container(
              width: config.style.dayCellSize,
              height: config.style.dayCellSize,

              /// CELL DECORATION
              ///
              /// Uses CalendarStyle to determine background color based on:
              /// - Selection state
              /// - Range boundaries (firstDay, lastDay)
              /// - Selectability
              /// - Position in range
              decoration: BoxDecoration(
                color: config.style.getBoxDayStyle(
                  isSelectable: isSelectable,
                  isSelected:
                      isSelected ||
                      bloc.state.data.firstDay != null && bloc.state.data.firstDay!.date == day.date ||
                      bloc.state.data.lastDay != null && bloc.state.data.lastDay!.date == day.date,
                  isInRange: isInRange,
                  day: day,
                  firstDay: bloc.state.data.firstDay,
                  lastDay: bloc.state.data.lastDay,
                ),
                shape: BoxShape.circle,
              ),

              /// DAY NUMBER TEXT
              child: Center(
                child: Text(
                  '${day.date.day}',

                  /// TEXT STYLE
                  ///
                  /// Uses CalendarStyle to determine text style based on state.
                  style: config.style.getDayStyle(
                    isSelectable: isSelectable,
                    isSelected: isSelected,
                    isInRange: isInRange,
                    firstDay: bloc.state.data.firstDay,
                    lastDay: bloc.state.data.lastDay,
                    day: day,
                  ),
                ),
              ),
            ),
          );
  }
}
