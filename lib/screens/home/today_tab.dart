import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../config.dart';
import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';
import 'check_in_card.dart';
import 'home_shell.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({super.key, required this.me, this.now});

  final MeController me;

  /// For tests; defaults to the clock.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final data = me.data!;
    final therapy = data.therapy;
    final current = therapy?.current;
    final name = data.patient.firstName;
    return TabPage(
      onRefresh: me.refresh,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: Wordmark(size: 22),
        ),
        PageTitle(name.isEmpty ? 'Today' : 'Hello, $name'),
        if (therapy == null)
          const CalmMessage(
            key: Key('not-started'),
            icon: Icons.hourglass_empty_rounded,
            title: 'Treatment not started yet',
            body:
                'Your clinic will start your treatment and give you your first aligners. '
                'Your schedule will show here then.',
          )
        else if (current == null)
          CalmMessage(
            icon: Icons.celebration_rounded,
            title: 'All aligners done',
            body: therapy.endsOn == null
                ? 'Well done! Your clinic will tell you what comes next.'
                : 'Your last aligner ended on ${longDate(therapy.endsOn!)}. '
                      'Your clinic will tell you what comes next.',
          )
        else ...[
          _AlignerRingCard(therapy: therapy, current: current, now: now),
          const SizedBox(height: 12),
          const _WearReminder(),
          const SizedBox(height: 24),
          CheckInCard(
            api: me.api,
            aligner: current.aligner,
            onSent: me.addCheckIn,
          ),
        ],
      ],
    );
  }
}

class _AlignerRingCard extends StatelessWidget {
  const _AlignerRingCard({
    required this.therapy,
    required this.current,
    this.now,
  });

  final Therapy therapy;
  final CurrentAligner current;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final progress = current.days == 0 ? 0.0 : current.day / current.days;
    final next = therapy.nextChange;
    final isLast = current.aligner >= therapy.total;
    return ShineCard(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Column(
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: AlignerRingPainter(
                progress: progress,
                track: palette.accentSoft,
                fill: ShineColors.teal,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aligner',
                      style: TextStyle(color: palette.muted, fontSize: 15),
                    ),
                    Text(
                      '${current.aligner}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -2,
                        height: 1.05,
                      ),
                    ),
                    Text(
                      'of ${therapy.total}',
                      style: TextStyle(color: palette.muted, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aligner ${current.aligner} of ${therapy.total}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Day ${current.day} of ${current.days}',
            style: TextStyle(fontSize: 17, color: palette.ink),
          ),
          const SizedBox(height: 4),
          Text(
            isLast
                ? (therapy.endsOn == null
                      ? 'This is your last aligner'
                      : 'Your last aligner, until ${weekdayName(therapy.endsOn!)}')
                : next == null
                ? ''
                : 'Next aligner ${relativeDay(next, now: now)}',
            style: TextStyle(
              fontSize: 15,
              color: palette.accentText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _WearReminder extends StatelessWidget {
  const _WearReminder();

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return ShineCard(
      color: palette.accentSoft,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, color: palette.accentText),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Wear your aligners about ${AppConfig.wearHoursGoal} hours a day. '
              'Take them out only to eat and brush.',
              style: TextStyle(color: palette.ink, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// The big ring on Today: how far into the current aligner the patient is.
class AlignerRingPainter extends CustomPainter {
  const AlignerRingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * 0.075;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    final value = progress.clamp(0.0, 1.0);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        Paint()
          ..color = fill
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = stroke,
      );
    }
  }

  @override
  bool shouldRepaint(AlignerRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.track != track ||
      oldDelegate.fill != fill;
}
