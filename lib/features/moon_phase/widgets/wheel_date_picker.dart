import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moon_phases_extra/utils/public_variables.dart';

class DateWheelPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime from;
  final DateTime to;
  final Function(DateTime selectedDate) onDateChanged;

  const DateWheelPicker({
    super.key,
    required this.initialDate,
    required this.from,
    required this.to,
    required this.onDateChanged,
  });

  @override
  State<DateWheelPicker> createState() => _DateWheelPickerState();
}

class _DateWheelPickerState extends State<DateWheelPicker> {
  late FixedExtentScrollController _controller;
  late DateTime _normalizedStart;
  late int _totalIntervals;
  final int hourStep = 2;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeLogic();
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  void _initializeLogic() {
    _normalizedStart = DateTime(
      widget.from.year,
      widget.from.month,
      widget.from.day,
      0,
      0,
      0,
    );

    int totalHours = widget.to.difference(_normalizedStart).inHours;
    _totalIntervals = (totalHours / hourStep).floor();
    _currentIndex = _calculateIndexFromDate(widget.initialDate);
  }

  int _calculateIndexFromDate(DateTime date) {
    int hoursFromStart = date.difference(_normalizedStart).inHours;
    return (hoursFromStart / hourStep).floor();
  }

  @override
  void didUpdateWidget(DateWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.from != oldWidget.from || widget.to != oldWidget.to) {
      _initializeLogic();
      _controller.jumpToItem(_currentIndex);
      return;
    }

    int targetIndex = _calculateIndexFromDate(widget.initialDate);
    if (targetIndex != _controller.selectedItem) {
      _controller.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double rulerHeight = 20.0;
    const double itemWidth = 10.0;

    DateTime currentVisualDate = _normalizedStart.add(
      Duration(hours: _currentIndex * hourStep),
    );

    PublicVariables.setIllumination(
      (PublicVariables.phaseData.illumination * 100).toInt(),
    );

    // Determine language and direction
    final String currentLocale = PublicVariables.currentLanguage;
    final bool isRtl = currentLocale == 'ar';

    // RTL FIX:
    // In LTR: -1 turn moves the "top" of the list to the LEFT.
    // In RTL:  1 turn moves the "top" of the list to the RIGHT.
    final int wheelRotation = isRtl ? 1 : -1;
    final int childRotation = isRtl ? -1 : 1;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date Text
          Text(
            intl.DateFormat(
              "d MMMM '-' h a",
              currentLocale,
            ).format(currentVisualDate),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 10),

          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),

          SizedBox(
            height: rulerHeight + 40,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // [Image of RotatedBox quarter turns diagram]
                RotatedBox(
                  quarterTurns: wheelRotation,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: itemWidth,
                    perspective: 0.0001,
                    squeeze: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });

                      DateTime newDate = _normalizedStart.add(
                        Duration(hours: index * hourStep),
                      );
                      widget.onDateChanged(newDate);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _totalIntervals + 1,
                      builder: (context, index) {
                        return RotatedBox(
                          quarterTurns: childRotation,
                          child: _buildTick(index, rulerHeight, currentLocale),
                        );
                      },
                    ),
                  ),
                ),

                // Center Line Indicator
                IgnorePointer(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    width: 2,
                    height: rulerHeight,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTick(int index, double height, String locale) {
    DateTime tickDate = _normalizedStart.add(Duration(hours: index * hourStep));
    bool isNewDay = tickDate.hour == 0;
    bool isNoon = tickDate.hour == 12;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 1.5,
          height: height,
          color: isNewDay ? Colors.white : Colors.white24,
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 15,
          width: 45, // Slightly wider for Arabic month/day names
          child:
              isNoon
                  ? Center(
                    child: Text(
                      intl.DateFormat(
                        'E',
                        locale,
                      ).format(tickDate).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
