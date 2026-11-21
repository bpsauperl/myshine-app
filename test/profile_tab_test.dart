import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/home/profile_tab.dart';
import 'package:myshine/state/me_controller.dart';
import 'package:myshine/state/session.dart';

import 'fakes.dart';

Future<(Session, FakeApiClient)> _show(
  WidgetTester tester, {
  FakeReminders? reminders,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final api = FakeApiClient();
  final session = Session(
    storage: MemorySessionStorage(token: 'test-token'),
    clientFactory: (_, _) => api,
    reminders: reminders ?? FakeReminders(),
  );
  await session.load();
  final me = MeController(api: api);
  await me.refresh();
  await tester.pumpWidget(
    SessionScope(
      session: session,
      child: localized(
        Scaffold(
          body: ProfileTab(me: me, reminders: session.reminders),
        ),
      ),
    ),
  );
  return (session, api);
}

void main() {
  testWidgets('shows the clinic, the dentist and the documents', (
    tester,
  ) async {
    await _show(tester);

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Example Dental Studio'), findsOneWidget);
    expect(find.text('Dr. Example'), findsOneWidget);
    expect(find.text('+386 1 000 0000'), findsOneWidget);
  });

  testWidgets('lists what was signed and each device statement, to open', (
    tester,
  ) async {
    await _show(tester);

    expect(find.text('Treatment consent'), findsOneWidget);
    expect(find.text('Aligners · Signed 30 Sep 2026'), findsOneWidget);
    expect(find.text('Statement for your custom-made device'), findsOneWidget);
    expect(find.text('Open'), findsNWidgets(2));
    // The signed consent is a document to open, not a second row; the one
    // still to sign keeps its button.
    expect(find.text('Consent: Shine aligners'), findsNothing);
    expect(find.text('Consent: Retainers'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign'), findsOneWidget);
  });

  testWidgets('About myShine opens what it is for, with help and privacy', (
    tester,
  ) async {
    await _show(tester);

    await tester.ensureVisible(find.byKey(const Key('profile-about')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-about')));
    await tester.pumpAndSettle();

    expect(find.text('What myShine is for'), findsOneWidget);
    expect(find.byKey(const Key('about-help')), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });

  testWidgets('disconnecting asks first, then signs out', (tester) async {
    final (session, api) = await _show(tester);

    await tester.ensureVisible(find.byKey(const Key('disconnect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('disconnect')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(session.isConnected, isTrue);

    await tester.tap(find.byKey(const Key('disconnect')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Disconnect'));
    await tester.pumpAndSettle();

    expect(session.isConnected, isFalse);
    expect(api.loggedOut, isTrue);
  });

  testWidgets('aligner reminders can be turned off and on again', (
    tester,
  ) async {
    final reminders = FakeReminders();
    final (_, api) = await _show(tester, reminders: reminders);
    await tester.pump();
    final calls = api.meCalls;

    await tester.tap(find.byKey(const Key('reminders')));
    await tester.pump();
    expect(reminders.enabled, isFalse);
    expect(
      tester
          .widget<Switch>(
            find.descendant(
              of: find.byKey(const Key('reminders')),
              matching: find.byType(Switch),
            ),
          )
          .value,
      isFalse,
    );

    await tester.tap(find.byKey(const Key('reminders')));
    await tester.pump();
    expect(reminders.enabled, isTrue);
    expect(api.meCalls, calls + 1);
  });
}
