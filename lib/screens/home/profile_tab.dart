import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../l10n/l10n.dart';
import '../../reminders/reminders.dart';
import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
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
    final clinic = patient.clinic;
    final palette = context.shine;
    final p = context.kit;
    final l10n = context.l10n;
    final phone = clinic.phone;
    final email = clinic.email;
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(
          patient.firstName.isEmpty ? l10n.profileTitle : patient.firstName,
          subtitle: patient.statusLabel,
        ),
        KitListGroup(
          title: l10n.profileYourClinic,
          children: [
            KitListRow(
              icon: Icons.local_hospital_outlined,
              title: clinic.name.isEmpty ? l10n.profileYourClinic : clinic.name,
              detail: clinic.city,
              highlight: true,
            ),
            if (patient.doctorName != null)
              KitListRow(
                icon: Icons.person_outline_rounded,
                title: patient.doctorName!,
                detail: l10n.profileYourDentist,
              ),
            if (phone != null && phone.isNotEmpty)
              KitListRow(
                icon: Icons.call_outlined,
                title: phone,
                detail: l10n.profileCall,
                onTap: () => openContact(
                  context,
                  Uri(
                    scheme: 'tel',
                    path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
                  ),
                ),
              ),
            if (email != null && email.isNotEmpty)
              KitListRow(
                icon: Icons.mail_outline_rounded,
                title: email,
                detail: l10n.profileEmail,
                onTap: () =>
                    openContact(context, Uri(scheme: 'mailto', path: email)),
              ),
          ],
        ),
        const SizedBox(height: 14),
        KitListGroup(
          title: l10n.profileThisPhone,
          children: [
            _RemindersRow(reminders: reminders, onEnabled: me.refresh),
          ],
        ),
        const SizedBox(height: 14),
        DocumentsSection(me: me),
        const SizedBox(height: 14),
        KitListGroup(
          children: [
            KitListRow(
              key: const Key('profile-about'),
              icon: Icons.info_outline_rounded,
              title: l10n.profileAbout,
              detail: l10n.profileAboutDetail,
              onTap: () => showAboutMyShine(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        KitTile(
          key: const Key('disconnect'),
          onTap: () => _disconnect(context),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: p.danger),
              const SizedBox(width: 14),
              Text(
                l10n.profileDisconnect,
                style: TextStyle(
                  color: p.danger,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Center(child: Wordmark(size: 18)),
        const SizedBox(height: 4),
        Center(
          child: Text(
            l10n.profileFooter,
            style: TextStyle(color: palette.muted, fontSize: 12),
          ),
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
    return KitListRow(
      key: const Key('reminders'),
      icon: Icons.notifications_none_rounded,
      title: l10n.profileReminders,
      detail: l10n.profileRemindersDetail,
      state: enabled == null
          ? null
          : (enabled ? l10n.profileOn : l10n.profileOff),
      onTap: enabled == null ? null : _toggle,
    );
  }
}
