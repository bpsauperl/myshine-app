import 'package:flutter/material.dart';

import '../api/models.dart';
import '../l10n/l10n.dart';
import 'browser.dart';
import 'common.dart';

/// The clinic as a group of rows: its name (and city), the doctor when given,
/// the phone to call and the email to write to.
class ClinicContact extends StatelessWidget {
  const ClinicContact({super.key, required this.clinic, this.doctorName});

  final Clinic clinic;
  final String? doctorName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phone = clinic.phone;
    final email = clinic.email;
    return ShineGroup(
      children: [
        ShineRow(
          title: clinic.name.isEmpty ? l10n.profileYourClinic : clinic.name,
          trailingText: clinic.city,
          bold: true,
        ),
        if (doctorName != null)
          ShineRow(title: doctorName!, trailingText: l10n.profileYourDentist),
        if (phone != null && phone.isNotEmpty)
          ShineRow(
            key: const Key('clinic-phone'),
            title: phone,
            trailingText: l10n.profileCall,
            onTap: () => openContact(
              context,
              Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^0-9+]'), '')),
            ),
          ),
        if (email != null && email.isNotEmpty)
          ShineRow(
            key: const Key('clinic-email'),
            title: email,
            trailingText: l10n.profileEmail,
            onTap: () => openContact(context, Uri(scheme: 'mailto', path: email)),
          ),
      ],
    );
  }
}
