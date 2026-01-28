import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import 'calendar_month_grid.dart';
import '../models/calendar_config.dart';

/// Widget wrapper that conditionally enables swipe navigation.
///
/// This widget acts as a conditional wrapper that either:
/// - Returns the child directly if swipe is disabled
/// - Wraps the child in _SwipeCalendar if swipe is enabled
class CalendarMonthSwipe extends StatelessWidget {
  /// CHILD WIDGET
  ///
  /// The CalendarMonthGrid to display.
  final CalendarMonthGrid child;

  /// CONFIGURATION
  ///
  /// Calendar configuration to check if swipe is enabled.
  final CalendarConfig config;

  /// CONSTRUCTOR
  const CalendarMonthSwipe({
    super.key,
    required this.child,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    /// CONDITIONAL RENDERING
    ///
    /// If swipe is not enabled, return the child directly.
    /// Otherwise, wrap it in the swipe-enabled widget.
    if (!config.enableSwipe) {
      return child;
    }

    return _SwipeCalendar(config: config, child: child);
  }
}

/// Internal widget implementing swipe navigation between months.
///
/// This widget uses a PageView with 3 pages (previous, current, next month)
/// to enable smooth swipe gestures. It maintains the PageView at page index 1
/// (middle page) and regenerates content when swiping.
///
/// Features:
/// - Smooth swipe transitions
/// - Boundary checking (min/max navigable months)
/// - Automatic page reset to center after navigation
/// - Dynamic aspect ratio based on number of weeks
/// - Platform-specific aspect ratio adjustments
class _SwipeCalendar extends StatefulWidget {
  /// CHILD WIDGET
  final CalendarMonthGrid child;

  /// CONFIGURATION
  final CalendarConfig config;

  /// CONSTRUCTOR
  const _SwipeCalendar({
    required this.child,
    required this.config,
  });

  @override
  State<_SwipeCalendar> createState() => _SwipeCalendarState();
}

class _SwipeCalendarState extends State<_SwipeCalendar> {
  /// PAGE CONTROLLER
  ///
  /// Controls the PageView, always initialized to page 1 (middle page).
  late final PageController _pageController;

  /// IS ANIMATING FLAG
  ///
  /// Prevents multiple simultaneous navigation operations.
  bool _isAnimating = false;

  /// CALENDAR BLOC REFERENCE
  ///
  /// Cached reference to the CalendarBloc for event dispatching.
  late final CalendarBloc bloc;

  /// IS ANDROID FLAG
  ///
  /// Used for platform-specific aspect ratio calculations.
  final isAndroid = Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    bloc = context.read<CalendarBloc>();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// CAN NAVIGATE TO PREVIOUS MONTH
  ///
  /// Checks if navigation to the previous month is allowed based on
  /// the minNavigableMonth configuration.
  ///
  /// Returns true if:
  /// - No minimum month is configured, OR
  /// - Current month is after the minimum month
  bool _canNavigateToPreviousMonth(DateTime currentMonth) {
    if (widget.config.minNavigableMonth == null) return true;

    final minMonth = DateTime(
      widget.config.minNavigableMonth!.year,
      widget.config.minNavigableMonth!.month,
    );
    final current = DateTime(currentMonth.year, currentMonth.month);
    return current.isAfter(minMonth);
  }

  /// CAN NAVIGATE TO NEXT MONTH
  ///
  /// Checks if navigation to the next month is allowed based on
  /// the maxNavigableMonth configuration.
  ///
  /// Returns true if:
  /// - No maximum month is configured, OR
  /// - Current month is before the maximum month
  bool _canNavigateToNextMonth(DateTime currentMonth) {
    if (widget.config.maxNavigableMonth == null) return true;

    final maxMonth = DateTime(
      widget.config.maxNavigableMonth!.year,
      widget.config.maxNavigableMonth!.month,
    );
    final current = DateTime(currentMonth.year, currentMonth.month);
    return current.isBefore(maxMonth);
  }

