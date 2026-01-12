import 'package:flutter/material.dart';
import 'package:moon_phases_extra/features/moon_phase/model/date_hijri_prayer_model.dart';

class MoonPhaseViewModel extends ChangeNotifier {
  final DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime endDate = DateTime.now().add(const Duration(days: 30));

  DateTime selectedDate = DateTime.now();
  bool showHijri = false;
  List<DateHijriPrayer> dates = [];

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setShowHijri(bool value) {
    showHijri = value;
    notifyListeners();
  }

  void setDates(List<DateHijriPrayer> newDates) {
    dates = newDates;
    notifyListeners();
  }
}
