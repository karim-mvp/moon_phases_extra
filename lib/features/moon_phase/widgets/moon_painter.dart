import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:moon_phases_extra/features/moon_phase/model/moon_data_model.dart';

class VerifiedMoonPainter extends CustomPainter {
  final ui.Image image;
  final MoonPhaseData phase;

  VerifiedMoonPainter({required this.image, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2;

    // 1. Draw Moon Image (Clipped to Circle)
    Path circlePath = Path()..addOval(rect);
    canvas.clipPath(circlePath);

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );

    // 2. Shadow Settings
    // Apple uses a dark semi-transparent shadow (~70-85%)
    final shadowPaint =
        Paint()
          ..color = Colors.black.withAlpha(180)
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            10.0,
          ); // Soft Terminator

    // 3. Exact Terminator Geometry
    Path shadowPath = Path();

    // Width 'w' of the elliptical arc.
    // FORMULA: w = Radius * (1 - 2 * Illumination)
    // Illum 0.5 -> w = 0 (Straight line)
    // Illum 1.0 -> w = -R (Full convex)
    // Illum 0.0 -> w = R (Full concave)
    double w = radius * (1 - 2 * phase.illumination).abs();

    // The "Bulge" Rect
    Rect ellipseRect = Rect.fromLTRB(
      center.dx - w,
      rect.top,
      center.dx + w,
      rect.bottom,
    );

    // 4. Draw Shadow Logic (Apple Style / Northern Hemisphere)

    if (phase.isWaxing) {
      // WAXING: Light is GROWING from the RIGHT.
      // Shadow is on the LEFT.

      if (phase.illumination < 0.5) {
        // Crescent: Shadow covers the whole Left half + bulging into the Right half.
        // Shape: Left Semi-Circle + Ellipse
        shadowPath.addArc(
          rect,
          math.pi / 2,
          math.pi,
        ); // Left Semi-Circle (90° to 270°)
        shadowPath.addOval(ellipseRect);
      } else {
        // Gibbous: Shadow is a sliver on the far Left.
        // Shape: Left Semi-Circle MINUS Ellipse
        Path leftSemi = Path()..addArc(rect, math.pi / 2, math.pi);
        Path ellipse = Path()..addOval(ellipseRect);
        shadowPath = Path.combine(PathOperation.difference, leftSemi, ellipse);
      }
    } else {
      // WANING: Light is SHRINKING to the LEFT.
      // Shadow is on the RIGHT.

      if (phase.illumination < 0.5) {
        // Crescent: Shadow covers whole Right half + bulging into Left half.
        // Shape: Right Semi-Circle + Ellipse
        shadowPath.addArc(
          rect,
          -math.pi / 2,
          math.pi,
        ); // Right Semi-Circle (-90° to 90°)
        shadowPath.addOval(ellipseRect);
      } else {
        // Gibbous: Shadow is a sliver on the far Right.
        // Shape: Right Semi-Circle MINUS Ellipse
        Path rightSemi = Path()..addArc(rect, -math.pi / 2, math.pi);
        Path ellipse = Path()..addOval(ellipseRect);
        shadowPath = Path.combine(PathOperation.difference, rightSemi, ellipse);
      }
    }

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant VerifiedMoonPainter oldDelegate) {
    return oldDelegate.phase.illumination != phase.illumination;
  }
}
