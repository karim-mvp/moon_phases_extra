import 'package:flutter/material.dart';
import 'package:moon_phase/moon_widget.dart';
import 'package:moon_phases_extra/utils/public_variables.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final void Function(DateTime) setSelectedDate;

  const CalenderWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.setSelectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Determine language and direction
    final String currentLocale = PublicVariables.currentLanguage;
    final bool isRtl = currentLocale == 'ar';

    return Directionality(
      // This ensures the header arrows and day flow flip for Arabic
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        // Using Directional padding is best practice for packages
        padding: const EdgeInsetsDirectional.only(top: 20, bottom: 50),
        color: Colors.grey.shade800,
        child: TableCalendar(
          // 1. Set the locale for month names and day labels
          locale: currentLocale,

          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              final selected = isSameDay(day, selectedDate);
              return _dayWidget(selected: selected, date: day);
            },
            defaultBuilder: (context, day, focusedDay) {
              final selected = isSameDay(day, selectedDate);
              return _dayWidget(selected: selected, date: day);
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          calendarFormat: CalendarFormat.month,
          firstDay: startDate,
          lastDay: endDate,
          focusedDay: selectedDate,
          availableGestures: AvailableGestures.none,
          onDaySelected: (selectedDay, focusedDay) {
            setSelectedDate(selectedDay);
          },
          rangeSelectionMode: RangeSelectionMode.disabled,
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(color: Colors.red),
            defaultTextStyle: TextStyle(color: Colors.white),
            disabledTextStyle: TextStyle(color: Colors.white),
            todayTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.white),
            isTodayHighlighted: true,
            canMarkersOverflow: false,
            outsideDaysVisible: false,
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white),
            weekendStyle: TextStyle(color: Colors.white),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            // Arrows will automatically flip because of Directionality wrapper
            leftChevronIcon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayWidget({required bool selected, required DateTime date}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // Using withValues or withOpacity is preferred in newer Flutter versions
        // ignore: deprecated_member_use
        color: selected ? Colors.blue.withOpacity(0.4) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),

          MoonWidget.image(
            date: date,
            size: 15,
            backgroundImageAsset: 'assets/images/full_moon.png',
            earthshineColor: Colors.grey.shade900,
          ),
        ],
      ),
    );
  }

  // Helper method to compare dates accurately
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
