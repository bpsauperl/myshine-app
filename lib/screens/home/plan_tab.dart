import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import 'home_shell.dart';

/// The plan in 3D, once the doctor shares it: one clear card, no pictures.
class PlanTab extends StatelessWidget {
  const PlanTab({super.key, required this.me});

  final MeController me;

  @override
  Widget build(BuildContext context) {
    final plan = me.data!.plan;
    final p = context.kit;
    final l10n = context.l10n;
    return TabPage(
      onRefresh: me.refresh,
      children: [
        PageTitle(l10n.planTitle),
        if (plan.shared)
          ShineCard(
            key: const Key('plan-card'),
            radius: kHeroRadius,
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.series != null) ...[
                  Text(
                    l10n.planCardSeries(plan.series!),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.secondary),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  l10n.planCardTitle,
                  style: TextStyle(fontSize: 28, height: 1.1, fontWeight: FontWeight.w700, letterSpacing: -0.9, color: p.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.planCardBody,
                  style: TextStyle(fontSize: 16, height: 1.45, color: p.secondary),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () => openInBrowserView(context, plan.url!),
                  child: Text(l10n.planOpen),
                ),
              ],
            ),
          )
        else
          CalmMessage(
            key: const Key('plan-not-shared'),
            icon: Icons.view_in_ar_outlined,
            title: l10n.planNotSharedTitle,
            body: l10n.planNotSharedBody,
          ),
      ],
    );
  }
}
