import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moon_phase/moon_widget.dart';
import 'package:moon_phases_extra/features/moon_phase/view/moon_phase_view.dart';
import 'package:moon_phases_extra/features/moon_phase/view_model/moon_phase_view_model.dart';
import 'package:moon_phases_extra/utils/public_variables.dart';
import 'package:provider/provider.dart';

void initMoonPhasesLanguage(String language) {
  PublicVariables.setCurrentLanguage(language);

  initializeDateFormatting(language, "");
}

// Main Moon Widget
class AppMoonWidget extends StatelessWidget {
  const AppMoonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoonPhaseViewModel(),
      child: MoonPhaseView(),
    );
  }
}

// Simple Moon
class SimpleMoonWidget extends StatelessWidget {
  final DateTime date;
  final double size;
  final String moonImagePath;
  final Color color;

  const SimpleMoonWidget({
    super.key,
    required this.date,
    required this.size,
    required this.moonImagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MoonWidget.image(
      date: date,
      size: size,
      backgroundImageAsset: moonImagePath,
      earthshineColor: color,
    );
  }
}
