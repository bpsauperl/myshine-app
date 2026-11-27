import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/screens/home/home_shell.dart';
import 'package:myshine/screens/rules_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Future<void> _open(WidgetTester tester, FakeApiClient api) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    localized(HomeShell(api: api, onUnauthorized: () async {})),
  );
  await tester.pumpAndSettle();
}

FakeApiClient _api({
  bool rulesSeen = false,
  bool messages = true,
  ApiException? rulesError,
}) => FakeApiClient(
  me: meJson(
    features: featuresJson(rulesSeen: rulesSeen, messages: messages),
  ),
  rulesError: rulesError,
);

void main() {
  testWidgets('"Before you start" shows once, before the tabs', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final api = _api();
    await _open(tester, api);

    expect(find.byKey(const Key('rules-screen')), findsOneWidget);
    expect(find.text('Before you start'), findsOneWidget);
    for (final title in [
      'Your clinic decides',
      'It is your choice',
      'Not for emergencies',
      'No diagnosis',
      'Stop any time',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
    expect(find.text('Pain or a broken aligner? Call your clinic.'), findsOneWidget);
    expect(find.byKey(const Key('rules-privacy')), findsOneWidget);
    expect(find.byKey(const Key('rules-help')), findsOneWidget);
    expect(find.text('Hello, Ana'), findsNothing);
    expect(api.rulesAccepted, 0);

    await tester.tap(find.byKey(const Key('rules-accept')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('rules-screen')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(api.rulesAccepted, 1);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(RulesScreen.seenKey('2026-11')), isTrue);
    expect(RulesScreen.seenKey('2026-11'), 'myshine.rulesSeen.2026-11');
  });

  testWidgets('no rules once the server knows they were read', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final api = _api(rulesSeen: true);
    await _open(tester, api);

    expect(find.byKey(const Key('rules-screen')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(api.rulesAccepted, 0);
  });

  testWidgets('an older server has no rules to show', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final api = FakeApiClient();
    await _open(tester, api);

    expect(find.byKey(const Key('rules-screen')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(api.rulesAccepted, 0);
  });

  testWidgets('read on this phone: no rules again, and the server is told', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      RulesScreen.seenKey('2026-11'): true,
    });
    final api = _api();
    await _open(tester, api);

    expect(find.byKey(const Key('rules-screen')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
    expect(api.rulesAccepted, 1, reason: 'the server still says unread');
  });

  testWidgets('an older version read on this phone does not count', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      RulesScreen.seenKey('2025-01'): true,
    });
    await _open(tester, _api());

    expect(find.byKey(const Key('rules-screen')), findsOneWidget);
  });

  testWidgets('a server that cannot be told still lets the patient in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final api = _api(
      rulesError: const ApiException(
        'We couldn\'t reach myShine.',
        failure: ApiFailure.offline,
      ),
    );
    await _open(tester, api);

    await tester.tap(find.byKey(const Key('rules-accept')));
    await tester.pumpAndSettle();

    expect(api.rulesAccepted, 1);
    expect(find.byKey(const Key('rules-screen')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(RulesScreen.seenKey('2026-11')), isTrue);
  });

  testWidgets('the rules fit a small phone: the button is reached by scrolling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 960);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    var accepted = 0;
    await tester.pumpWidget(
      localized(RulesScreen(onAccept: () => accepted++)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Before you start'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('rules-accept')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rules-accept')));

    expect(accepted, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('messages off: the fourth tab is "Clinic", without a dot', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final handle = tester.ensureSemantics();
    await _open(tester, _api(rulesSeen: true, messages: false));

    expect(find.text('Clinic'), findsOneWidget);
    expect(find.text('Messages'), findsNothing);
    expect(find.bySemanticsLabel('Messages, new'), findsNothing);
    expect(find.bySemanticsLabel('Clinic, new'), findsNothing);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Clinic'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('messages-off')), findsOneWidget);
    expect(find.byKey(const Key('clinic-phone')), findsWidgets);
    expect(find.byKey(const Key('message-input')), findsNothing);
    handle.dispose();
  });

  testWidgets('messages on: the fourth tab stays "Messages", with its dot', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final handle = tester.ensureSemantics();
    await _open(tester, _api(rulesSeen: true));

    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Clinic'), findsNothing);
    expect(find.bySemanticsLabel('Messages, new'), findsOneWidget);
    handle.dispose();
  });
}
