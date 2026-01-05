import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moon_phases_extra/features/moon_phase/model/moon_data_model.dart';
import 'package:moon_phases_extra/features/moon_phase/widgets/moon_painter.dart';

class AppleStyleMoon extends StatefulWidget {
  final DateTime date;
  final double size;
  final MoonPhaseData phaseData;
  final double rotation;

  const AppleStyleMoon({
    super.key,
    required this.date,
    this.size = 300,
    required this.phaseData,
    this.rotation = 0.0,
  });

  @override
  State<AppleStyleMoon> createState() => _AppleStyleMoonState();
}

class _AppleStyleMoonState extends State<AppleStyleMoon> {
  ui.Image? _moonImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final String assetPath =
        'packages/moon_phases_extra/assets/images/full_moon.png';
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(() {
        _moonImage = frame.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_moonImage == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
      );
    }

    return Transform.rotate(
      angle: widget.rotation,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: VerifiedMoonPainter(
            image: _moonImage!,
            phase: widget.phaseData,
          ),
        ),
      ),
    );
  }
}
