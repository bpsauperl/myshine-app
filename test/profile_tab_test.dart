import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/home/profile_tab.dart';
import 'package:myshine/state/me_controller.dart';
import 'package:myshine/state/session.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Future<(Session, FakeApiClient)> _show(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final api = FakeApiClient();
  final session = Session(
    storage: MemorySessionStorage(token: 'test-token'),
    clientFactory: (_, _) => api,
  );
  await session.load();
  final me = MeController(api: api);
  await me.refresh();
  await tester.pumpWidget(
    SessionScope(
      session: session,
      child: MaterialApp(
        theme: buildShineTheme(Brightness.light),
        home: Scaffold(body: ProfileTab(me: me)),
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
}
