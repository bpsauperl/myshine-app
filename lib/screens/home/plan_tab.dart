import 'package:flutter/material.dart';

import '../../state/me_controller.dart';
import '../../theme.dart';
import '../../widgets/browser.dart';
import '../../widgets/common.dart';
import 'home_shell.dart';

class PlanTab extends StatelessWidget {
  const PlanTab({super.key, required this.me});

  final MeController me;

  @override
  Widget build(BuildContext context) {
    final plan = me.data!.plan;
    final palette = context.shine;
    return TabPage(
      onRefresh: me.refresh,
      children: [
        const PageTitle('Your plan'),
        if (plan.shared)
          ShineCard(
            key: const Key('plan-card'),
            onTap: () => openInBrowserView(context, plan.url!),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 180,
                  color: palette.accentSoft,
                  child: Icon(
                    Icons.view_in_ar_rounded,
                    size: 84,
                    color: palette.accentText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your treatment plan in 3D',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'See how your teeth move, step by step, from today to your new smile.',
                        style: TextStyle(color: palette.muted, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Open your plan',
                            style: TextStyle(
                              color: palette.accentText,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: palette.accentText,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
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
