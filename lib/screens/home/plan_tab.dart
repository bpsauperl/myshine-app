import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

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
    return TabPage(
      onRefresh: me.refresh,
      children: [
        const PageTitle('Your plan'),
        const KitArchHero(height: 220, semanticLabel: 'Your treatment plan'),
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
                      ? 'In 3D'
                      : 'Series ${plan.series} · in 3D',
                  style: KitType.eyebrow(color: p.accentText),
                ),
                const SizedBox(height: 6),
                Text(
                  'Every step to your new smile.',
                  style: KitType.title(color: p.ink).copyWith(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  'See how your teeth move, aligner by aligner, from today to the end.',
                  style: KitType.body(color: p.secondary),
                ),
                const SizedBox(height: 18),
                KitButton(
                  label: 'Open your plan',
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => openInBrowserView(context, plan.url!),
                ),
              ],
            ),
          )
        else
          const CalmMessage(
            key: Key('plan-not-shared'),
            icon: Icons.view_in_ar_outlined,
            title: 'Your clinic will share your plan here.',
            body: 'When your dentist has prepared your plan, you can see it in 3D right here.',
          ),
      ],
    );
  }
}
