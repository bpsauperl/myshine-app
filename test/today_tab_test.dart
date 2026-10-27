import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/screens/home/home_shell.dart';
import 'package:myshine/screens/home/today_tab.dart';
import 'package:myshine/state/me_controller.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Future<MeController> _loaded(FakeApiClient api) async {
  final me = MeController(api: api);
  await me.refresh();
  return me;
}

Widget _wrap(Widget child) => MaterialApp(
  theme: buildShineTheme(Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('shows today\'s aligner, the day and the next change', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(find.text('Aligner 04/22', findRichText: true), findsOneWidget);
    expect(find.textContaining('day 3 of 7'), findsOneWidget);
    expect(find.text('Thursday', findRichText: true), findsOneWidget);
    expect(find.text('4 days left', findRichText: true), findsOneWidget);
    expect(find.textContaining('22 hours a day'), findsOneWidget);
    expect(find.text('Check in'), findsOneWidget);
  });

  testWidgets('a late change shows on the next aligner tile', (tester) async {
    final me = await _loaded(FakeApiClient(me: meJson(lateDays: 2)));
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 31))),
    );

    expect(find.text('2 days late', findRichText: true), findsOneWidget);
  });

  testWidgets('without check-in only the schedule shows', (tester) async {
    final me = await _loaded(FakeApiClient(me: meJson(checkIn: false)));
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    expect(find.text('Aligner 04/22', findRichText: true), findsOneWidget);
    expect(find.byKey(const Key('hero-check-in')), findsNothing);
    expect(find.byKey(const Key('check-in-upcoming')), findsNothing);
  });

  testWidgets('says the next aligner is tomorrow the day before', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 28))),
    );
    expect(find.text('Tomorrow', findRichText: true), findsOneWidget);
  });

  testWidgets('says treatment has not started when therapy is null', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient(me: meJson(withTherapy: false)));
    await tester.pumpWidget(_wrap(TodayTab(me: me)));

    expect(find.text('Treatment not started yet'), findsOneWidget);
    expect(find.text('Check in'), findsNothing);
  });

  testWidgets('the tabs load /me and mark unread messages', (tester) async {
    final handle = tester.ensureSemantics();
    final api = FakeApiClient();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShineTheme(Brightness.light),
        home: HomeShell(api: api, onUnauthorized: () async {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(api.meCalls, 1);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(find.bySemanticsLabel('Messages (2), new'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('an expired token goes back to the start', (tester) async {
    var signedOut = false;
    final api = FakeApiClient(
      meError: const ApiException('Please connect again.', statusCode: 401),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShineTheme(Brightness.light),
        home: HomeShell(api: api, onUnauthorized: () async => signedOut = true),
      ),
    );
    await tester.pumpAndSettle();

    expect(signedOut, isTrue);
  });
}
