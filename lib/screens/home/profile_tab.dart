import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import 'documents_section.dart';
import 'home_shell.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.me});

  final MeController me;

  Future<void> _disconnect(BuildContext context) async {
    final session = SessionScope.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect myShine?'),
        content: const Text(
          'Your plan, schedule and messages will no longer show on this phone. '
          'To connect again, ask your clinic for a new code.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disconnect'),
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
    final phone = clinic.phone;
    final email = clinic.email;
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(
          patient.firstName.isEmpty ? 'Profile' : patient.firstName,
          subtitle: patient.statusLabel,
        ),
        KitListGroup(
          title: 'Your clinic',
          children: [
            KitListRow(
              icon: Icons.local_hospital_outlined,
              title: clinic.name,
              detail: clinic.city,
              highlight: true,
            ),
            if (patient.doctorName != null)
              KitListRow(
                icon: Icons.person_outline_rounded,
                title: patient.doctorName!,
                detail: 'Your dentist',
              ),
            if (phone != null && phone.isNotEmpty)
              KitListRow(
                icon: Icons.call_outlined,
                title: phone,
                detail: 'Call',
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
                detail: 'Email',
                onTap: () =>
                    openContact(context, Uri(scheme: 'mailto', path: email)),
              ),
          ],
        ),
        const SizedBox(height: 14),
        DocumentsSection(me: me),
        const SizedBox(height: 24),
        KitTile(
          key: const Key('disconnect'),
          onTap: () => _disconnect(context),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: p.danger),
              const SizedBox(width: 14),
              Text(
                'Disconnect',
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
            'Shine clear aligners by SmileLabs',
            style: TextStyle(color: palette.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
