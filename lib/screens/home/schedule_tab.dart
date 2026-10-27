import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/models.dart';
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
    final palette = context.shine;
    if (therapy == null || therapy.rows.isEmpty) {
      return TabPage(
        onRefresh: me.refresh,
        children: const [
          PageTitle('Schedule'),
          CalmMessage(
            icon: Icons.calendar_month_outlined,
            title: 'No schedule yet',
            body:
                'Your aligner schedule shows here once your treatment starts.',
          ),
        ],
      );
    }
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(
          'Schedule',
          subtitle: therapy.series == null
              ? '${therapy.total} aligners'
              : 'Series ${therapy.series} · ${therapy.total} aligners',
        ),
        _Figures(therapy: therapy),
        const SizedBox(height: 12),
        ShineCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (var i = 0; i < therapy.rows.length; i++) ...[
                if (i > 0) const Divider(indent: 72),
                _AlignerRow(
                  row: therapy.rows[i],
                  checkIn: changes[therapy.rows[i].aligner],
                ),
              ],
            ],
          ),
        ),
        if (therapy.endsOn != null) ...[
          const SizedBox(height: 16),
          ShineCard(
            color: palette.accentSoft,
            child: Row(
              children: [
                Icon(Icons.flag_rounded, color: palette.accentText),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your last aligner ends on ${longDate(therapy.endsOn!)}.',
                    style: TextStyle(
                      color: palette.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Started, how far, and the last aligner, side by side.
class _Figures extends StatelessWidget {
  const _Figures({required this.therapy});

  final Therapy therapy;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final done = therapy.rows
        .where((row) => row.state == AlignerState.done)
        .length;
    final percent = therapy.total == 0
        ? 0
        : (done / therapy.total * 100).round();
    Widget figure(String label, String value, {bool accent = false}) =>
        Expanded(
          child: Semantics(
            label: '$label: $value',
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: KitType.label(color: p.secondary)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: KitType.number(
                    size: 22,
                    color: accent ? p.accentText : p.ink,
                  ),
                ),
              ],
            ),
          ),
        );
    return KitTile(
      child: Row(
        children: [
          figure(
            'Started',
            therapy.started == null ? '—' : shortDate(therapy.started!),
          ),
          figure('Done', '$percent %', accent: true),
          figure(
            'Last aligner',
            therapy.endsOn == null ? '—' : shortDate(therapy.endsOn!),
          ),
        ],
      ),
    );
  }
}

class _AlignerRow extends StatelessWidget {
  const _AlignerRow({required this.row, this.checkIn});

  final ScheduleRow row;

  /// The patient's check-in for switching to this aligner, if any.
  final CheckIn? checkIn;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final isNow = row.state == AlignerState.now;
    final isDone = row.state == AlignerState.done;
    final from = row.from;
    final to = row.to;
    final dates = from != null && to != null
        ? '${shortDate(from)} – ${shortDate(to)}'
        : '${row.days} days';
    return Opacity(
      opacity: isDone ? 0.45 : 1,
      child: Container(
        key: isNow ? const Key('schedule-now') : null,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: isNow
            ? BoxDecoration(
                color: palette.accentSoft,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNow ? ShineColors.teal : palette.background,
              ),
              child: isDone
                  ? Icon(Icons.check_rounded, size: 20, color: palette.muted)
                  : Text(
                      '${row.aligner}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isNow ? ShineColors.ink : palette.ink,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aligner ${row.aligner}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(dates, style: TextStyle(color: palette.muted)),
                  if (checkIn != null) _CheckedIn(checkIn: checkIn!),
                ],
              ),
            ),
            if (isNow)
              Text(
                'Today',
                style: TextStyle(
                  color: palette.accentText,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "Checked in 29 Oct" with "on time" or "2 days late".
class _CheckedIn extends StatelessWidget {
  const _CheckedIn({required this.checkIn});

  final CheckIn checkIn;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final at = checkIn.at;
    final late = checkIn.lateDays;
    final when = at == null ? 'Checked in' : 'Checked in ${shortDate(at)}';
    final timing = late == 0
        ? 'on time'
        : late == 1
        ? '1 day late'
        : '$late days late';
    return Padding(
      key: Key('checked-in-${checkIn.aligner}'),
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: p.accentText),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$when · $timing',
              style: KitType.label(color: p.secondary).copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
