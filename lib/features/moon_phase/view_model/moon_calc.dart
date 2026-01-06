import 'dart:math' as math;

import 'package:moon_phases_extra/features/moon_phase/model/moon_data_model.dart';
import 'package:moon_phases_extra/utils/strings_manager.dart';

class MoonCalc {
  // This ensures your 2025 testing dates are perfectly aligned
  static final DateTime _refNewMoon = DateTime.utc(2025, 1, 29, 12, 36);
  static const double _synodicMonth = 29.530588853;

  static MoonPhaseData getPhase(DateTime date) {
    Duration diff = date.difference(_refNewMoon);
    double days = diff.inMilliseconds / (1000 * 60 * 60 * 24.0);
    double cycles = days / _synodicMonth;

    // Position 0.0 to 1.0 (0=New, 0.5=Full, 1.0=New)
    double cyclePos = cycles % 1.0;
    if (cyclePos < 0) cyclePos += 1.0;

    double daysOld = cyclePos * _synodicMonth;

    // Illumination Fraction (0.0 to 1.0)
    // We use the cosine of the angle to determine how much we see
    double angle = cyclePos * 2 * math.pi;
    double illumination = (1.0 - math.cos(angle)) / 2.0;

    // Waxing = 0.0 to 0.5 (New -> Full)
    bool isWaxing = cyclePos <= 0.5;

    String name = "";
    if (cyclePos < 0.02 || cyclePos > 0.98) {
      name = StringsManager.newMoon();
    } else if ((cyclePos - 0.5).abs() < 0.02) {
      name = StringsManager.fullMoon();
    } else if ((cyclePos - 0.25).abs() < 0.02) {
      name = StringsManager.firstQuarter(); // Added for precision
    } else if ((cyclePos - 0.75).abs() < 0.02) {
      name = StringsManager.lastQuarter(); // Added for precision
    } else if (cyclePos < 0.25) {
      name = StringsManager.waxingCrescent();
    } else if (cyclePos < 0.5) {
      name = StringsManager.waxingGibbous();
    } else if (cyclePos < 0.75) {
      name = StringsManager.waningGibbous();
    } else {
      name = StringsManager.waningCrescent();
    }

    return MoonPhaseData(daysOld, illumination, isWaxing, name);
  }
}
