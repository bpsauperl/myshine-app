import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/intro_story.dart';
import 'package:myshine/app.dart';
import 'package:myshine/state/session.dart';

import 'fakes.dart';

Future<Session> _start(
  WidgetTester tester, {
  String? linkCode,
  String? token,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final session = Session(
    storage: MemorySessionStorage(token: token),
    clientFactory: (_, _) => FakeApiClient(),
  );
  await session.load();
  await tester.pumpWidget(MyShineApp(session: session, linkCode: linkCode));
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
  testWidgets('the opening film moves on with a tap on the right and back on the left', (tester) async {
    await _start(tester);
    final story = find.byType(IntroStory);
    final box = tester.getRect(story);

    await tester.tapAt(Offset(box.right - 40, box.top + 200));
    await tester.pumpAndSettle();
    expect(find.text('A quick 3D scan. No moulds.'), findsOneWidget);

    await tester.tapAt(Offset(box.left + 40, box.top + 200));
    await tester.pumpAndSettle();
    expect(find.text('It starts with your dentist.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('welcome-pause')));
    await tester.pump();
    expect(find.bySemanticsLabel('Play the video'), findsOneWidget);
  });

  testWidgets('a clinic code connects and opens the app', (tester) async {
    final session = await _start(tester);
    expect(find.byType(IntroStory), findsOneWidget);
    expect(find.text('It starts with your dentist.'), findsOneWidget);
    expect(find.byKey(const Key('welcome-simulate')), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('welcome-code')));
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

  testWidgets('what myShine is for opens from the welcome screen', (
    tester,
  ) async {
    await _start(tester);

    await tester.ensureVisible(find.byKey(const Key('welcome-about')));
    await tester.tap(find.byKey(const Key('welcome-about')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('about-myshine')), findsOneWidget);
    expect(find.text('What myShine is for'), findsOneWidget);
    expect(find.textContaining("doesn't diagnose"), findsOneWidget);
    expect(find.byKey(const Key('about-privacy')), findsOneWidget);
  });

  testWidgets('development builds open the server setting from the logo', (
    tester,
  ) async {
    await _start(tester);

    await tester.longPress(find.byKey(const Key('welcome-logo')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('server-url')), findsOneWidget);
  });

  testWidgets('the link in the clinic\'s email types the code, the patient connects', (
    tester,
  ) async {
    final session = await _start(tester, linkCode: 'ABCD-2345');
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.byKey(const Key('connect-code')),
    );
    expect(field.controller!.text, 'ABCD-2345');
    expect(session.isConnected, isFalse, reason: 'the patient taps the button');

    await tester.tap(find.byKey(const Key('connect-button')));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(session.isConnected, isTrue);
    expect(find.text('Hello, Ana'), findsOneWidget);
  });

  testWidgets('someone already connected stays in the app whatever the link says', (
    tester,
  ) async {
    final session = await _start(
      tester,
      linkCode: 'ABCD-2345',
      token: 'test-token',
    );
    await tester.pumpAndSettle();

    expect(session.isConnected, isTrue);
    expect(find.byKey(const Key('connect-code')), findsNothing);
    expect(find.text('Hello, Ana'), findsOneWidget);
  });
}
