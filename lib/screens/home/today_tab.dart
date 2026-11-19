import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../api/models.dart';
import '../../config.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../util/dates.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import 'check_in_card.dart';

/// Today: the patient's own aligner as the hero (the number big, the next
/// change, how far), the facts in plain rows, the check-in, the last check-in
/// and the clinic.
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
                        icon: Icons.task_alt_rounded,
                        title: l10n.todayAllDoneTitle,
                        body: therapy.endsOn == null
                            ? l10n.todayAllDoneBody
                            : l10n.todayAllDoneBodyWithDate(
                                longDate(l10n, therapy.endsOn!),
                              ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          KitSize.gutter,
                          30,
                          KitSize.gutter,
                          0,
                        ),
                        child: _Hero(
                          therapy: therapy,
                          current: current,
                          now: today,
                          onCheckIn: therapy.checkIn.canCheckIn
                              ? _goToCheckIn
                              : null,
                          onSchedule: widget.onOpenTab == null
                              ? null
                              : () => widget.onOpenTab!(2),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: KitSize.gutter,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Facts(
                              therapy: therapy,
                              current: current,
                              now: today,
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                l10n.todayWearHint(AppConfig.wearHoursGoal),
                                style: KitType.label(color: p.secondary),
                              ),
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
                            if (_lastCheckIn(data.checkIns)
                                case final last?) ...[
                              const SizedBox(height: 18),
                              _LastCheckIn(checkIn: last, now: today),
                            ],
                            const SizedBox(height: 18),
                            _ClinicRow(patient: data.patient),
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

/// "Series 1 · day 3 of 7", "Aligner 04/22" large, the next change, how far
/// the series is, then the two pills.
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

  /// Null when the doctor doesn't use check-in: only the schedule shows.
  final VoidCallback? onCheckIn;
  final VoidCallback? onSchedule;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    final digits = therapy.total >= 100 ? 3 : 2;
    String pad(int value) => value.toString().padLeft(digits, '0');
    final finished = _finished(therapy, current);
    final late = therapy.checkIn.canCheckIn ? therapy.checkIn.lateDays : 0;
    final next = therapy.nextChange;
    final isLast = current.aligner >= therapy.total;
    final nextLine = late > 0
        ? l10n.todayChangeLate(current.aligner + 1, l10n.commonDaysLate(late))
        : isLast || next == null
        ? l10n.todayLastAlignerNow
        : l10n.todayChangeTo(
            current.aligner + 1,
            relativeDay(l10n, next, now: now),
          );
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
              style: KitType.display(64, color: p.ink),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          nextLine,
          key: const Key('today-next-change'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: late > 0 ? p.danger : p.ink,
          ),
        ),
        const SizedBox(height: 18),
        Semantics(
          label: l10n.todayProgress(finished, therapy.total),
          excludeSemantics: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              key: const Key('today-progress'),
              value: therapy.total == 0 ? 0 : finished / therapy.total,
              minHeight: 4,
              color: p.ink,
              backgroundColor: p.hairline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.todayProgress(finished, therapy.total),
          style: KitType.label(color: p.secondary),
        ),
        const SizedBox(height: 22),
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

/// The facts as plain rows: days left on this aligner, the last aligner, the
/// day treatment started.
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
    final daysLeft = (current.days - current.day).clamp(0, 999);
    return KitListGroup(
      children: [
        KitListRow(
          key: const Key('today-days-left'),
          icon: Icons.hourglass_bottom_rounded,
          title: l10n.todayDaysLeftLabel,
          state: '$daysLeft',
        ),
        KitListRow(
          icon: Icons.flag_outlined,
          title: l10n.commonLastAligner,
          state: therapy.endsOn == null
              ? '—'
              : shortDate(l10n, therapy.endsOn!, now: now),
        ),
        if (therapy.started != null)
          KitListRow(
            icon: Icons.play_circle_outline_rounded,
            title: l10n.todayStarted,
            state: shortDate(l10n, therapy.started!, now: now),
          ),
      ],
    );
  }
}

/// The newest check-in: which aligner, when, on time or late, the fit and how
/// many photos went with it.
class _LastCheckIn extends StatelessWidget {
  const _LastCheckIn({required this.checkIn, required this.now});

  final CheckIn checkIn;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = [
      if (checkIn.aligner != null)
        l10n.commonAlignerNumber('${checkIn.aligner}'),
      checkIn.lateDays > 0
          ? l10n.commonDaysLate(checkIn.lateDays)
          : l10n.todayCheckInOnTime,
    ].join(' · ');
    final detail = [
      if (checkIn.at != null) shortDate(l10n, checkIn.at!, now: now),
      if (checkIn.fitLabel != null && checkIn.fitLabel!.isNotEmpty)
        checkIn.fitLabel!,
      if (checkIn.photos > 0) l10n.todayCheckInPhotos(checkIn.photos),
    ].join(' · ');
    return KitListGroup(
      key: const Key('today-last-check-in'),
      title: l10n.todayLastCheckIn,
      children: [
        KitListRow(
          icon: Icons.check_circle_outline_rounded,
          title: title,
          detail: detail.isEmpty ? null : detail,
        ),
      ],
    );
  }
}

/// The clinic in one row: tap to call when there is a phone number.
class _ClinicRow extends StatelessWidget {
  const _ClinicRow({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clinic = patient.clinic;
    final phone = clinic.phone;
    final hasPhone = phone != null && phone.isNotEmpty;
    return KitListGroup(
      key: const Key('today-clinic'),
      title: l10n.profileYourClinic,
      children: [
        KitListRow(
          icon: hasPhone ? Icons.call_outlined : Icons.local_hospital_outlined,
          title: clinic.name.isEmpty ? l10n.profileYourClinic : clinic.name,
          detail: patient.doctorName ?? clinic.city,
          state: hasPhone ? l10n.profileCall : null,
          onTap: hasPhone
              ? () => openContact(
                  context,
                  Uri(
                    scheme: 'tel',
                    path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

/// Before treatment starts, or after it ends: a calm word, nothing else.
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(KitSize.gutter, 28, KitSize.gutter, 0),
      child: CalmMessage(icon: icon, title: title, body: body),
    );
  }
}
