import 'package:flutter/material.dart';

import '../models/calendar_config.dart';
import '../models/calendar_day_entity.dart';

/// Styling configuration for the calendar widget.
///
/// This class provides comprehensive styling options for all visual aspects
/// of the calendar including colors, text styles, icons, sizes, and spacing.
/// All properties have sensible defaults that can be overridden as needed.
class CalendarStyle {
  /// COLORS

  /// Border color for the calendar container.
  final Color borderColor;

  /// Background color for the selected date cell.
  final Color selectedDateColor;

  /// Background color for disabled date cells.
  final Color disabledDateColor;

  /// Default background color for date cells.
  final Color defaultDateColor;

  /// Background color for dates within a selected range.
  final Color isInRangeDateColor;

  /// Background color for the year picker dialog.
  final Color yearPickerColor;

  /// TEXT STYLES

  /// Text style for selected date numbers.
  final TextStyle selectedDateTextStyle;

  /// Text style for disabled date numbers.
  final TextStyle disabledDateTextStyle;

  /// Text style for default (selectable) date numbers.
  final TextStyle defaultDateTextStyle;

  /// Text style for the header (month and year).
  final TextStyle headerTextStyle;

  /// Text style for the week day labels row.
  final TextStyle weekDayTextStyle;

  /// NAVIGATION ARROWS

  /// Icon for the left navigation arrow.
  final IconData arrowLeftIcon;

  /// Icon for the right navigation arrow.
  final IconData arrowRightIcon;

  /// Color for the left arrow icon.
  final Color arrowLeftColor;

  /// Color for the right arrow icon.
  final Color arrowRightColor;

  /// Size of the arrow icons.
  final double arrowSize;

  /// Color for disabled navigation arrows.
  final Color arrowDisabledColor;

  /// SIZING AND SPACING

  /// Size of each day cell (width and height).
  final double dayCellSize;

  /// Border radius for the calendar container.
  final double borderRadius;

  /// Internal padding for the calendar container.
  final EdgeInsets padding;

  /// External margin for the calendar container.
  final EdgeInsets margin;

  /// CONSTRUCTOR
  const CalendarStyle({
    /// Colors
    this.borderColor = const Color(0xFFB9BBC6),
    this.selectedDateColor = const Color(0xFF1D1D1B),
    this.disabledDateColor = Colors.transparent,
    this.defaultDateColor = Colors.transparent,
    this.arrowDisabledColor = Colors.grey,
    this.isInRangeDateColor = const Color.fromARGB(255, 204, 204, 207),
    this.yearPickerColor = const Color.fromARGB(255, 247, 247, 249),

    /// Text Styles
    this.selectedDateTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.disabledDateTextStyle = const TextStyle(
      color: Color(0xFFB9BBC6),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.defaultDateTextStyle = const TextStyle(
      color: Color(0xFF1D1D1B),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.headerTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1D1D1B),
    ),
    this.weekDayTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),

    /// Sizing and Spacing
    this.dayCellSize = 38,
    this.borderRadius = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.margin = const EdgeInsets.all(16),

    /// Navigation Arrows
    this.arrowLeftIcon = Icons.keyboard_arrow_left_outlined,
    this.arrowRightIcon = Icons.keyboard_arrow_right_outlined,
    this.arrowLeftColor = Colors.black,
    this.arrowRightColor = Colors.black,
    this.arrowSize = 24,
  });

  /// GET DAY TEXT STYLE
  ///
  /// Returns the appropriate text style for a day cell based on its state.
  ///
  /// Takes into account:
  /// - Whether the day is selected
  /// - Whether it's in a range (for range selection mode)
  /// - Whether it's selectable
  /// - Whether it's the first or last day of a range
  /// - Its position relative to the displayed month
  TextStyle getDayStyle({
    required bool isSelectable,
    required bool isSelected,
    required bool isInRange,
    required CalendarDayEntity day,
    CalendarDayEntity? firstDay,
    CalendarDayEntity? lastDay,
  }) {
    /// SELECTED DAY FROM ADJACENT MONTH
    if (isSelected && day.position != DayPosition.inMonth ||
        firstDay != null && firstDay == day && day.position != DayPosition.inMonth ||
        lastDay != null && lastDay == day && day.position != DayPosition.inMonth) {
      return selectedDateTextStyle;
    }
    /// SELECTED DAY OR RANGE BOUNDARY
    else if (isSelected || firstDay != null && firstDay == day || lastDay != null && lastDay == day) {
      return selectedDateTextStyle;
    }
    /// NOT SELECTABLE OR ADJACENT MONTH (NOT IN RANGE)
    else if (!isSelectable && !isInRange || day.position != DayPosition.inMonth && !isInRange) {
      return disabledDateTextStyle;
    }
    /// IN RANGE BUT NOT SELECTABLE OR ADJACENT MONTH IN RANGE
    else if (isInRange && !isSelectable || day.position != DayPosition.inMonth && isInRange) {
      return disabledDateTextStyle;
    }
    /// NOT SELECTABLE
    else if (!isSelectable) {
      return disabledDateTextStyle;
    }
    /// DEFAULT SELECTABLE DAY
    else {
      return defaultDateTextStyle;
    }
  }

  /// GET DAY BACKGROUND COLOR
  ///
  /// Returns the appropriate background color for a day cell based on its state.
  ///
  /// Uses transparency (withAlpha) for adjacent month days to create
  /// visual hierarchy and distinguish them from the current month.
  Color getBoxDayStyle({
    required bool isSelectable,
    required bool isSelected,
    required bool isInRange,
    required CalendarDayEntity day,
    CalendarDayEntity? firstDay,
    CalendarDayEntity? lastDay,
  }) {
    /// SELECTED DAY FROM ADJACENT MONTH
    if (isSelected && day.position != DayPosition.inMonth ||
        firstDay != null && firstDay == day && day.position != DayPosition.inMonth ||
        lastDay != null && lastDay == day && day.position != DayPosition.inMonth) {
      return selectedDateColor.withAlpha(150);
    }
    /// SELECTED DAY OR RANGE BOUNDARY
    else if (isSelected || firstDay != null && firstDay == day || lastDay != null && lastDay == day) {
      return selectedDateColor;
    }
    /// IN RANGE FROM ADJACENT MONTH
    else if (isInRange && day.position != DayPosition.inMonth) {
      return isInRangeDateColor.withAlpha(180);
    }
    /// IN RANGE
    else if (isInRange) {
      return isInRangeDateColor;
    }
    /// NOT SELECTABLE
    else if (!isSelectable) {
      return disabledDateColor;
    }
    /// DEFAULT
    else {
      return defaultDateColor;
    }
  }
}
