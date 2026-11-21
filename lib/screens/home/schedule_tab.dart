import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';
import 'home_shell.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key, required this.me});

  final MeController me;

  @override
  Widget build(BuildContext context) {
    final therapy = me.data!.therapy;
    final changes = <int, CheckIn>{
      for (final checkIn in me.data!.checkIns.reversed)
        if (checkIn.alignerChange && checkIn.aligner != null)
          checkIn.aligner!: checkIn,
    };
    final l10n = context.l10n;
    if (therapy == null || therapy.rows.isEmpty) {
      return TabPage(
        onRefresh: me.refresh,
        children: [
          PageTitle(l10n.tabSchedule),
          CalmMessage(
            icon: Icons.calendar_month_outlined,
            title: l10n.scheduleEmptyTitle,
            body: l10n.scheduleEmptyBody,
          ),
        ],
      );
    }
    final aligners = l10n.scheduleAligners(therapy.total);
    final heading = [
      therapy.series == null ? aligners : l10n.scheduleSeries(therapy.series!, aligners),
      if (therapy.endsOn != null) l10n.scheduleEndsOn(shortDate(l10n, therapy.endsOn!)),
    ].join(' · ');
    final firstNext = therapy.rows.indexWhere((row) => row.state == AlignerState.next);
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(l10n.tabSchedule, subtitle: heading),
        for (var i = 0; i < therapy.rows.length; i++)
          _AlignerRow(
            row: therapy.rows[i],
            checkIn: changes[therapy.rows[i].aligner],
            note: i == firstNext && therapy.rows[i].from != null ? relativeDay(l10n, therapy.rows[i].from!) : null,
            last: i == therapy.rows.length - 1,
          ),
      ],
    );
  }
}

/// One aligner: done ones quiet with a tick, the one in the mouth a black tile,
/// the coming ones with their number in a ring.
class _AlignerRow extends StatelessWidget {
  const _AlignerRow({required this.row, this.checkIn, this.note, this.last = false});

  final ScheduleRow row;

  /// The patient's check-in for switching to this aligner, if any.
  final CheckIn? checkIn;

  /// "Tuesday" next to the next change.
  final String? note;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final isNow = row.state == AlignerState.now;
    final isDone = row.state == AlignerState.done;
    final from = row.from;
    final to = row.to;
    final dates = from != null && to != null
        ? '${shortDate(l10n, from)} – ${shortDate(l10n, to)}'
        : l10n.scheduleDays(row.days);
    final quiet = dark ? const Color(0xFF636366) : const Color(0xFFAEAEB2);
    final onBlack = dark ? Colors.black : Colors.white;

    if (isNow) {
      return Container(
        key: const Key('schedule-now'),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: palette.ink, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: onBlack, shape: BoxShape.circle),
              child: Text('${row.aligner}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.ink)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.commonAlignerNumber('${row.aligner}'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onBlack)),
                  Text(dates, style: TextStyle(fontSize: 13, color: onBlack.withValues(alpha: 0.6))),
                  if (checkIn != null) _CheckedIn(checkIn: checkIn!, color: onBlack.withValues(alpha: 0.6)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: onBlack.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
              child: Text(l10n.scheduleNow, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: onBlack)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: isDone || last
          ? null
          : BoxDecoration(border: Border(bottom: BorderSide(color: palette.hairline, width: 0.5))),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? palette.card : null,
              border: isDone ? null : Border.all(color: dark ? const Color(0xFF48484A) : const Color(0xFFD2D2D7)),
            ),
            child: isDone
                ? Icon(Icons.check_rounded, size: 16, color: ShineColors.tertiary)
                : Text('${row.aligner}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.ink)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.commonAlignerNumber('${row.aligner}'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDone ? ShineColors.tertiary : palette.ink),
                ),
                Text(dates, style: TextStyle(fontSize: 13, color: isDone ? quiet : palette.muted)),
                if (checkIn != null) _CheckedIn(checkIn: checkIn!, color: isDone ? quiet : palette.muted),
              ],
            ),
          ),
          if (note != null) Text(note!, style: TextStyle(fontSize: 13, color: palette.muted)),
        ],
      ),
    );
  }
}

/// "Checked in 29 Oct" with "on time" or "2 days late".
class _CheckedIn extends StatelessWidget {
  const _CheckedIn({required this.checkIn, required this.color});

  final CheckIn checkIn;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final at = checkIn.at;
    final late = checkIn.lateDays;
    final when = at == null
        ? l10n.scheduleCheckedIn
        : l10n.scheduleCheckedInOn(shortDate(l10n, at));
    final timing = late == 0 ? l10n.scheduleOnTime : l10n.commonDaysLate(late);
    return Padding(
      key: Key('checked-in-${checkIn.aligner}'),
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text('$when · $timing', style: TextStyle(fontSize: 13, color: color)),
          ),
        ],
      ),
    );
  }
}
