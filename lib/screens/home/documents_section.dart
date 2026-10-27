import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';

/// Consents to sign, shown on Profile.
class DocumentsSection extends StatelessWidget {
  const DocumentsSection({super.key, required this.me});

  final MeController me;

  Future<void> _sign(BuildContext context, Consent consent) async {
    await openInBrowserView(context, consent.signUrl!);
    // The link is short-lived and signing happens in the browser: reload after.
    await me.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final consents = me.data!.consents;
    final palette = context.shine;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.documentsTitle),
        if (consents.isEmpty)
          CalmMessage(
            icon: Icons.description_outlined,
            title: l10n.documentsEmptyTitle,
            body: l10n.documentsEmptyBody,
          )
        else
          ShineCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < consents.length; i++) ...[
                  if (i > 0) const Divider(indent: 64),
                  _ConsentRow(
                    consent: consents[i],
                    onSign: consents[i].signUrl == null
                        ? null
                        : () => _sign(context, consents[i]),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            l10n.documentsFootnote,
            style: TextStyle(color: palette.muted, height: 1.4, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({required this.consent, this.onSign});

  final Consent consent;
  final VoidCallback? onSign;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    final signed = consent.isSigned;
    final title = consent.devices == null || consent.devices!.isEmpty
        ? l10n.documentsConsent
        : l10n.documentsConsentFor(consent.devices!);
    final subtitle = signed
        ? (consent.signedAt == null
              ? l10n.documentsSigned
              : l10n.documentsSignedOn(longDate(l10n, consent.signedAt!)))
        : onSign == null
        ? l10n.documentsSignThere
        : l10n.documentsWaiting;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            signed ? Icons.verified_rounded : Icons.edit_document,
            color: signed ? palette.accentText : palette.muted,
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: palette.muted)),
              ],
            ),
          ),
          if (!signed && onSign != null)
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(72, 40)),
              onPressed: onSign,
              child: Text(l10n.documentsSign),
            ),
        ],
      ),
    );
  }
}
