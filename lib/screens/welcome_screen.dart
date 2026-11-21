import 'package:flutter/material.dart';

import '../config.dart';
import '../l10n/l10n.dart';
import '../theme.dart';
import '../state/session.dart';
import '../widgets/common.dart';
import 'about_sheet.dart';
import 'connect_screen.dart';
import 'server_settings_sheet.dart';

/// The start, before the patient connects with their clinic: a real Shine
/// photo, what myShine is, and the way in with the clinic's code.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    final small = TextStyle(fontSize: 12, color: palette.muted);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final photoHeight = (constraints.maxHeight * 0.5).clamp(240.0, 500.0);
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        image: true,
                        label: l10n.welcomePhotoLabel,
                        child: Image.asset(
                          'assets/images/welcome.webp',
                          key: const Key('welcome-photo'),
                          height: photoHeight,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.6),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  key: const Key('welcome-logo'),
                                  onLongPress: AppConfig.serverSettingEnabled
                                      ? () => showServerSettings(context, SessionScope.of(context))
                                      : null,
                                  child: const Wordmark(size: 17),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Semantics(
                                header: true,
                                child: Text(
                                  '${l10n.welcomeTitle}\n${l10n.welcomeTitleMuted}',
                                  style: TextStyle(fontSize: 34, height: 1.08, fontWeight: FontWeight.w700, letterSpacing: -1.2, color: palette.ink),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.welcomeBody,
                                style: TextStyle(fontSize: 16, height: 1.45, color: palette.muted),
                              ),
                              const SizedBox(height: 26),
                              FilledButton(
                                key: const Key('welcome-code'),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (_) => const ConnectScreen()),
                                ),
                                child: Text(l10n.welcomeHaveCode),
                              ),
                              const SizedBox(height: 6),
                              TextButton(
                                key: const Key('welcome-about'),
                                style: TextButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                                onPressed: () => showAboutMyShine(context),
                                child: Text(l10n.welcomeWhatIs),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(l10n.welcomeNoCode, style: small),
                                  Text('  ·  ', style: small),
                                  _SmallLink(
                                    key: const Key('welcome-privacy'),
                                    label: l10n.commonPrivacy,
                                    onTap: () => openMyShinePage(context, 'privacy'),
                                  ),
                                  Text('  ·  ', style: small),
                                  _SmallLink(
                                    key: const Key('welcome-help'),
                                    label: l10n.commonHelp,
                                    onTap: () => openMyShinePage(context, 'help'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A small grey link in the footer line, with a full-size touch area.
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
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.shine.ink),
            ),
          ),
        ),
      ),
    );
  }
}
