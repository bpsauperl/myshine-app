import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

import '../../l10n/l10n.dart';
import '../../state/me_controller.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import 'home_shell.dart';

/// The plan in 3D, once the clinic shares it.
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
        KitArchHero(height: 220, semanticLabel: l10n.planHeroLabel),
        const SizedBox(height: 8),
        if (plan.shared)
          KitTile(
            key: const Key('plan-card'),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.series == null
                      ? l10n.planIn3d
                      : l10n.planSeriesIn3d(plan.series!),
                  style: KitType.eyebrow(color: p.accentText),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.planCardTitle,
                  style: KitType.title(color: p.ink).copyWith(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.planCardBody,
                  style: KitType.body(color: p.secondary),
                ),
                const SizedBox(height: 18),
                KitButton(
                  label: l10n.planOpen,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => openInBrowserView(context, plan.url!),
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
