import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../config.dart';
import '../l10n/l10n.dart';
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
    final p = context.kit;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: p.ground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final photoHeight = (constraints.maxHeight * 0.44).clamp(
            240.0,
            440.0,
          );
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(KitSize.panelRadius),
                      ),
                      child: Semantics(
                        image: true,
                        label: l10n.welcomePhotoLabel,
                        child: Image.asset(
                          'assets/images/welcome.webp',
                          key: const Key('welcome-photo'),
                          height: photoHeight,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.25),
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          KitSize.gutter + 4,
                          22,
                          KitSize.gutter + 4,
                          20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                key: const Key('welcome-logo'),
                                onLongPress: AppConfig.serverSettingEnabled
                                    ? () => showServerSettings(
                                        context,
                                        SessionScope.of(context),
                                      )
                                    : null,
                                child: const Wordmark(size: 22),
                              ),
                            ),
                            const SizedBox(height: 18),
                            KitHeadline(
                              eyebrow: l10n.welcomeEyebrow,
                              title: l10n.welcomeTitle,
                              muted: l10n.welcomeTitleMuted,
                              size: 40,
                              body: l10n.welcomeBody,
                            ),
                            const SizedBox(height: 26),
                            KitButton(
                              key: const Key('welcome-code'),
                              label: l10n.welcomeHaveCode,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ConnectScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            KitButton.secondary(
                              key: const Key('welcome-about'),
                              label: l10n.welcomeWhatIs,
                              onPressed: () => showAboutMyShine(context),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.welcomeNoCode,
                              textAlign: TextAlign.center,
                              style: KitType.label(color: p.secondary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  key: const Key('welcome-privacy'),
                                  onPressed: () =>
                                      openMyShinePage(context, 'privacy'),
                                  child: Text(l10n.commonPrivacy),
                                ),
                                Text('·', style: TextStyle(color: p.tertiary)),
                                TextButton(
                                  key: const Key('welcome-help'),
                                  onPressed: () =>
                                      openMyShinePage(context, 'help'),
                                  child: Text(l10n.commonHelp),
                                ),
                              ],
                            ),
                            Text(
                              l10n.profileFooter,
                              textAlign: TextAlign.center,
                              style: KitType.label(color: p.tertiary)
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
