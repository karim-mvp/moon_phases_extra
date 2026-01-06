import 'package:moon_phases_extra/utils/public_variables.dart';

class StringsManager {
  static bool get _isEnglish => PublicVariables.currentLanguage == 'en';

  // Helper method
  static String _arEn({required String ar, required String en}) {
    return _isEnglish ? en : ar;
  }

  // UI Strings
  static String illumination() => _arEn(en: 'Illumination', ar: 'الإضاءة');
  static String moonrise() => _arEn(en: 'Moonrise', ar: 'شروق القمر');
  static String moonset() => _arEn(en: 'Moonset', ar: 'غروب القمر');

  // Moon Phases
  static String newMoon() => _arEn(en: 'New Moon', ar: 'محاق');
  static String waxingCrescent() =>
      _arEn(en: 'Waxing Crescent', ar: 'هلال متزايد');
  static String firstQuarter() =>
      _arEn(en: 'First Quarter', ar: 'التربيع الأول');
  static String waxingGibbous() =>
      _arEn(en: 'Waxing Gibbous', ar: 'أحدب متزايد');
  static String fullMoon() => _arEn(en: 'Full Moon', ar: 'بدر');
  static String waningGibbous() =>
      _arEn(en: 'Waning Gibbous', ar: 'أحدب متناقص');
  static String lastQuarter() =>
      _arEn(en: 'Last Quarter', ar: 'التربيع الأخير');
  static String waningCrescent() =>
      _arEn(en: 'Waning Crescent', ar: 'هلال متناقص');
}
