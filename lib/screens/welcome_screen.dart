import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../l10n/l10n.dart';
import '../theme.dart';
import '../state/session.dart';
import '../widgets/common.dart';
import 'about_sheet.dart';
import 'connect_screen.dart';
import 'intro_story.dart';
import 'server_settings_sheet.dart';

/// The start, before the patient connects with their clinic: the Shine story
/// as a full-screen film (the dentist, the scan, the plan, the aligner), a
/// line for each scene, and on a dark glass panel what myShine is and the way
/// in with the clinic's code.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _story = GlobalKey<IntroStoryState>();
  int _scene = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    const white = Colors.white;
    final soft = Colors.white.withValues(alpha: 0.72);
    final small = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7));
    final paused = _story.currentState?.paused ?? false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [
            IntroStory(
              key: _story,
              topInset: top,
              onScene: (scene) => setState(() => _scene = scene),
            ),
            // Wordmark and pause, under the bars.
            Positioned(
              left: 20,
              right: 12,
              top: top + 22,
              child: Row(
                children: [
                  GestureDetector(
                    key: const Key('welcome-logo'),
                    onLongPress: AppConfig.serverSettingEnabled
                        ? () => showServerSettings(context, SessionScope.of(context))
                        : null,
                    child: const Wordmark(size: 17, color: white),
                  ),
                  const Spacer(),
                  _GlassRound(
                    key: const Key('welcome-pause'),
                    label: paused ? l10n.introPlay : l10n.introPause,
                    icon: paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    onTap: () => setState(() => _story.currentState?.togglePause()),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 420),
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(
                                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                                  ),
                                  child: child,
                                ),
                              ),
                              child: Text(
                                kIntroScenes[_scene].caption(l10n),
                                key: ValueKey('caption-$_scene'),
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _DarkGlass(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 24, 22, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Semantics(
                                  header: true,
                                  child: Text(
                                    '${l10n.welcomeTitle}\n${l10n.welcomeTitleMuted}',
                                    style: const TextStyle(fontSize: 30, height: 1.08, fontWeight: FontWeight.w700, letterSpacing: -1.1, color: white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(l10n.welcomeBody, style: TextStyle(fontSize: 15, height: 1.45, color: soft)),
                                const SizedBox(height: 22),
                                FilledButton(
                                  key: const Key('welcome-code'),
                                  style: FilledButton.styleFrom(backgroundColor: white, foregroundColor: ShineColors.ink),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(builder: (_) => const ConnectScreen()),
                                  ),
                                  child: Text(l10n.welcomeHaveCode),
                                ),
                                const SizedBox(height: 4),
                                TextButton(
                                  key: const Key('welcome-about'),
                                  style: TextButton.styleFrom(foregroundColor: white, minimumSize: const Size.fromHeight(48)),
                                  onPressed: () => showAboutMyShine(context),
                                  child: Text(l10n.welcomeWhatIs),
                                ),
                                Text(l10n.welcomeNoCode, style: small, textAlign: TextAlign.center),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Dark Liquid Glass: the film shows through, blurred, behind the words and buttons.
class _DarkGlass extends StatelessWidget {
  const _DarkGlass({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(32);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Colors.black.withValues(alpha: 0.38),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16), width: 0.8),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A round glass button on the film.
class _GlassRound extends StatelessWidget {
  const _GlassRound({super.key, required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.white.withValues(alpha: 0.18),
            shape: CircleBorder(side: BorderSide(color: Colors.white.withValues(alpha: 0.25), width: 0.6)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(width: 44, height: 44, child: Icon(icon, size: 22, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small link in the footer line, with a full-size touch area.
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
