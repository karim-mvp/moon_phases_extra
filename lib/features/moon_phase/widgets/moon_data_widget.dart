import 'package:flutter/material.dart';
import 'package:moon_phases_extra/utils/public_variables.dart';
import 'package:moon_phases_extra/utils/strings_manager.dart';

class MoonDataWidget extends StatelessWidget {
  const MoonDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(150)),
      ),
      child: Column(
        children: [
          // Illumination
          _buildRow(
            title: StringsManager.illumination,
            value: "${PublicVariables.illumination}%",
          ),

          // _buildDivider(),

          // // Moonset
          // _buildRow(title: StringsManager.moonset, value: "8:49AM"),

          // _buildDivider(),

          // // Moonrise
          // _buildRow(title: StringsManager.moonrise, value: "8:01PM"),
        ],
      ),
    );
  }

  // Widget _buildDivider() {
  //   return Divider(color: Colors.grey.withAlpha(150));
  // }

  Widget _buildRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Value
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
