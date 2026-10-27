// Draws the app icon and the launch-screen wordmark as PNGs.
//
//   flutter test tool/brand/render_brand_test.dart
//
// Writes to build/brand/; tool/brand/install.sh copies them into the iOS and
// Android projects.
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/theme.dart';

const _out = 'build/brand';

/// The aligner arch: a teal band with the teeth as white dots.
class ArchIconPainter extends CustomPainter {
  const ArchIconPainter({required this.background, required this.arch});

  final Color background;
  final Color arch;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    final center = Offset(s / 2, s * 0.66);
    final radiusX = s * 0.29;
    final radiusY = s * 0.38;
    final band = s * 0.16;
    const sweep = math.pi * 1.16;
    const start = math.pi + (math.pi * 1.16 - math.pi) / -2;

    final rect = Rect.fromCenter(
      center: center,
      width: radiusX * 2,
      height: radiusY * 2,
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = arch
        ..style = PaintingStyle.stroke
        ..strokeWidth = band
        ..strokeCap = StrokeCap.round,
    );

    const teeth = 14;
    final dot = Paint()..color = background;
    for (var i = 0; i < teeth; i++) {
      final t = start + sweep * (i + 0.5) / teeth;
      final point = Offset(
        center.dx + radiusX * math.cos(t),
        center.dy + radiusY * math.sin(t),
      );
      final edge = (i - (teeth - 1) / 2).abs() / ((teeth - 1) / 2);
      canvas.drawCircle(point, s * (0.03 + 0.022 * edge), dot);
    }
  }

  @override
  bool shouldRepaint(ArchIconPainter oldDelegate) => false;
}

Future<void> _loadInter() async {
  final loader = FontLoader('Inter');
  for (final weight in ['Regular', 'Bold']) {
    final bytes = File('../shine-kit/fonts/Inter-$weight.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<void> _capture(
  WidgetTester tester,
  Widget child,
  Size logical,
  Map<String, double> files,
) async {
  final key = GlobalKey();
  tester.view.physicalSize = logical;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.fromSize(size: logical, child: child),
        ),
      ),
    ),
  );
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    for (final entry in files.entries) {
      final image = await boundary.toImage(pixelRatio: entry.value);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('$_out/${entry.key}')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    }
  });
}

void main() {
  testWidgets('renders the brand images', (tester) async {
    await tester.runAsync(_loadInter);
    addTearDown(tester.view.reset);

    await _capture(
      tester,
      const CustomPaint(
        painter: ArchIconPainter(
          background: Colors.white,
          arch: ShineColors.teal,
        ),
      ),
      const Size(1024, 1024),
      {'icon.png': 1},
    );

    await _capture(
      tester,
      const Center(
        child: Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -34 * 0.03,
              color: ShineColors.ink,
              height: 1,
            ),
            children: [
              TextSpan(
                text: 'my',
                style: TextStyle(color: ShineColors.tealText),
              ),
              TextSpan(text: 'Shine'),
            ],
          ),
        ),
      ),
      const Size(168, 48),
      {
        'LaunchImage.png': 1,
        'LaunchImage@2x.png': 2,
        'LaunchImage@3x.png': 3,
        'launch_image_mdpi.png': 1,
        'launch_image_hdpi.png': 1.5,
        'launch_image_xhdpi.png': 2,
        'launch_image_xxhdpi.png': 3,
        'launch_image_xxxhdpi.png': 4,
      },
    );
  });
}
