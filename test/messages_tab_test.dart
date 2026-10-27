import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/screens/home/messages_tab.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildShineTheme(Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('attaches photos, removes one and sends the rest without text', (
    tester,
  ) async {
    final api = FakeApiClient();
    final camera = FakeCamera();
    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: api,
          active: true,
          cameraSupported: true,
          takePhoto: camera.take,
        ),
      ),
    );
    await tester.pump();

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('message-attach')));
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const Key('attachment-2')), findsOneWidget);
    final attach = tester.widget<IconButton>(
      find.byKey(const Key('message-attach')),
    );
    expect(attach.onPressed, isNull, reason: 'at most 3 photos');

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('attachment-0')),
        matching: find.byIcon(Icons.close_rounded),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('message-send')));
    await tester.pumpAndSettle();

    expect(api.sentMessages.single, '');
    expect(api.sentMessagePhotos.single.map((p) => p.filename), [
      'photo-2.png',
      'photo-3.png',
    ]);
    expect(find.byKey(const Key('message-attachments')), findsNothing);
    expect(find.byKey(const Key('message-photo-1')), findsOneWidget);
    expect(find.byKey(const Key('message-photo-2')), findsOneWidget);
  });

  testWidgets('sends nothing without text or photos', (tester) async {
    final api = FakeApiClient();
    await tester.pumpWidget(
      _wrap(MessagesTab(api: api, active: true, cameraSupported: true)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('message-send')));
    await tester.pump();

    expect(api.sentMessages, isEmpty);
  });

  testWidgets('on web there is no camera button', (tester) async {
    await tester.pumpWidget(
      _wrap(
        MessagesTab(api: FakeApiClient(), active: true, cameraSupported: false),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('message-attach')), findsNothing);
  });
}
