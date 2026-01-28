import 'package:flutter/material.dart';
import 'package:hybrid_calendar/hybrid_calendar.dart';

class DefaultHome extends StatelessWidget {
  const DefaultHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Hybrid Calendar',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            HybridCalendar(
              config: CalendarConfig(
                enableSwipe: true,
                firstDayOfWeek: DayOfWeek.friday,
                showAdjacentMonthDays: true,
                showHeader: false,
                mustActivateDateRanges: true,
              ),
              initialSelectedDate: DateTime(2026, 4),
              onDateSelected: (_) {},
            ),

            HybridCalendar(
              config: CalendarConfig(
                disabledDaysOfWeek: {DayOfWeek.sunday},
                minNavigableMonth: DateTime(2025, 11),
                maxNavigableMonth: DateTime(2026, 4),
                showYearPickerHeader: true,
              ),
              onDateSelected: (_) {},
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200, width: 5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: HybridCalendar(
                config: CalendarConfig(
                  mustActivateDateRanges: true,
                  disabledDaysOfWeek: {DayOfWeek.sunday},
                  disabledDates: {DateTime.now().subtract(const Duration(days: 7))},
                  style: CalendarStyle(
                    borderColor: Colors.transparent,
                    selectedDateColor: Colors.lightBlue.shade800,
                    disabledDateColor: Colors.lightBlue.shade100,
                    arrowDisabledColor: Colors.amber,
                    isInRangeDateColor: Colors.lightBlue.shade300,

                    arrowLeftColor: Colors.blueGrey,
                    arrowRightColor: Colors.cyan,

                    selectedDateTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    disabledDateTextStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    defaultDateTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    headerTextStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    weekDayTextStyle: TextStyle(
                      color: Colors.lightBlue.shade400,
                      fontSize: 20,
                    ),

                    dayCellSize: 40,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(0),
                  ),
                ),
                onDateSelected: (day) {
                  debugPrint("Día seleccionado: ${day.date}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
