import 'package:flutter/material.dart';

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
          subtitle: therapy.endsOn == null
              ? '${therapy.total} aligners'
              : '${therapy.total} aligners · until ${longDate(therapy.endsOn!)}',
        ),
        ShineCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (var i = 0; i < therapy.rows.length; i++) ...[
                if (i > 0) const Divider(indent: 72),
                _AlignerRow(row: therapy.rows[i]),
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

class _AlignerRow extends StatelessWidget {
  const _AlignerRow({required this.row});

  final ScheduleRow row;

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
