import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../utils/calendar_utils.dart';
import 'calendar_month_year_picker_dialog.dart';

/// Widget displaying the calendar header with month/year and navigation.
///
/// This widget shows:
/// - Current month and year (localized) - tappable to open month/year picker
/// - Left arrow button for previous month
/// - Right arrow button for next month
///
/// The navigation arrows are automatically disabled when reaching
/// the configured min/max navigable months.
class CalendarHeader extends StatelessWidget {
  /// DISPLAYED MONTH
  ///
  /// The currently displayed month to show in the header.
  final DateTime month;

  /// PREVIOUS MONTH CALLBACK
  ///
  /// Callback invoked when the left arrow is pressed.
  final VoidCallback onPreviousMonth;

  /// NEXT MONTH CALLBACK
  ///
  /// Callback invoked when the right arrow is pressed.
  final VoidCallback onNextMonth;

  /// MONTH SELECTED CALLBACK
  ///
  /// Callback invoked when a month is selected from the picker dialog.
  final Function(DateTime) onMonthSelected;

  /// CONFIGURATION
  ///
  /// Calendar configuration for accessing style and navigation limits.
  final CalendarConfig config;

  /// CONSTRUCTOR
  const CalendarHeader({
    super.key,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onMonthSelected,
    required this.config,
  });

  /// SHOW MONTH YEAR PICKER
  ///
  /// Displays the month and year selection dialog.
  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CalendarMonthYearPickerDialog(
        currentMonth: month,
        config: config,
        onMonthSelected: onMonthSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// GET LOCALE
    ///
    /// Retrieves the current locale for localizing month names.
    final locale = Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// MONTH AND YEAR TEXT (TAPPABLE)
        ///
        /// Displays the localized month name and year (e.g., "January 2026").
        /// Tapping opens the month/year picker dialog.
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showMonthYearPicker(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${CalendarUtils.getMonthName(month: month, locale: locale)} ${month.year}',
                    style: config.style.headerTextStyle,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: config.style.headerTextStyle.color,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        /// NAVIGATION ARROWS
        Row(
          spacing: 10,
          children: [
            /// LEFT ARROW (PREVIOUS MONTH)
            ///
            /// Disabled (grayed out) when at minimum navigable month.
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onPreviousMonth,
                child: Icon(
                  Icons.keyboard_arrow_left_outlined,

                  /// ARROW COLOR
                  ///
                  /// Shows disabled color when at minimum month boundary.
                  color:
                      config.minNavigableMonth != null &&
                          config.minNavigableMonth!.month == month.month &&
                          config.minNavigableMonth!.year == month.year
                      ? config.style.arrowDisabledColor
                      : config.style.arrowLeftColor,
                  size: 24,
                ),
              ),
            ),

            /// RIGHT ARROW (NEXT MONTH)
            ///
            /// Disabled (grayed out) when at maximum navigable month.
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onNextMonth,
                child: Icon(
                  Icons.keyboard_arrow_right_outlined,

                  /// ARROW COLOR
                  ///
                  /// Shows disabled color when at maximum month boundary.
                  color:
                      config.maxNavigableMonth != null &&
                          config.maxNavigableMonth!.month == month.month &&
                          config.maxNavigableMonth!.year == month.year
                      ? config.style.arrowDisabledColor
                      : config.style.arrowRightColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
