import 'package:flutter/foundation.dart';
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

  /// The link is short-lived: fetch a fresh one, then open it. On the web
  /// the browser only lets a new tab open straight from the tap, so there
  /// the link at hand is used (the home screen keeps it fresh).
  Future<void> _open(BuildContext context, PatientDocument document) async {
    if (kIsWeb) {
      await openInBrowserView(context, document.url);
      return;
    }
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
          ShineGroup(
            children: [
              for (final document in documents)
                ShineRow(
                  title: document.title,
                  subtitle: document.detail == null || document.detail!.isEmpty ? null : document.detail,
                  trailingText: l10n.documentsOpen,
                  onTap: () => _open(context, document),
                ),
            ],
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
          ShineGroup(
            children: [
              for (final consent in consents)
                _ConsentRow(
                  consent: consent,
                  onSign: consent.signUrl == null ? null : () => _sign(context, consent),
                ),
            ],
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

/// A consent: signed (with the date), or waiting, with Sign when it can be signed here.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({required this.consent, this.onSign});

  final Consent consent;
  final VoidCallback? onSign;

  @override
  Widget build(BuildContext context) {
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
    return ShineRow(
      title: title,
      subtitle: subtitle,
      trailing: !signed && onSign != null
          ? FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(72, 38), padding: const EdgeInsets.symmetric(horizontal: 16)),
              onPressed: onSign,
              child: Text(l10n.documentsSign),
            )
          : null,
    );
  }
}
