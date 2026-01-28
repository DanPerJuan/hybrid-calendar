import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../utils/calendar_utils.dart';

/// Compact dialog for selecting a **month and year**.
///
/// Displays a horizontal row with three elements:
/// [YEAR] [MONTH] [OK], allowing the user to pick a year and month
/// via dropdowns and confirm their selection using the OK button.
class CalendarMonthYearPickerDialog extends StatefulWidget {
  /// Currently selected month in the calendar
  final DateTime currentMonth;

  /// Calendar configuration, including min/max dates and styles
  final CalendarConfig config;

  /// Callback invoked when the user confirms their selection with the OK button.
  /// Returns a DateTime with the selected year and month.
  final Function(DateTime) onMonthSelected;

  /// Dialog constructor
  const CalendarMonthYearPickerDialog({
    super.key,
    required this.currentMonth,
    required this.config,
    required this.onMonthSelected,
  });

  @override
  State<CalendarMonthYearPickerDialog> createState() => _CalendarMonthYearPickerDialogState();
}

class _CalendarMonthYearPickerDialogState extends State<CalendarMonthYearPickerDialog> {
  /// Currently selected year in the dialog
  late int _selectedYear;

  /// Currently selected month in the dialog
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();

    // Initialize the selected year and month with the current values
    _selectedYear = widget.currentMonth.year;
    _selectedMonth = widget.currentMonth.month;
  }

  @override
  Widget build(BuildContext context) {
    // Detect the current locale to display month names properly
    final locale = Localizations.localeOf(context).languageCode;

    return Dialog(
      backgroundColor: widget.config.style.yearPickerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DIALOG TITLE
            Text(
              'Select Month and Year',
              style: widget.config.style.headerTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            /// COMPACT HORIZONTAL ROW [YEAR] [MONTH] [OK]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// YEAR DROPDOWN
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.config.style.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    underline: const SizedBox(),
                    // Dropdown items: all available years from CalendarUtils
                    items: CalendarUtils().availableYears(config: widget.config).map((year) {
                      // Check if the year is selectable based on the config
                      final selectable = CalendarUtils().isYearSelectable(year: year, config: widget.config);

                      return DropdownMenuItem<int>(
                        value: year,
                        enabled: selectable, // Disable years outside the range
                        child: Text(
                          '$year',
                          style: TextStyle(color: selectable ? Colors.black : Colors.grey),
                        ),
                      );
                    }).toList(),

                    // Update the state when a year is selected
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedYear = value);
                    },
                  ),
                ),

                /// MONTH DROPDOWN
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.config.style.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: _selectedMonth,
                    underline: const SizedBox(),
                    // Dropdown items: all months 1-12
                    items: CalendarUtils().availableMonths.map((month) {
                      // Check if the month is selectable for the selected year
                      final selectable = CalendarUtils().isMonthSelectable(
                        year: _selectedYear,
                        month: month,
                        config: widget.config,
                      );

                      // Get the short month name based on the locale
                      final monthName = CalendarUtils.getMonthName(
                        month: DateTime(_selectedYear, month),
                        locale: locale,
                      );

                      return DropdownMenuItem<int>(
                        value: month,
                        enabled: selectable,
                        child: Text(
                          monthName.substring(0, 3),
                          style: TextStyle(color: selectable ? Colors.black : Colors.grey),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedMonth = value);
                    },
                  ),
                ),

                /// OK BUTTON
                ElevatedButton(
                  onPressed: () {
                    final selectedDate = DateTime(_selectedYear, _selectedMonth, 1);
                    widget.onMonthSelected(selectedDate);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
