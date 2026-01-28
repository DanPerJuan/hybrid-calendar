import 'package:flutter/material.dart';

import '../utils/calendar_utils.dart';

/// Widget displaying the row of week day labels.
///
/// This widget shows the abbreviated names of the days of the week
/// (e.g., Mon, Tue, Wed, etc.) above the calendar grid.
///
/// The labels are automatically localized based on the app's locale
/// and start with the configured first day of week.
class CalendarWeekDaysRow extends StatelessWidget {
  /// WEEK DATES
  ///
  /// List of 7 dates representing one week, used to extract day names.
  /// The dates themselves don't matter; only the weekday is used.
  final List<DateTime> week;

  /// TEXT STYLE
  ///
  /// Optional custom text style for the day labels.
  /// If null, uses the default style from CalendarStyle.
  final TextStyle? style;

  /// CONSTRUCTOR
  const CalendarWeekDaysRow({
    super.key,
    required this.week,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    /// GET LOCALE
    ///
    /// Retrieves the current locale for localizing day names.
    final locale = Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: week
          .map(
            (day) => Expanded(
              /// DAY NAME TEXT
              ///
              /// Displays the localized abbreviated day name (e.g., "Mon").
              child: Center(
                child: Text(
                  CalendarUtils.getDayName(date: day, locale: locale),
                  style: style,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
