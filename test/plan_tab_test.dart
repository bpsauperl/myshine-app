import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/home/plan_tab.dart';
import 'package:myshine/state/me_controller.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Future<void> _show(WidgetTester tester, {required bool shared}) async {
  final me = MeController(
    api: FakeApiClient(me: meJson(planShared: shared)),
  );
  await me.refresh();
  await tester.pumpWidget(
    MaterialApp(
      theme: buildShineTheme(Brightness.light),
      home: Scaffold(body: PlanTab(me: me)),
    ),
  );
}

void main() {
  testWidgets('a shared plan can be opened', (tester) async {
    await _show(tester, shared: true);

    expect(find.text('Series 1 · in 3D'), findsOneWidget);
    expect(find.text('Open your plan'), findsOneWidget);
  });

  testWidgets('until the clinic shares it, the plan waits', (tester) async {
    await _show(tester, shared: false);

    expect(find.byKey(const Key('plan-not-shared')), findsOneWidget);
    expect(find.text('Open your plan'), findsNothing);
  });
}
