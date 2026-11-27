import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shine_kit/shine_kit.dart';

import '../l10n/l10n.dart';
import '../widgets/common.dart';
import 'about_sheet.dart';

/// "Before you start": the clinic's short rules, read once before the tabs
/// open. The server remembers that they were read; this phone remembers it
/// too, so the patient is never asked twice when the server can't be told.
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key, required this.onAccept});

  /// The patient tapped "I understand".
  final VoidCallback onAccept;

  /// Where this phone keeps that [version] of the rules was read.
  static String seenKey(String? version) =>
      'myshine.rulesSeen.${version ?? ''}';

  /// Whether [version] of the rules was already read on this phone.
  static Future<bool> seenHere(String? version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(seenKey(version)) == true;
    } catch (_) {
      return false;
    }
  }

  /// Remembers on this phone that [version] of the rules was read.
  static Future<void> rememberSeen(String? version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(seenKey(version), true);
    } catch (_) {
      // The patient goes on either way.
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    final rows = [
      (l10n.rulesClinicTitle, l10n.rulesClinicBody),
      (l10n.rulesVoluntaryTitle, l10n.rulesVoluntaryBody),
      (l10n.rulesEmergencyTitle, l10n.rulesEmergencyBody),
      (l10n.rulesDiagnosisTitle, l10n.rulesDiagnosisBody),
      (l10n.rulesStopTitle, l10n.rulesStopBody),
    ];
    final small = KitType.label(color: p.secondary).copyWith(fontSize: 12);
    return Scaffold(
      key: const Key('rules-screen'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            KitSize.gutter + 4,
            24,
            KitSize.gutter + 4,
            20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Wordmark(size: 20),
                  ),
                  const SizedBox(height: 14),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.rulesTitle,
                      style: KitType.display(30, color: p.ink),
                    ),
                  ),
                  const SizedBox(height: 20),
                  KitTile(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (index, row) in rows.indexed) ...[
                          if (index > 0)
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: p.hairline,
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.$1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: p.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  row.$2,
                                  style: KitType.label(color: p.secondary)
                                      .copyWith(fontSize: 14, height: 1.35),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  KitButton(
                    key: const Key('rules-accept'),
                    label: l10n.rulesAccept,
                    onPressed: onAccept,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _SmallLink(
                        key: const Key('rules-privacy'),
                        label: l10n.commonPrivacy,
                        onTap: () => openMyShinePage(context, 'privacy'),
                      ),
                      Text('  ·  ', style: small),
                      _SmallLink(
                        key: const Key('rules-help'),
                        label: l10n.commonHelp,
                        onTap: () => openMyShinePage(context, 'help'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small link under the button, with a full-size touch area.
class _SmallLink extends StatelessWidget {
  const _SmallLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.kit.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
