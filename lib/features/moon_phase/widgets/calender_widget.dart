import 'package:flutter/material.dart';
import 'package:moon_phase/moon_widget.dart';
import 'package:moon_phases_extra/features/moon_phase/model/date_hijri_prayer_model.dart';
import 'package:moon_phases_extra/utils/public_variables.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatelessWidget {
  final bool showHijri;
  final List<DateHijriPrayer> dates;
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime) setSelectedDate;

  const CalenderWidget({
    super.key,
    required this.showHijri,
    required this.dates,
    required this.selectedDate,
    required this.startDate,
    required this.endDate,
    required this.setSelectedDate,
  });

  HijriDate hijriDate(DateTime dateTime) {
    if (dates.isEmpty) {
      return HijriDate();
    }

    return dates.firstWhere((element) {
      final day = element.gregorianDate?.day == dateTime.day;
      final month = element.gregorianDate?.month == dateTime.month;
      final year = element.gregorianDate?.year == dateTime.year;
      return day && month && year;
    }).hijriDate!;
  }

  String get title {
    if (showHijri) {
      return hijriDate(selectedDate).monthName ?? "-";
    }

    return selectedDate.month.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String currentLocale = PublicVariables.currentLanguage;
    final bool isRtl = currentLocale == 'ar';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsetsDirectional.only(top: 20, bottom: 50),
        color: Colors.grey.shade800,
        child: TableCalendar(
          locale: currentLocale,

          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              final selected = isSameDay(day, selectedDate);
              return _dayWidget(
                showHijri: showHijri,
                selected: selected,
                date: day,
                hijriDate: hijriDate(day),
              );
            },
            defaultBuilder: (context, day, focusedDay) {
              final selected = isSameDay(day, selectedDate);
              return _dayWidget(
                showHijri: showHijri,
                selected: selected,
                date: day,
                hijriDate: hijriDate(day),
              );
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
          firstDay: dates.isNotEmpty ? dates.first.gregorianDate! : startDate,
          lastDay: dates.isNotEmpty ? dates.last.gregorianDate! : endDate,
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
            titleTextFormatter:
                showHijri
                    ? (date, locale) {
                      return title;
                    }
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _dayWidget({
    required bool showHijri,
    required bool selected,
    required DateTime date,
    required HijriDate hijriDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: selected ? Colors.blue.withOpacity(0.4) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            showHijri && dates.isNotEmpty
                ? hijriDate.day.toString()
                : date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),

          MoonWidget.image(
            date: date,
            size: 15,
            backgroundImageAsset:
                'packages/moon_phases_extra/assets/images/full_moon.png',
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
