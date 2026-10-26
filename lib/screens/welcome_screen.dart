import 'package:flutter/material.dart';

import '../state/session.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'connect_screen.dart';
import 'server_settings_sheet.dart';
import 'simulation/selfie_screen.dart';

/// The friendly entry point before the patient connects with their clinic.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return Scaffold(
      backgroundColor: palette.card,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        key: const Key('welcome-logo'),
                        onLongPress: () => showServerSettings(
                          context,
                          SessionScope.of(context),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Wordmark(size: 26),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const _SmileMark(),
                      const SizedBox(height: 36),
                      Text(
                        'Your Shine smile starts here.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'See a preview of your new smile in a minute, or connect '
                        'with your clinic to follow your treatment day by day.',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.4,
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SelfieScreen(),
                          ),
                        ),
                        child: const Text('See your new smile'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ConnectScreen(),
                          ),
                        ),
                        child: const Text('I have a code from my clinic'),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Shine clear aligners by SmileLabs',
                          style: TextStyle(fontSize: 13, color: palette.muted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A calm teal circle with a smile curve: the welcome illustration.
class _SmileMark extends StatelessWidget {
  const _SmileMark();

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        color: palette.accentSoft,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(painter: _SmilePainter(palette.accentText)),
    );
  }
}

class _SmilePainter extends CustomPainter {
  _SmilePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.78,
        size.width * 0.72,
        size.height * 0.5,
      );
    canvas.drawPath(path, paint);
    final sparkle = Paint()..color = ShineColors.teal;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      size.width * 0.045,
      sparkle,
    );
  }

  @override
  bool shouldRepaint(_SmilePainter oldDelegate) => oldDelegate.color != color;
}
