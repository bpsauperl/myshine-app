import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../reminders/reminders.dart';
import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../theme.dart';
import '../../widgets/clinic_contact.dart';
import '../../widgets/common.dart';
import '../about_sheet.dart';
import 'documents_section.dart';
import 'home_shell.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.me,
    this.reminders = const NoReminders(),
  });

  final MeController me;
  final Reminders reminders;

  Future<void> _disconnect(BuildContext context) async {
    final session = SessionScope.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileDisconnectTitle),
        content: Text(l10n.profileDisconnectBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.profileDisconnect),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await session.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = me.data!.patient;
    final palette = context.shine;
    final l10n = context.l10n;
    final initial = patient.firstName.isEmpty ? '·' : patient.firstName.characters.first.toUpperCase();
    return TabPage(
      onRefresh: me.refresh,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 22),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: palette.card, shape: BoxShape.circle),
                child: Text(initial, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: palette.ink)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        patient.firstName.isEmpty ? l10n.profileTitle : patient.firstName,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.9, color: palette.ink),
                      ),
                    ),
                    if (patientStatusText(l10n, patient) case final status? when status.isNotEmpty)
                      Text(status, style: TextStyle(fontSize: 14, color: palette.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionLabel(l10n.profileYourClinic),
        ClinicContact(clinic: patient.clinic, doctorName: patient.doctorName),
        // Reminders are the phone app's own notifications: not on the web.
        if (!kIsWeb) ...[
          const SizedBox(height: 8),
          SectionLabel(l10n.profileThisPhone),
          ShineGroup(
            children: [_RemindersRow(reminders: reminders, onEnabled: me.refresh)],
          ),
        ],
        const SizedBox(height: 8),
        DocumentsSection(me: me),
        const SizedBox(height: 22),
        ShineGroup(
          children: [
            ShineRow(
              key: const Key('profile-about'),
              title: l10n.profileAbout,
              onTap: () => showAboutMyShine(context),
            ),
            ShineRow(
              key: const Key('disconnect'),
              title: l10n.profileDisconnect,
              danger: true,
              onTap: () => _disconnect(context),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Center(child: Wordmark(size: 17)),
        const SizedBox(height: 4),
        Center(
          child: Text(l10n.profileFooter, style: TextStyle(color: palette.muted, fontSize: 12)),
        ),
      ],
    );
  }
}

/// Aligner reminders on or off, for this phone.
class _RemindersRow extends StatefulWidget {
  const _RemindersRow({required this.reminders, required this.onEnabled});

  final Reminders reminders;

  /// Reloads the schedule, which sets the reminders again.
  final Future<void> Function() onEnabled;

  @override
  State<_RemindersRow> createState() => _RemindersRowState();
}

class _RemindersRowState extends State<_RemindersRow> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    widget.reminders.isEnabled().then((value) {
      if (mounted) {
        setState(() => _enabled = value);
      }
    });
  }

  Future<void> _toggle() async {
    final next = !(_enabled ?? true);
    setState(() => _enabled = next);
    await widget.reminders.setEnabled(next);
    if (next) {
      await widget.onEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _enabled;
    final l10n = context.l10n;
    return ShineRow(
      key: const Key('reminders'),
      title: l10n.profileReminders,
      subtitle: l10n.profileRemindersDetail,
      onTap: enabled == null ? null : _toggle,
      trailing: enabled == null
          ? null
          : Semantics(
              label: enabled ? l10n.profileOn : l10n.profileOff,
              child: Switch.adaptive(value: enabled, onChanged: (_) => _toggle()),
            ),
    );
  }
}

/// The patient's status in the app's language (the server's label is English).
/// "Base" is drShine's own word for a patient without an order: it is not shown.
String? patientStatusText(AppLocalizations l10n, Patient patient) =>
    switch (patient.status) {
      'base' => null,
      'planning' => l10n.statusPlanning,
      'confirmed' => l10n.statusConfirmed,
      'production' => l10n.statusProduction,
      'shipped' => l10n.statusShipped,
      'therapy' => l10n.statusTherapy,
      'completed' => l10n.statusCompleted,
      'cancelled' => l10n.statusCancelled,
      _ => patient.statusLabel,
    };
