import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../config.dart';
import '../l10n/l10n.dart';
import '../widgets/browser.dart';
import '../widgets/common.dart';

/// The language for drShine's Help and Privacy pages (Serbian has one page for
/// both scripts).
String pageLanguage(AppLocalizations l10n) =>
    l10n.localeName.startsWith('sr') ? 'sr' : l10n.localeName.split('_').first;

/// Opens drShine's Help or Privacy page ('help', 'privacy') in the patient's
/// language.
Future<void> openMyShinePage(BuildContext context, String page) =>
    openInBrowserView(
      context,
      AppConfig.pageUrl(page, pageLanguage(context.l10n)).toString(),
    );

/// What myShine is for, as a sheet: from the welcome screen and from Profile.
Future<void> showAboutMyShine(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.kit.ground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(KitSize.panelRadius),
      ),
    ),
    builder: (_) => const AboutMyShine(),
  );
}

/// The purpose map: what each part of myShine is for, what it is not, and the
/// links to Help and Privacy.
class AboutMyShine extends StatelessWidget {
  const AboutMyShine({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    final rows = [
      (Icons.today_outlined, l10n.tabToday, l10n.aboutToday),
      (
        Icons.check_circle_outline_rounded,
        l10n.aboutCheckInTitle,
        l10n.aboutCheckIn,
      ),
      (Icons.view_in_ar_outlined, l10n.tabPlan, l10n.aboutPlan),
      (Icons.calendar_month_outlined, l10n.tabSchedule, l10n.aboutSchedule),
      (Icons.chat_bubble_outline_rounded, l10n.tabMessages, l10n.aboutMessages),
      (
        Icons.description_outlined,
        l10n.aboutDocumentsTitle,
        l10n.aboutDocuments,
      ),
      (Icons.local_hospital_outlined, l10n.profileYourClinic, l10n.aboutClinic),
    ];
    return SingleChildScrollView(
      key: const Key('about-myshine'),
      padding: const EdgeInsets.fromLTRB(
        KitSize.gutter + 4,
        12,
        KitSize.gutter + 4,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          const Wordmark(size: 20),
          const SizedBox(height: 14),
          Semantics(
            header: true,
            child: Text(
              l10n.aboutTitle,
              style: KitType.display(30, color: p.ink),
            ),
          ),
          const SizedBox(height: 10),
          Text(l10n.aboutIntro, style: KitType.body(color: p.secondary)),
          const SizedBox(height: 20),
          KitTile(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                for (final (index, row) in rows.indexed) ...[
                  if (index > 0)
                    Divider(height: 1, thickness: 0.5, color: p.hairline),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(row.$1, size: 22, color: p.accentText),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row.$2,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: p.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                row.$3,
                                style: KitType.label(color: p.secondary)
                                    .copyWith(fontSize: 14, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l10n.aboutNot,
              style: KitType.label(color: p.secondary).copyWith(height: 1.4),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: KitButton.secondary(
                  key: const Key('about-help'),
                  label: l10n.commonHelp,
                  height: 48,
                  onPressed: () => openMyShinePage(context, 'help'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KitButton.secondary(
                  key: const Key('about-privacy'),
                  label: l10n.commonPrivacy,
                  height: 48,
                  onPressed: () => openMyShinePage(context, 'privacy'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.aboutVersion(AppConfig.version),
              style: KitType.label(color: p.tertiary).copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
