import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shine_kit/shine_kit.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/screens/home/home_shell.dart';
import 'package:myshine/screens/home/today_tab.dart';
import 'package:myshine/state/me_controller.dart';

import 'fakes.dart';

Future<MeController> _loaded(FakeApiClient api) async {
  final me = MeController(api: api);
  await me.refresh();
  return me;
}

Widget _wrap(Widget child) => localized(Scaffold(body: child));

void main() {
  testWidgets('shows today\'s aligner, the day and the next change', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('today-aligner'))).data, '4');
    expect(find.text('of 22 aligners'), findsOneWidget);
    expect(find.textContaining('day 3 of 7'), findsOneWidget);
    expect(find.text('Change to aligner 5 on Thursday'), findsOneWidget);
    expect(find.text('1 done'), findsOneWidget);
    expect(find.text('This aligner'), findsOneWidget);
    expect(find.text('22 h a day', findRichText: true), findsOneWidget);
    expect(find.text('Check in aligner 5'), findsOneWidget);
  });

  testWidgets('the black button opens the check-in on its own page', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    await tester.tap(find.byKey(const Key('hero-check-in')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('check-in-close')), findsOneWidget);
    expect(
      find.byKey(const Key('check-in-upcoming')).evaluate().isNotEmpty ||
          find.byKey(const Key('check-in-form')).evaluate().isNotEmpty,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('check-in-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('check-in-close')), findsNothing);
  });

  testWidgets('shows the last check-in and the clinic, without drawings', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    expect(find.byType(KitArchHero), findsNothing);
    expect(find.textContaining('Last check-in · '), findsOneWidget);
    expect(find.text('Aligner 3 · on time'), findsOneWidget);
    expect(find.textContaining('Fits well · 2 photos'), findsOneWidget);
    expect(find.text('Example Dental Studio'), findsOneWidget);
  });

  testWidgets('a late change shows under the aligner', (tester) async {
    final me = await _loaded(FakeApiClient(me: meJson(lateDays: 2)));
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 31))),
    );

    expect(find.text('Change to aligner 5 · 2 days late'), findsOneWidget);
  });

  testWidgets('without check-in only the schedule shows', (tester) async {
    final me = await _loaded(FakeApiClient(me: meJson(checkIn: false)));
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 24))),
    );

    expect(tester.widget<Text>(find.byKey(const Key('today-aligner'))).data, '4');
    expect(find.byKey(const Key('hero-check-in')), findsNothing);
    expect(find.byKey(const Key('hero-schedule')), findsNothing);
    expect(find.byKey(const Key('check-in-upcoming')), findsNothing);
  });

  testWidgets('says the next aligner is tomorrow the day before', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient());
    await tester.pumpWidget(
      _wrap(TodayTab(me: me, now: DateTime(2026, 10, 28))),
    );
    expect(find.text('Change to aligner 5 tomorrow'), findsOneWidget);
  });

  testWidgets('says treatment has not started when therapy is null', (
    tester,
  ) async {
    final me = await _loaded(FakeApiClient(me: meJson(withTherapy: false)));
    await tester.pumpWidget(_wrap(TodayTab(me: me)));

    expect(find.text('Your clinic starts your treatment'), findsOneWidget);
    expect(find.text('Check in'), findsNothing);
  });

  testWidgets('the tabs load /me and mark unread messages', (tester) async {
    final handle = tester.ensureSemantics();
    final api = FakeApiClient();
    final reminders = FakeReminders();
    await tester.pumpWidget(
      localized(
        HomeShell(api: api, onUnauthorized: () async {}, reminders: reminders),
      ),
    );
    await tester.pumpAndSettle();

    expect(api.meCalls, 1);
    expect(reminders.replaced, 1);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(find.bySemanticsLabel('Messages, new'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('an expired token goes back to the start', (tester) async {
    var signedOut = false;
    final api = FakeApiClient(
      meError: const ApiException('Please connect again.', statusCode: 401),
    );
    await tester.pumpWidget(
      localized(
        HomeShell(api: api, onUnauthorized: () async => signedOut = true),
      ),
    );
    await tester.pumpAndSettle();

    expect(signedOut, isTrue);
  });
}
