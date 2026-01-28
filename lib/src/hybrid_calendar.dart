import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/calendar_bloc.dart';
import 'bloc/calendar_event.dart';
import 'widgets/calendar_header.dart';
import 'widgets/calendar_month_grid.dart';
import 'widgets/calendar_month_swipe.dart';
import 'widgets/calendar_week_days_row.dart';
import 'models/calendar_config.dart';
import 'models/calendar_day_entity.dart';
import 'service/calendar_weeks_builder_impl.dart';
import 'service/source/calendar_weeks_builder.dart';

/// Library to create a highly customizable calendar widget with date selection,
/// range selection, swipe navigation, month/year picker, and extensive styling options.
///
/// This widget provides a complete calendar solution with support for:
/// - Single date selection
/// - Date range selection
/// - Swipe navigation between months
/// - Month/year picker dialog for quick navigation
/// - Customizable styling for all elements
/// - Date restrictions (min/max dates)
/// - Disabled dates and days of week
/// - Adjacent month days visibility
/// - Localized month and day names
///
/// [author] Daniela Perez
/// [module] HybridCalendar
/// [version] 1.0.0
class HybridCalendar extends StatelessWidget {
  /// CONFIGURATION
  ///
  /// Complete configuration object containing all calendar settings including
  /// date restrictions, styling, behavior, and display options.
  final CalendarConfig config;

  /// INITIAL SELECTED DATE
  ///
  /// Optional initial date to display and select when the calendar first loads.
  /// If null, defaults to the current date.
  final DateTime? initialSelectedDate;

  /// DATE SELECTION CALLBACK
  ///
  /// Callback function invoked when a date is selected by the user.
  /// Receives the selected [CalendarDayEntity] containing date and position info.
  final Function(CalendarDayEntity) onDateSelected;

  /// CALENDAR WEEKS BUILDER
  ///
  /// Service responsible for building the calendar weeks structure.
  /// Can be customized by providing a custom implementation.
  final CalendarWeeksBuilder calendarWeeksBuilder;

  /// CONSTRUCTOR
  HybridCalendar({
    super.key,
    required this.config,
    this.initialSelectedDate,
    required this.onDateSelected,
    CalendarWeeksBuilder? calendarWeeksBuilder,
  }) : calendarWeeksBuilder = calendarWeeksBuilder ?? CalendarWeeksBuilderImpl();

  @override
  Widget build(BuildContext context) {
    /// BLOC PROVIDER
    ///
    /// Provides the CalendarBloc to the widget tree, initializing it with
    /// the configuration and starting the calendar setup.
    return BlocProvider(
      create: (context) => CalendarBloc(
        config: config,
        calendarService: calendarWeeksBuilder,
        initialMonth: initialSelectedDate ?? DateTime.now(),
      )..add(CalendarStarted()),
      child: _BaseCalendarView(
        config: config,
        initialSelectedDate: initialSelectedDate,
        onDateSelected: onDateSelected,
      ),
    );
  }
}

/// BASE CALENDAR VIEW
///
/// Internal stateful widget that builds the actual calendar UI based on
/// the current state from CalendarBloc.
class _BaseCalendarView extends StatefulWidget {
  /// CONFIGURATION
  final CalendarConfig config;

  /// INITIAL SELECTED DATE
  final DateTime? initialSelectedDate;

  /// DATE SELECTION CALLBACK
  final Function(CalendarDayEntity) onDateSelected;

  /// CONSTRUCTOR
  const _BaseCalendarView({
    required this.config,
    this.initialSelectedDate,
    required this.onDateSelected,
  });

  @override
  State<_BaseCalendarView> createState() => _BaseCalendarViewState();
}

class _BaseCalendarViewState extends State<_BaseCalendarView> {
  @override
  Widget build(BuildContext context) {
    /// BLOC BUILDER
    ///
    /// Rebuilds the calendar UI whenever the CalendarBloc state changes.
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        /// CALENDAR CONTAINER
        ///
        /// Main container with configurable padding, margin, border, and radius.
        return Container(
          padding: widget.config.style.padding,
          margin: widget.config.style.margin,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.config.style.borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(widget.config.style.borderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// CALENDAR HEADER
                ///
                /// Displays month/year (tappable for picker) and navigation arrows.
                /// Only shown if [showHeader] is enabled in config.
                if (widget.config.showHeader)
                  CalendarHeader(
                    config: widget.config,
                    month: state.data.month,
                    onPreviousMonth: () => context.read<CalendarBloc>().add(
                      CalendarPreviousMonthPressed(
                        minDate: widget.config.minNavigableMonth,
                      ),
                    ),
                    onNextMonth: () => context.read<CalendarBloc>().add(
                      CalendarNextMonthPressed(
                        maxDate: widget.config.maxNavigableMonth,
                      ),
                    ),
                    onMonthSelected: (selectedMonth) => context.read<CalendarBloc>().add(
                      CalendarMonthChanged(selectedMonth: selectedMonth),
                    ),
                  ),

                /// WEEK DAY LABELS ROW
                ///
                /// Displays the names of the days of the week (Mon, Tue, etc.).
                /// Only shown if [showWeekDayLabels] is enabled in config.
                if (widget.config.showWeekDayLabels)
                  CalendarWeekDaysRow(
                    week: state.data.weekDays,
                    style: widget.config.style.weekDayTextStyle,
                  ),

                /// DIVIDER
                ///
                /// Separator between week labels and calendar grid.
                if (widget.config.showWeekDayLabels) const Divider(height: 0, color: Color(0xFFB9BBC6)),

                /// CALENDAR MONTH GRID
                ///
                /// Main calendar grid showing the days of the month.
                /// Wrapped in CalendarMonthSwipe if swipe navigation is enabled.
                CalendarMonthSwipe(
                  config: widget.config,
                  child: CalendarMonthGrid(
                    weeks: state.data.weeks,
                    selectedDate: state.data.selectedDate,
                    config: widget.config,
                    onSelectedDate: (date) {
                      /// DATE SELECTION HANDLER
                      ///
                      /// Dispatches the date selection event to the bloc
                      /// and calls the user-provided callback.
                      context.read<CalendarBloc>().add(
                        CalendarDateSelected(selectedDate: date),
                      );

                      widget.onDateSelected(date);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
