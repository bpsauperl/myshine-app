import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../config.dart';
import '../l10n/l10n.dart';
import '../state/session.dart';
import '../widgets/common.dart';
import 'connect_screen.dart';
import 'server_settings_sheet.dart';
import 'simulation/selfie_screen.dart';

/// The start, before the patient connects with their clinic: the aligner in
/// soft light, one headline, and two ways in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              KitSize.gutter + 4,
              12,
              KitSize.gutter + 4,
              24,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  minHeight: constraints.maxHeight - 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          key: const Key('welcome-logo'),
                          onLongPress: AppConfig.serverSettingEnabled
                              ? () => showServerSettings(
                                  context,
                                  SessionScope.of(context),
                                )
                              : null,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Wordmark(size: 22),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: ShapeDecoration(
                            color: p.tile,
                            shape: StadiumBorder(
                              side: BorderSide(color: p.hairline, width: 0.5),
                            ),
                          ),
                          child: Text(
                            l10n.welcomeBySmileLabs,
                            style: KitType.label(color: p.secondary).copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    KitArchHero(height: 280, semanticLabel: l10n.archHeroLabel),
                    KitHeadline(
                      eyebrow: l10n.welcomeEyebrow,
                      title: l10n.welcomeTitle,
                      muted: l10n.welcomeTitleMuted,
                      size: 56,
                      body: l10n.welcomeBody,
                    ),
                    const SizedBox(height: 28),
                    // Stacked, so every language fits on the buttons.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KitButton(
                          key: const Key('welcome-simulate'),
                          label: l10n.welcomeSimulate,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SelfieScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        KitButton.secondary(
                          key: const Key('welcome-code'),
                          label: l10n.welcomeClinicCode,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ConnectScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