  /// HANDLE PAGE CHANGED
  ///
  /// Called when the user swipes to a different page.
  ///
  /// Logic:
  /// - Ignores if already animating or still on center page (1)
  /// - Checks if navigation is allowed in the swiped direction
  /// - Dispatches appropriate navigation event to the bloc
  /// - Resets to center page if navigation is not allowed
  void _handlePageChanged(int index, CalendarBloc bloc) {
    /// IGNORE IF ANIMATING OR ON CENTER PAGE
    if (_isAnimating || index == 1) return;

    final canGoBack = _canNavigateToPreviousMonth(bloc.state.data.month);
    final canGoForward = _canNavigateToNextMonth(bloc.state.data.month);

    /// SWIPED TO LEFT PAGE (PREVIOUS MONTH)
    if (index == 0) {
      if (canGoBack) {
        bloc.add(
          CalendarPreviousMonthPressed(
            minDate: widget.config.minNavigableMonth,
          ),
        );
      } else {
        _resetToCenter();
      }
    }
    /// SWIPED TO RIGHT PAGE (NEXT MONTH)
    else if (index == 2) {
      if (canGoForward) {
        bloc.add(
          CalendarNextMonthPressed(
            maxDate: widget.config.maxNavigableMonth,
          ),
        );
      } else {
        _resetToCenter();
      }
    }
  }

  /// RESET TO CENTER
  ///
  /// Animates the PageView back to the center page (index 1).
  /// Used after month navigation or when attempting to navigate beyond boundaries.
  void _resetToCenter() {
    if (!_pageController.hasClients || _isAnimating) return;

    _isAnimating = true;
    _pageController
        .animateToPage(
          1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
        .then((_) {
          _isAnimating = false;
        });
  }

  /// CALCULATE ASPECT RATIO
  ///
  /// Dynamically calculates the aspect ratio for the calendar container
  /// based on the number of weeks displayed.
  ///
  /// Different ratios for:
  /// - 6 weeks (most common)
  /// - 4 weeks (shortest months)
  /// - 5 weeks (default)
  ///
  /// Also accounts for platform differences (Android vs iOS).
  double _aspectRatio() {
    final isSixWeeks = widget.child.weeks.length == 6;
    final isFourWeeks = widget.child.weeks.length == 4;

    if (isAndroid) {
      return isSixWeeks
          ? 1.3
          : isFourWeeks
          ? 1.9
          : 1.5;
    } else {
      return isSixWeeks
          ? 1.4
          : isFourWeeks
          ? 2.0
          : 1.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// BLOC LISTENER
    ///
    /// Listens for state changes and resets to center page after navigation.
    /// This ensures the PageView is always ready for the next swipe.
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        _resetToCenter();
      },
      child: BlocBuilder<CalendarBloc, CalendarState>(
        /// BUILD WHEN
        ///
        /// Only rebuild when relevant data changes:
        /// - Displayed month
        /// - Previous/next month weeks (for swipe)
        /// - Selected date
        buildWhen: (previous, current) =>
            previous.data.month != current.data.month ||
            previous.data.prevWeeks != current.data.prevWeeks ||
            previous.data.nextWeeks != current.data.nextWeeks ||
            previous.data.selectedDate != current.data.selectedDate,
        builder: (context, state) {
          /// ASPECT RATIO CONTAINER
          ///
          /// Maintains consistent height based on week count.
          return AspectRatio(
            aspectRatio: _aspectRatio(),
            child: SizedBox(
              width: double.infinity,

              /// PAGE VIEW
              ///
              /// Three pages: [previous month, current month, next month]
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => _handlePageChanged(index, bloc),
                children: [
                  /// LEFT PAGE (PREVIOUS MONTH)
                  ///
                  /// OverflowBox allows content to exceed AspectRatio constraints
                  /// if needed (for months with different week counts).
                  OverflowBox(
                    maxHeight: double.infinity,
                    child: CalendarMonthGrid(
                      weeks: state.data.prevWeeks,
                      selectedDate: state.data.selectedDate,
                      config: widget.config,
                      onSelectedDate: (dayEntity) => bloc.add(
                        CalendarDateSelected(selectedDate: dayEntity),
                      ),
                    ),
                  ),

                  /// CENTER PAGE (CURRENT MONTH)
                  widget.child,

                  /// RIGHT PAGE (NEXT MONTH)
                  OverflowBox(
                    maxHeight: double.infinity,
                    child: CalendarMonthGrid(
                      weeks: state.data.nextWeeks,
                      selectedDate: state.data.selectedDate,
                      config: widget.config,
                      onSelectedDate: (date) => bloc.add(
                        CalendarDateSelected(selectedDate: date),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
