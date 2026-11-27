import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/screens/home/messages_tab.dart';

import 'fakes.dart';

Widget _wrap(Widget child) => localized(Scaffold(body: child));

/// Example data only.
const _clinic = Clinic(
  name: 'Example Dental Studio',
  phone: '+386 1 000 0000',
  email: 'hello@example.test',
);

Features _features({
  bool messages = true,
  int replyDays = 2,
  bool photosWithMessages = true,
}) => Features.fromJson(
  featuresJson(
    messages: messages,
    replyDays: replyDays,
    photosWithMessages: photosWithMessages,
  ),
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
    final attach = tester.widget<ComposerButton>(
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

  testWidgets('says within how many working days the clinic answers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: FakeApiClient(),
          active: true,
          features: _features(replyDays: 2),
          clinic: _clinic,
        ),
      ),
    );
    await tester.pump();
    expect(
      find.text('Your clinic answers within 2 working days.'),
      findsOneWidget,
    );

    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: FakeApiClient(),
          active: true,
          features: _features(replyDays: 1),
          clinic: _clinic,
        ),
      ),
    );
    await tester.pump();
    expect(
      find.text('Your clinic answers within 1 working day.'),
      findsOneWidget,
    );
  });

  testWidgets('an older server keeps the answer time as it was', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(MessagesTab(api: FakeApiClient(), active: true)),
    );
    await tester.pump();

    expect(
      find.text(
        'Write to your clinic. They usually answer within a working day.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('message-input')), findsOneWidget);
    expect(find.byKey(const Key('messages-off')), findsNothing);
  });

  testWidgets('no camera button where the clinic takes no photos in messages', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: FakeApiClient(),
          active: true,
          cameraSupported: true,
          takePhoto: FakeCamera().take,
          features: _features(photosWithMessages: false),
          clinic: _clinic,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('message-attach')), findsNothing);
    expect(find.byKey(const Key('message-input')), findsOneWidget);
    expect(find.byKey(const Key('message-send')), findsOneWidget);
  });

  testWidgets('messages off: the clinic\'s phone and email, nothing to write', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: FakeApiClient(),
          active: true,
          cameraSupported: true,
          features: _features(messages: false),
          clinic: _clinic,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('messages-off')), findsOneWidget);
    expect(find.text('Call or write to your clinic'), findsOneWidget);
    expect(
      find.text(
        'Your clinic does not use messages in myShine. Reach them by phone or email.',
      ),
      findsOneWidget,
    );
    expect(find.text('Example Dental Studio'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('clinic-phone')),
        matching: find.text('+386 1 000 0000'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('clinic-email')),
        matching: find.text('hello@example.test'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('message-input')), findsNothing);
    expect(find.byKey(const Key('message-send')), findsNothing);
    expect(find.byKey(const Key('message-attach')), findsNothing);
    expect(find.text('Earlier messages'), findsNothing);
    expect(find.text('No messages yet'), findsNothing);
  });

  testWidgets('messages off: earlier messages stay to read', (tester) async {
    final api = FakeApiClient(
      inbox: const [
        Message(
          id: 1,
          author: MessageAuthor.clinic,
          name: 'Example Dental Studio',
          body: 'How are the new aligners?',
        ),
        Message(id: 2, author: MessageAuthor.patient, body: 'Fine, thank you.'),
      ],
    );
    await tester.pumpWidget(
      _wrap(
        MessagesTab(
          api: api,
          active: true,
          features: _features(messages: false),
          clinic: _clinic,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('messages-off')), findsOneWidget);
    expect(find.text('Earlier messages'), findsOneWidget);
    expect(find.text('How are the new aligners?'), findsOneWidget);
    expect(find.text('Fine, thank you.'), findsOneWidget);
    expect(find.byKey(const Key('message-input')), findsNothing);
  });
}
