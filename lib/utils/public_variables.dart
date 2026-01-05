import 'package:moon_phases_extra/features/moon_phase/model/moon_data_model.dart';

class PublicVariables {
  static String currentLanguage = "en";
  static MoonPhaseData phaseData = MoonPhaseData(0, 0, false, "");
  static int illumination = 0;
  static String moonPhaseName = "";

  static void setPhaseData(MoonPhaseData newPhaseData) {
    phaseData = newPhaseData;
  }

  static void setIllumination(int newIllumination) {
    illumination = newIllumination;
  }

  static void setMoonPhaseName(String newMoonPhaseName) {
    moonPhaseName = newMoonPhaseName;
  }

  static void setCurrentLanguage(String language) {
    currentLanguage = language;
  }
}
