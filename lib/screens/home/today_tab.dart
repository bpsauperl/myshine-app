import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../config.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../util/dates.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import '../../theme.dart';
import 'check_in_page.dart';

/// Today: the patient's own aligner as the hero tile (the number big, the next
/// change, a bar of every aligner, the black check-in button), two fact tiles,
/// the last check-in and the clinic.
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
  Future<void> _openCheckIn() async {
    final therapy = widget.me.data?.therapy;
    if (therapy == null) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => CheckInPage(
          api: widget.me.api,
          checkIn: therapy.checkIn,
          now: widget.now,
          onSent: (checkIn) {
            widget.me.addCheckIn(checkIn);
            // The schedule follows the change.
            widget.me.refresh();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.me.data!;
    final therapy = data.therapy;
    final current = therapy?.current;
    final palette = context.shine;
    final l10n = context.l10n;
    final today = widget.now ?? DateTime.now();
    final name = data.patient.firstName;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: widget.me.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 128),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  headerDate(l10n, today),
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: palette.muted),
                                ),
                                const SizedBox(height: 2),
                                Semantics(
                                  header: true,
                                  child: Text(
                                    name.isEmpty ? l10n.tabToday : l10n.todayHello(name),
                                    style: largeTitle(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Wordmark(size: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (therapy == null)
                      CalmMessage(
                        key: const Key('not-started'),
                        icon: Icons.hourglass_empty_rounded,
                        title: l10n.todayNotStartedTitle,
                        body: l10n.todayNotStartedBody,
                      )
                    else if (current == null)
                      CalmMessage(
                        icon: Icons.task_alt_rounded,
                        title: l10n.todayAllDoneTitle,
                        body: therapy.endsOn == null
                            ? l10n.todayAllDoneBody
                            : l10n.todayAllDoneBodyWithDate(longDate(l10n, therapy.endsOn!)),
                      )
                    else ...[
                      _Hero(
                        therapy: therapy,
                        current: current,
                        now: today,
                        onCheckIn: therapy.checkIn.canCheckIn ? _openCheckIn : null,
                        onSchedule: widget.onOpenTab == null ? null : () => widget.onOpenTab!(2),
                      ),
                      const SizedBox(height: 10),
                      _Facts(current: current),
                      if (_lastCheckIn(data.checkIns) case final last?) ...[
                        const SizedBox(height: 10),
                        _LastCheckIn(checkIn: last, now: today),
                      ],
                      const SizedBox(height: 10),
                      _ClinicRow(patient: data.patient),
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

/// The aligner tile: "Series 1 · day 3 of 7", the aligner number big, the next
/// change, a bar of every aligner, and the one black button.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.therapy,
    required this.current,
    required this.now,
    required this.onCheckIn,
    this.onSchedule,
  });

  final Therapy therapy;
  final CurrentAligner current;
  final DateTime now;

  /// Null when the doctor doesn't use check-in: the schedule button shows instead.
  final VoidCallback? onCheckIn;
  final VoidCallback? onSchedule;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final finished = _finished(therapy, current);
    final late = therapy.checkIn.canCheckIn ? therapy.checkIn.lateDays : 0;
    final next = therapy.nextChange;
    final isLast = current.aligner >= therapy.total;
    final nextLine = late > 0
        ? l10n.todayChangeLate(current.aligner + 1, l10n.commonDaysLate(late))
        : isLast || next == null
        ? l10n.todayLastAlignerNow
        : l10n.todayChangeTo(current.aligner + 1, relativeDay(l10n, next, now: now));
    final checkInAligner = therapy.checkIn.nextAligner ?? current.aligner + 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(kHeroRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            therapy.series == null
                ? l10n.todayDay(current.day, current.days)
                : l10n.todaySeriesDay(therapy.series!, current.day, current.days),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.muted),
          ),
          const SizedBox(height: 6),
          Semantics(
            label: l10n.todayAlignerOf(current.aligner, therapy.total),
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${current.aligner}',
                    key: const Key('today-aligner'),
                    style: TextStyle(
                      fontSize: 96,
                      height: 0.95,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -5.5,
                      color: palette.ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    l10n.todayOfAligners(therapy.total),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: -0.4, color: ShineColors.tertiary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            nextLine,
            key: const Key('today-next-change'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
              color: late > 0 ? Theme.of(context).colorScheme.error : palette.ink,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: l10n.todayProgress(finished, therapy.total),
            excludeSemantics: true,
            child: _AlignerBar(
              key: const Key('today-progress'),
              total: therapy.total,
              done: finished,
              current: current.aligner,
              dark: dark,
            ),
          ),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: TextStyle(fontSize: 12, color: palette.muted, fontFeatures: const [FontFeature.tabularFigures()]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.todayDoneCount(finished)),
                if (therapy.endsOn != null) Text(l10n.todayLastOne(shortDate(l10n, therapy.endsOn!, now: now))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (onCheckIn != null)
            FilledButton(
              key: const Key('hero-check-in'),
              onPressed: onCheckIn,
              child: Text(l10n.todayCheckInAligner(checkInAligner)),
            )
          else if (onSchedule != null)
            FilledButton(
              key: const Key('hero-schedule'),
              style: FilledButton.styleFrom(
                backgroundColor: dark ? ShineColors.darkInset : Colors.white,
                foregroundColor: palette.ink,
              ),
              onPressed: onSchedule,
              child: Text(l10n.todayOpenSchedule),
            ),
        ],
      ),
    );
  }
}

