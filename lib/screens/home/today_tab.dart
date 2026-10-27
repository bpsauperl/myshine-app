import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/models.dart';
import '../../config.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../util/dates.dart';
import '../../widgets/common.dart';
import 'check_in_card.dart';

/// Today: the aligner as the hero, the number big, the facts in tiles below,
/// then the check-in.
class TodayTab extends StatefulWidget {
  const TodayTab({super.key, required this.me, this.now, this.onOpenTab});

  final MeController me;

  /// For tests; defaults to the clock.
  final DateTime? now;

  /// Switches the app to another tab (2 is Schedule).
  final ValueChanged<int>? onOpenTab;

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  final _checkInKey = GlobalKey();

  void _goToCheckIn() {
    final target = _checkInKey.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.me.data!;
    final therapy = data.therapy;
    final current = therapy?.current;
    final p = context.kit;
    final l10n = context.l10n;
    final today = widget.now ?? DateTime.now();
    final name = data.patient.firstName;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: widget.me.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        KitSize.gutter,
                        14,
                        KitSize.gutter,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headerDate(l10n, today),
                            style: KitType.label(color: p.secondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name.isEmpty
                                ? l10n.tabToday
                                : l10n.todayHello(name),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: p.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (therapy == null)
                      _Waiting(
                        key: const Key('not-started'),
                        icon: Icons.hourglass_empty_rounded,
                        title: l10n.todayNotStartedTitle,
                        body: l10n.todayNotStartedBody,
                      )
                    else if (current == null)
                      _Waiting(
                        icon: Icons.celebration_rounded,
                        title: l10n.todayAllDoneTitle,
                        body: therapy.endsOn == null
                            ? l10n.todayAllDoneBody
                            : l10n.todayAllDoneBodyWithDate(
                                longDate(l10n, therapy.endsOn!),
                              ),
                      )
                    else ...[
                      KitArchHero(
                        height: 220,
                        semanticLabel: l10n.todayAlignerLabel,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: KitSize.gutter,
                        ),
                        child: _Hero(
                          therapy: therapy,
                          current: current,
                          onCheckIn: therapy.checkIn.canCheckIn
                              ? _goToCheckIn
                              : null,
                          onSchedule: widget.onOpenTab == null
                              ? null
                              : () => widget.onOpenTab!(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      KitPanel(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Facts(
                              therapy: therapy,
                              current: current,
                              now: today,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 18,
                                  color: p.accentText,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.todayWearHint(AppConfig.wearHoursGoal),
                                    style: KitType.label(color: p.secondary),
                                  ),
                                ),
                              ],
                            ),
                            if (therapy.checkIn.canCheckIn) ...[
                              const SizedBox(height: 18),
                              CheckInCard(
                                key: _checkInKey,
                                api: widget.me.api,
                                checkIn: therapy.checkIn,
                                now: widget.now,
                                onSent: (checkIn) {
                                  widget.me.addCheckIn(checkIn);
                                  // The schedule follows the change.
                                  widget.me.refresh();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Series 1 · day 3 of 7", then "Aligner 04/22" large, then the two pills.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.therapy,
    required this.current,
    required this.onCheckIn,
    this.onSchedule,
  });

  final Therapy therapy;
  final CurrentAligner current;

  /// Null when the doctor doesn't use check-in: only the schedule shows.
  final VoidCallback? onCheckIn;
  final VoidCallback? onSchedule;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    final digits = therapy.total >= 100 ? 3 : 2;
    String pad(int value) => value.toString().padLeft(digits, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          therapy.series == null
              ? l10n.todayDay(current.day, current.days)
              : l10n.todaySeriesDay(therapy.series!, current.day, current.days),
          style: KitType.eyebrow(color: p.accentText),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: l10n.todayAlignerOf(current.aligner, therapy.total),
          excludeSemantics: true,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.commonAlignerNumber(pad(current.aligner)),
                  ),
                  TextSpan(
                    text: '/${pad(therapy.total)}',
                    style: TextStyle(color: p.hairline),
                  ),
                ],
              ),
              style: KitType.display(60, color: p.ink),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            if (onSchedule != null)
              Expanded(
                child: KitButton.secondary(
                  label: l10n.tabSchedule,
                  icon: Icons.calendar_month_outlined,
                  height: 48,
                  onPressed: onSchedule,
                ),
              ),
            if (onSchedule != null && onCheckIn != null)
              const SizedBox(width: 8),
            if (onCheckIn != null)
              Expanded(
                child: KitButton(
                  key: const Key('hero-check-in'),
                  label: l10n.todayCheckIn,
                  icon: Icons.check_rounded,
                  height: 48,
                  onPressed: onCheckIn,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Four number tiles: next aligner, days left, how far, the last aligner.
class _Facts extends StatelessWidget {
  const _Facts({
    required this.therapy,
    required this.current,
    required this.now,
  });

  final Therapy therapy;
  final CurrentAligner current;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final next = therapy.nextChange;
    final isLast = current.aligner >= therapy.total;
    final daysLeft = (current.days - current.day).clamp(0, 999);
    // Finished aligners, the same count as Schedule's "Done".
    final finished = therapy.rows.isEmpty
        ? current.aligner - 1
        : therapy.rows.where((row) => row.state == AlignerState.done).length;
    final done = therapy.total == 0
        ? 0
        : (finished / therapy.total * 100).round();
    final late = therapy.checkIn.canCheckIn ? therapy.checkIn.lateDays : 0;
    final nextValue = late > 0
        ? l10n.commonDaysLate(late)
        : isLast || next == null
        ? l10n.todayLastOne
        : _capitalise(dayName(l10n, next, now: now));
    final tiles = [
      KitStat(
        inset: true,
        icon: Icons.event_outlined,
        label: l10n.todayNextAligner,
        value: nextValue,
      ),
      KitStat(
        inset: true,
        icon: Icons.hourglass_bottom_rounded,
        label: l10n.todayThisAligner,
        value: '$daysLeft',
        unit: l10n.todayDaysLeft(daysLeft),
      ),
      KitStat(
        inset: true,
        icon: Icons.trending_up_rounded,
        label: l10n.todayTreatment,
        value: '$done',
        unit: '%',
      ),
      KitStat(
        inset: true,
        icon: Icons.flag_outlined,
        label: l10n.commonLastAligner,
        value: therapy.endsOn == null
            ? '—'
            : shortDate(l10n, therapy.endsOn!, now: now),
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - KitSize.gap) / 2;
        return Wrap(
          spacing: KitSize.gap,
          runSpacing: KitSize.gap,
          children: [
            for (final tile in tiles) SizedBox(width: width, child: tile),
          ],
        );
      },
    );
  }

  static String _capitalise(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

/// Before treatment starts, or after it ends: the arch and a calm word.
class _Waiting extends StatelessWidget {
  const _Waiting({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KitArchHero(height: 200, semanticLabel: context.l10n.archHeroLabel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KitSize.gutter),
          child: CalmMessage(icon: icon, title: title, body: body),
        ),
      ],
    );
  }
}
