import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moon_phases_extra/features/moon_phase/view_model/moon_calc.dart';
import 'package:moon_phases_extra/features/moon_phase/view_model/moon_phase_view_model.dart';
import 'package:moon_phases_extra/features/moon_phase/widgets/calender_widget.dart';
import 'package:moon_phases_extra/features/moon_phase/widgets/moon_data_widget.dart';
import 'package:moon_phases_extra/features/moon_phase/widgets/moon_widget.dart';
import 'package:moon_phases_extra/features/moon_phase/widgets/wheel_date_picker.dart';
import 'package:moon_phases_extra/utils/public_variables.dart';
import 'package:provider/provider.dart';

class MoonPhaseView extends StatefulWidget {
  const MoonPhaseView({super.key});

  @override
  State<MoonPhaseView> createState() => _MoonPhaseViewState();
}

class _MoonPhaseViewState extends State<MoonPhaseView> {
  double currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
  }

  double get angle {
    if (context.read<MoonPhaseViewModel>().selectedDate.day < 15) {
      currentAngle = currentAngle + (0.0008);
    } else {
      currentAngle = currentAngle - (0.0008);
    }

    return currentAngle;
  }

  @override
  Widget build(BuildContext context) {
    PublicVariables.setPhaseData(
      MoonCalc.getPhase(context.watch<MoonPhaseViewModel>().selectedDate),
    );

    final bool isArabic = PublicVariables.currentLanguage == "ar";

    final TextDirection textDirection =
        isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Consumer<MoonPhaseViewModel>(
              builder: (context, viewModel, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Toggle Hijri/Gregorian
                    if (viewModel.dates.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? "هجري" : "Hijri",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                trackOutlineColor: WidgetStatePropertyAll(
                                  Colors.grey.shade200,
                                ),
                                value: viewModel.showHijri,
                                onChanged: (value) {
                                  viewModel.setShowHijri(value);
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isArabic ? "ميلادي" : "Gregorian",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Moon
                    Center(
                      child: Transform.rotate(
                        angle: angle,
                        child: AppleStyleMoon(
                          date: viewModel.selectedDate,
                          size: MediaQuery.sizeOf(context).width * 0.6,
                          phaseData: PublicVariables.phaseData,
                          rotation: math.pi / 9,
                        ),
                      ),
                    ),

                    // Moon Data
                    Text(
                      PublicVariables.phaseData.phaseName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Date Picker
                    DateWheelPicker(
                      initialDate: viewModel.selectedDate,
                      from: viewModel.startDate,
                      to: viewModel.endDate,
                      onDateChanged: (date) {
                        viewModel.setSelectedDate(date);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Moon Data
                    MoonDataWidget(),

                    const SizedBox(height: 40),

                    // Calender
                    CalenderWidget(
                      showHijri: viewModel.showHijri,
                      dates: viewModel.dates,
                      startDate: viewModel.startDate,
                      endDate: viewModel.endDate,
                      selectedDate: viewModel.selectedDate,
                      setSelectedDate: viewModel.setSelectedDate,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
