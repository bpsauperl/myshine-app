import 'package:flutter/material.dart';

import 'smile_guide_painter.dart';

/// A simple drawn face used where there is no camera (web, simulators). Not a
/// real person: its smile sits in the guide's lips box so the preview effect shows.
class SampleFace extends StatelessWidget {
  const SampleFace({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: SampleFacePainter(),
      child: SizedBox.expand(),
    );
  }
}

class SampleFacePainter extends CustomPainter {
  const SampleFacePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFD9ECEC), Color(0xFFB9D9DA)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final face = SmileGuidePainter.faceOvalIn(size).deflate(size.width * 0.015);
    final lips = SmileGuidePainter.lipsBoxIn(size);

    // Neck and shoulders.
    final skin = Paint()..color = const Color(0xFFE9B99A);
    canvas.drawRect(
      Rect.fromLTWH(
        face.center.dx - face.width * 0.17,
        face.bottom - face.height * 0.06,
        face.width * 0.34,
        size.height,
      ),
      skin,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          face.bottom + face.height * 0.1,
          size.width * 0.84,
          size.height,
        ),
        Radius.circular(size.width * 0.2),
      ),
      Paint()..color = const Color(0xFF6E8E9A),
    );

    // Hair behind, face, hair on top.
    final hair = Paint()..color = const Color(0xFF4A3528);
    canvas.drawOval(
      face.inflate(face.width * 0.06).translate(0, -face.height * 0.04),
      hair,
    );
    canvas.drawOval(face, skin);
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(0, 0, size.width, face.top + face.height * 0.2),
    );
    canvas.drawOval(
      face.inflate(face.width * 0.04).translate(0, -face.height * 0.03),
      hair,
    );
    canvas.restore();

    // Eyes and brows.
    final eyeY = face.top + face.height * 0.43;
    final eyeDx = face.width * 0.2;
    final dark = Paint()..color = const Color(0xFF2B2B2E);
    final brow = Paint()
      ..color = const Color(0xFF4A3528)
      ..strokeWidth = size.width * 0.012
      ..strokeCap = StrokeCap.round;
    for (final side in [-1, 1]) {
      final c = Offset(face.center.dx + side * eyeDx, eyeY);
      canvas.drawOval(
        Rect.fromCenter(
          center: c,
          width: face.width * 0.09,
          height: face.width * 0.06,
        ),
        dark,
      );
      canvas.drawLine(
        c.translate(-face.width * 0.06, -face.height * 0.07),
        c.translate(face.width * 0.06, -face.height * 0.08),
        brow,
      );
    }

    // Nose.
    canvas.drawLine(
      Offset(face.center.dx, eyeY + face.height * 0.05),
      Offset(face.center.dx - face.width * 0.03, face.top + face.height * 0.62),
      Paint()
        ..color = const Color(0xFFC9977A)
        ..strokeWidth = size.width * 0.01
        ..strokeCap = StrokeCap.round,
    );

    // The smile: lips, then teeth (a little yellow, so whitening shows).
    final mouth = Path()
      ..moveTo(lips.left + lips.width * 0.04, lips.top + lips.height * 0.3)
      ..quadraticBezierTo(
        lips.center.dx,
        lips.top + lips.height * 0.05,
        lips.right - lips.width * 0.04,
        lips.top + lips.height * 0.3,
      )
      ..quadraticBezierTo(
        lips.center.dx,
        lips.bottom + lips.height * 0.25,
        lips.left + lips.width * 0.04,
        lips.top + lips.height * 0.3,
      )
      ..close();
    canvas.drawPath(mouth, Paint()..color = const Color(0xFFB4605A));
    final inner = Path()
      ..moveTo(lips.left + lips.width * 0.12, lips.top + lips.height * 0.34)
      ..quadraticBezierTo(
        lips.center.dx,
        lips.top + lips.height * 0.2,
        lips.right - lips.width * 0.12,
        lips.top + lips.height * 0.34,
      )
      ..quadraticBezierTo(
        lips.center.dx,
        lips.bottom + lips.height * 0.02,
        lips.left + lips.width * 0.12,
        lips.top + lips.height * 0.34,
      )
      ..close();
    canvas.drawPath(inner, Paint()..color = const Color(0xFFE2D3AE));
    canvas.save();
    canvas.clipPath(inner);
    final gap = Paint()
      ..color = const Color(0xFFC8B68C)
      ..strokeWidth = size.width * 0.004;
    for (var i = 1; i < 8; i++) {
      final x = lips.left + lips.width * (0.12 + 0.76 * i / 8);
      canvas.drawLine(Offset(x, lips.top), Offset(x, lips.bottom), gap);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(SampleFacePainter oldDelegate) => false;
}
