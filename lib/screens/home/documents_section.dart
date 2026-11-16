import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../util/dates.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';

/// The patient's documents on Profile: everything they signed and the
/// statement for each device, one tap to open, and consents still to sign.
class DocumentsSection extends StatelessWidget {
  const DocumentsSection({super.key, required this.me});

  final MeController me;

  Future<void> _sign(BuildContext context, Consent consent) async {
    await openInBrowserView(context, consent.signUrl!);
    // The link is short-lived and signing happens in the browser: reload after.
    await me.refresh();
  }

  /// The link is short-lived: fetch a fresh one, then open it.
  Future<void> _open(BuildContext context, PatientDocument document) async {
    await me.refresh();
    if (!context.mounted) return;
    final fresh = me.data?.documents
        .where((d) => d.id == document.id && d.type == document.type)
        .firstOrNull;
    await openInBrowserView(context, (fresh ?? document).url);
  }

  @override
  Widget build(BuildContext context) {
    final documents = me.data!.documents;
    // A signed consent is among the documents (to open). An older drShine
    // sends no documents: then the signed consent still shows, as before.
    final consents = me.data!.consents
        .where((c) => !c.isSigned || documents.isEmpty)
        .toList();
    final palette = context.shine;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.documentsTitle),
        if (documents.isNotEmpty) ...[
          ShineCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < documents.length; i++) ...[
                  if (i > 0) const Divider(indent: 64),
                  _DocumentRow(
                    document: documents[i],
                    onOpen: () => _open(context, documents[i]),
                  ),
                ],
              ],
            ),
          ),
          if (consents.isNotEmpty) const SizedBox(height: 10),
        ],
        if (consents.isEmpty && documents.isEmpty)
          CalmMessage(
            icon: Icons.description_outlined,
            title: l10n.documentsEmptyTitle,
            body: l10n.documentsEmptyBody,
          )
        else if (consents.isNotEmpty)
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

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document, required this.onOpen});

  final PatientDocument document;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              document.isConsent
                  ? Icons.verified_rounded
                  : Icons.shield_outlined,
              color: palette.accentText,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (document.detail != null &&
                      document.detail!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      document.detail!,
                      style: TextStyle(color: palette.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.documentsOpen,
              style: TextStyle(
                color: palette.accentText,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: palette.accentText),
          ],
        ),
      ),
    );
  }
}
