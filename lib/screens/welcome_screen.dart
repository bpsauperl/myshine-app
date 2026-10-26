import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

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
                          onLongPress: () => showServerSettings(
                            context,
                            SessionScope.of(context),
                          ),
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
                            'by SmileLabs',
                            style: KitType.label(color: p.secondary).copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const KitArchHero(height: 280),
                    const KitHeadline(
                      eyebrow: 'Shine clear aligners',
                      title: 'Your smile,',
                      muted: 'revealed.',
                      size: 56,
                      body: 'See your new smile in a minute. Then follow every aligner, day by day, with your clinic.',
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: KitButton(
                            key: const Key('welcome-simulate'),
                            label: 'See your new smile',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SelfieScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: KitButton.secondary(
                            key: const Key('welcome-code'),
                            label: 'Clinic code',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ConnectScreen(),
                              ),
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
