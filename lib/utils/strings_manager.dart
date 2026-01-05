import 'package:moon_phases_extra/utils/public_variables.dart';

class StringsManager {
  static final bool _isEnglish = PublicVariables.currentLanguage == 'en';

  static String get illumination => _isEnglish ? 'Illumination' : 'الإضاءة';
  static String get moonrise => _isEnglish ? 'Moonrise' : 'شروق القمر';
  static String get moonset => _isEnglish ? 'Moonset' : 'غروب القمر';

  // Moon Phases
  static String get newMoon => _isEnglish ? 'New Moon' : 'محاق';
  static String get waxingCrescent =>
      _isEnglish ? 'Waxing Crescent' : 'هلال متزايد';
  static String get firstQuarter =>
      _isEnglish ? 'First Quarter' : 'التربيع الأول';
  static String get waxingGibbous =>
      _isEnglish ? 'Waxing Gibbous' : 'أحدب متزايد';
  static String get fullMoon => _isEnglish ? 'Full Moon' : 'بدر';
  static String get waningGibbous =>
      _isEnglish ? 'Waning Gibbous' : 'أحدب متناقص';
  static String get lastQuarter =>
      _isEnglish ? 'Last Quarter' : 'التربيع الأخير';
  static String get waningCrescent =>
      _isEnglish ? 'Waning Crescent' : 'هلال متناقص';
}
