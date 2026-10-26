import 'package:flutter/material.dart';

import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
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
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(
          patient.firstName.isEmpty ? 'Profile' : patient.firstName,
          subtitle: patient.statusLabel,
        ),
        const SectionLabel('Your clinic'),
        ShineCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.local_hospital_outlined,
                  color: palette.accentText,
                ),
                title: Text(
                  clinic.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: clinic.city == null ? null : Text(clinic.city!),
              ),
              if (patient.doctorName != null) ...[
                const Divider(indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.person_outline_rounded,
                    color: palette.accentText,
                  ),
                  title: Text(patient.doctorName!),
                  subtitle: const Text('Your dentist'),
                ),
              ],
              if (clinic.phone != null && clinic.phone!.isNotEmpty) ...[
                const Divider(indent: 56),
                ListTile(
                  leading: Icon(Icons.call_outlined, color: palette.accentText),
                  title: Text(clinic.phone!),
                  subtitle: const Text('Call'),
                  onTap: () => openContact(
                    context,
                    Uri(
                      scheme: 'tel',
                      path: clinic.phone!.replaceAll(RegExp(r'[^0-9+]'), ''),
                    ),
                  ),
                ),
              ],
              if (clinic.email != null && clinic.email!.isNotEmpty) ...[
                const Divider(indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.mail_outline_rounded,
                    color: palette.accentText,
                  ),
                  title: Text(clinic.email!),
                  subtitle: const Text('Email'),
                  onTap: () => openContact(
                    context,
                    Uri(scheme: 'mailto', path: clinic.email!),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        ShineCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            key: const Key('disconnect'),
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Disconnect',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () => _disconnect(context),
          ),
        ),
        const SizedBox(height: 24),
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
