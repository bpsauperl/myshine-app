import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../theme.dart';
import '../util/home_screen.dart';
import 'common.dart';

/// In a phone's browser, until the patient puts myShine on the home screen or
/// says "Not now": how to do it on this phone, in one line.
class HomeScreenTip extends StatefulWidget {
  const HomeScreenTip({super.key, this.force = false});

  /// For tests: show it whatever the platform.
  final bool force;

  static const String dismissedKey = 'myshine.homeScreenTipDismissed';

  @override
  State<HomeScreenTip> createState() => _HomeScreenTipState();
}

class _HomeScreenTipState extends State<HomeScreenTip> {
  bool _show = false;

  bool get _phone =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    if (widget.force || (kIsWeb && _phone && !runsFromHomeScreen())) {
      SharedPreferences.getInstance().then((prefs) {
        if (mounted && prefs.getBool(HomeScreenTip.dismissedKey) != true) {
          setState(() => _show = true);
        }
      });
    }
  }

  Future<void> _dismiss() async {
    setState(() => _show = false);
    await (await SharedPreferences.getInstance()).setBool(HomeScreenTip.dismissedKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    final palette = context.shine;
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ShineCard(
        key: const Key('home-screen-tip'),
        padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(ios ? Icons.ios_share_rounded : Icons.add_to_home_screen_rounded, size: 22, color: palette.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.installTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: palette.ink)),
                  const SizedBox(height: 2),
                  Text(
                    ios ? l10n.installIos : l10n.installAndroid,
                    style: TextStyle(fontSize: 13, height: 1.4, color: palette.muted),
                  ),
                ],
              ),
            ),
            TextButton(
              key: const Key('home-screen-tip-dismiss'),
              onPressed: _dismiss,
              child: Text(l10n.installDismiss, style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
