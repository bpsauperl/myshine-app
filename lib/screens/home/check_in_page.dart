import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'check_in_card.dart';

/// The check-in on its own white page, opened from Today's black button:
/// a round close button, then the questions with big answer rows.
class CheckInPage extends StatelessWidget {
  const CheckInPage({
    super.key,
    required this.api,
    required this.checkIn,
    this.onSent,
    this.now,
  });

  final ApiClient api;
  final CheckInState checkIn;
  final ValueChanged<CheckIn>? onSent;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final palette = context.shine;
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              children: [
                Row(
                  children: [
                    Semantics(
                      button: true,
                      label: l10n.commonBack,
                      excludeSemantics: true,
                      child: Material(
                        color: palette.card,
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('check-in-close'),
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.close_rounded, size: 18, color: palette.ink),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Wordmark(size: 15),
                  ],
                ),
                const SizedBox(height: 24),
                CheckInCard(
                  api: api,
                  checkIn: checkIn,
                  now: now,
                  framed: false,
                  onSent: onSent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
