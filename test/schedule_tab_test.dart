import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/home/schedule_tab.dart';
import 'package:myshine/state/me_controller.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Future<void> _show(WidgetTester tester, Map<String, dynamic> json) async {
  final me = MeController(api: FakeApiClient(me: json));
  await me.refresh();
  await tester.pumpWidget(
    MaterialApp(
      theme: buildShineTheme(Brightness.light),
      home: Scaffold(body: ScheduleTab(me: me)),
    ),
  );
}

void main() {
  testWidgets('each aligner change shows when it was checked in', (
    tester,
  ) async {
    await _show(
      tester,
      meJson()
        ..['check_ins'] = [
          {
            'id': 9,
            'aligner': 4,
            'fit': 'seated',
            'aligner_change': true,
            'late_days': 2,
            'at': '2026-10-24T08:00:00+02:00',
          },
          {
            'id': 8,
            'aligner': 3,
            'fit': 'seated',
            'aligner_change': true,
            'late_days': 0,
            'at': '2026-10-15T08:00:00+02:00',
          },
          {
            'id': 7,
            'aligner': 5,
            'fit': 'seated',
            'outcome': 'continue',
            'at': '2026-10-20T08:00:00+02:00',
          },
        ],
    );

    expect(find.text('Checked in 24 Oct · 2 days late'), findsOneWidget);
    expect(find.text('Checked in 15 Oct · on time'), findsOneWidget);
    expect(find.byKey(const Key('checked-in-5')), findsNothing);
    expect(find.byKey(const Key('schedule-now')), findsOneWidget);
  });

  testWidgets('before treatment starts there is no schedule', (tester) async {
    await _show(tester, meJson(withTherapy: false));

    expect(find.text('No schedule yet'), findsOneWidget);
  });
}
