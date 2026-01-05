import 'package:flutter/material.dart';

class MoonPhaseViewModel extends ChangeNotifier {
  final DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime endDate = DateTime.now().add(const Duration(days: 30));

  DateTime selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