/// One short bar per aligner: done in ink, the one in the mouth grey, the rest light.
class _AlignerBar extends StatelessWidget {
  const _AlignerBar({super.key, required this.total, required this.done, required this.current, required this.dark});

  final int total;
  final int done;
  final int current;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = context.shine.ink;
    final rest = dark ? const Color(0xFF3A3A3C) : const Color(0xFFDCDCE0);
    if (total <= 0) {
      return const SizedBox(height: 6);
    }
    if (total > 60) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(value: done / total, minHeight: 6, color: ink, backgroundColor: rest),
      );
    }
    return Row(
      children: [
        for (var i = 1; i <= total; i++) ...[
          if (i > 1) const SizedBox(width: 3),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: i <= done ? ink : i == current ? ShineColors.tertiary : rest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Finished aligners, the same count as Schedule's "Done".
int _finished(Therapy therapy, CurrentAligner current) => therapy.rows.isEmpty
    ? current.aligner - 1
    : therapy.rows.where((row) => row.state == AlignerState.done).length;

/// The newest aligner change the patient checked in.
CheckIn? _lastCheckIn(List<CheckIn> checkIns) {
  CheckIn? last;
  for (final checkIn in checkIns.where((c) => c.alignerChange)) {
    if (last == null ||
        (checkIn.at != null &&
            (last.at == null || checkIn.at!.isAfter(last.at!)))) {
      last = checkIn;
    }
  }
  return last;
}

/// Two tiles: days left on this aligner, and the hours to wear it.
class _Facts extends StatelessWidget {
  const _Facts({required this.current});

  final CurrentAligner current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final daysLeft = (current.days - current.day).clamp(0, 999);
    return Row(
      children: [
        Expanded(
          child: _Fact(
            key: const Key('today-days-left'),
            label: l10n.todayThisAligner,
            value: '$daysLeft',
            unit: l10n.todayDaysLeftUnit,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Fact(
            label: l10n.todayWear,
            value: '${AppConfig.wearHoursGoal}',
            unit: l10n.todayHoursUnit,
          ),
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({super.key, required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    return Semantics(
      label: '$label: $value $unit',
      excludeSemantics: true,
      child: ShineCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 13, color: palette.muted)),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: value),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: -0.2, color: palette.muted),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.9,
                color: palette.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The newest check-in: when, which aligner, on time or late, the fit and the photos.
class _LastCheckIn extends StatelessWidget {
  const _LastCheckIn({required this.checkIn, required this.now});

  final CheckIn checkIn;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.shine;
    final title = [
      if (checkIn.aligner != null) l10n.commonAlignerNumber('${checkIn.aligner}'),
      checkIn.lateDays > 0 ? l10n.commonDaysLate(checkIn.lateDays) : l10n.todayCheckInOnTime,
    ].join(' · ');
    final detail = [
      if (checkIn.fitLabel != null && checkIn.fitLabel!.isNotEmpty) checkIn.fitLabel!,
      if (checkIn.photos > 0) l10n.todayCheckInPhotos(checkIn.photos),
    ].join(' · ');
    return ShineCard(
      key: const Key('today-last-check-in'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            checkIn.at == null ? l10n.todayLastCheckIn : l10n.todayLastCheckInOn(shortDate(l10n, checkIn.at!, now: now)),
            style: TextStyle(fontSize: 13, color: palette.muted),
          ),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: palette.ink)),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(detail, style: TextStyle(fontSize: 13, color: palette.muted)),
          ],
        ],
      ),
    );
  }
}

/// The clinic, with a round call button when there is a phone number.
class _ClinicRow extends StatelessWidget {
  const _ClinicRow({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.shine;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final clinic = patient.clinic;
    final phone = clinic.phone;
    final hasPhone = phone != null && phone.isNotEmpty;
    final detail = patient.doctorName ?? clinic.city;
    return ShineCard(
      key: const Key('today-clinic'),
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinic.name.isEmpty ? l10n.profileYourClinic : clinic.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: palette.ink),
                ),
                if (detail != null && detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(detail, style: TextStyle(fontSize: 13, color: palette.muted)),
                ],
              ],
            ),
          ),
          if (hasPhone)
            Semantics(
              button: true,
              label: l10n.profileCall,
              excludeSemantics: true,
              child: Material(
                color: dark ? ShineColors.darkInset : Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => openContact(
                    context,
                    Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^0-9+]'), '')),
                  ),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(Icons.call_outlined, size: 19, color: palette.ink),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
