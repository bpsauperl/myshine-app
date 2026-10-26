import 'package:flutter/material.dart';

/// The faded smile-zone outline drawn over the selfie camera: an oval face
/// guide and a box where the lips and teeth go. Also used by the preview to
/// know where to put the illustrative effect.
class SmileGuidePainter extends CustomPainter {
  const SmileGuidePainter({
    this.opacity = defaultOpacity,
    this.strokeWidth = 2.5,
  });

  /// About 35% white: visible, but calm.
  static const double defaultOpacity = 0.35;

  /// The frame the camera and the preview use (width / height).
  static const double frameAspectRatio = 3 / 4;

  final double opacity;
  final double strokeWidth;

  Color get guideColor => Colors.white.withValues(alpha: opacity);

  /// The face oval inside a frame of [size].
  static Rect faceOvalIn(Size size) {
    final width = size.width * 0.64;
    final height = (size.height * 0.62).clamp(0.0, width * 1.38);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.45),
      width: width,
      height: height,
    );
  }

  /// The lips box, in the lower part of the face oval.
  static Rect lipsBoxIn(Size size) {
    final face = faceOvalIn(size);
    return Rect.fromCenter(
      center: Offset(face.center.dx, face.top + face.height * 0.75),
      width: face.width * 0.48,
      height: face.height * 0.14,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final stroke = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.drawOval(faceOvalIn(size), stroke);

    final lips = lipsBoxIn(size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lips, Radius.circular(lips.height / 2)),
      stroke,
    );

    // Small ticks at the box's sides, like a viewfinder.
    final tick = lips.height * 0.35;
    final ticks = Paint()
      ..color = guideColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(lips.left - tick * 1.6, lips.center.dy),
      Offset(lips.left - tick * 0.6, lips.center.dy),
      ticks,
    );
    canvas.drawLine(
      Offset(lips.right + tick * 0.6, lips.center.dy),
      Offset(lips.right + tick * 1.6, lips.center.dy),
      ticks,
    );
  }

  @override
  bool shouldRepaint(SmileGuidePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.strokeWidth != strokeWidth;
}
