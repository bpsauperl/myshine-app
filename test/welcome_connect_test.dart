import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/app.dart';
import 'package:myshine/state/session.dart';

import 'fakes.dart';

Future<Session> _start(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final session = Session(
    storage: MemorySessionStorage(),
    clientFactory: (_, _) => FakeApiClient(),
  );
  await session.load();
  await tester.pumpWidget(MyShineApp(session: session));
  await tester.pump();
  return session;
}

Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const Key('connect-code')), code);
  await tester.pump();
  await tester.tap(find.byKey(const Key('connect-button')));
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('a clinic code connects and opens the app', (tester) async {
    final session = await _start(tester);
    expect(find.byKey(const Key('welcome-simulate')), findsOneWidget);

    await tester.tap(find.byKey(const Key('welcome-code')));
    await tester.pumpAndSettle();

    await _enterCode(tester, 'WXYZ-2345');
    expect(
      find.text('That code doesn\'t work. Ask your clinic for a new one.'),
      findsOneWidget,
    );
    expect(session.isConnected, isFalse);

    await _enterCode(tester, 'ABCD-2345');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(session.isConnected, isTrue);
    expect(find.text('Hello, Ana'), findsOneWidget);
  });

  testWidgets('development builds open the server setting from the logo', (
    tester,
  ) async {
    await _start(tester);

    await tester.longPress(find.byKey(const Key('welcome-logo')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('server-url')), findsOneWidget);
  });
}
