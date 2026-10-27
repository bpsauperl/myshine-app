import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/screens/home/check_in_card.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildShineTheme(Brightness.light),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

/// Aligner 5 is due on 29 Oct (example data).
CheckInState _state({int lateDays = 0}) => CheckInState(
  enabled: true,
  nextAligner: 5,
  dueOn: DateTime(2026, 10, 29),
  lateDays: lateDays,
);

final _dueDay = DateTime(2026, 10, 29);

Future<void> _send(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('check-in-send')));
  await tester.tap(find.byKey(const Key('check-in-send')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('on the due day: confirm the change, say how it fits, send', (
    tester,
  ) async {
    final api = FakeApiClient();
    CheckIn? sent;
    await tester.pumpWidget(
      _wrap(
        CheckInCard(
          api: api,
          checkIn: _state(),
          now: _dueDay,
          onSent: (checkIn) => sent = checkIn,
        ),
      ),
    );

    expect(find.text('Switch to aligner 5'), findsOneWidget);
    expect(find.text('Due today.'), findsOneWidget);
    expect(find.textContaining('hours'), findsNothing);

    await tester.tap(find.byKey(const Key('check-in-switched')));
    await tester.tap(find.byKey(const Key('fit-tight')));
    await tester.tap(find.byKey(const Key('comfort-mild')));
    await tester.enterText(
      find.byKey(const Key('check-in-notes')),
      'A bit tight at the front.',
    );
    await _send(tester);

    final draft = api.sentCheckIns.single;
    expect(draft.fit, 'tight');
    expect(draft.comfort, 'mild');
    expect(draft.notes, 'A bit tight at the front.');
    expect(draft.toJson().containsKey('wear_hours'), isFalse);
    expect(sent?.aligner, 5);
    expect(find.text('Aligner 5 it is. Thank you!'), findsOneWidget);
    expect(find.byKey(const Key('check-in-form')), findsNothing);
  });

  testWidgets('asks to confirm the change, then the fit', (tester) async {
    final api = FakeApiClient();
    await tester.pumpWidget(
      _wrap(CheckInCard(api: api, checkIn: _state(), now: _dueDay)),
    );

    await _send(tester);
    expect(
      find.text('Confirm that you have put in aligner 5.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('check-in-switched')));
    await tester.tap(find.byKey(const Key('check-in-switched')));
    await _send(tester);
    expect(find.text('Choose how aligner 5 fits.'), findsOneWidget);
    expect(api.sentCheckIns, isEmpty);
  });

  testWidgets('before it is due, a quiet line with a way to check in early', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CheckInCard(
          api: FakeApiClient(),
          checkIn: _state(),
          now: DateTime(2026, 10, 26),
        ),
      ),
    );

    expect(find.text('Aligner 5 on Thursday'), findsOneWidget);
    expect(find.byKey(const Key('check-in-form')), findsNothing);

    await tester.tap(find.byKey(const Key('check-in-early')));
    await tester.pump();
    expect(find.byKey(const Key('check-in-form')), findsOneWidget);
  });

  testWidgets('a late change says how late, calmly', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CheckInCard(
          api: FakeApiClient(),
          checkIn: _state(lateDays: 2),
          now: DateTime(2026, 10, 31),
        ),
      ),
    );

    expect(
      find.text('Due 2 days ago. Check in when you\'ve changed.'),
      findsOneWidget,
    );
  });

  testWidgets('nothing shows when the doctor doesn\'t use check-in', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(CheckInCard(api: FakeApiClient(), checkIn: CheckInState.off)),
    );

    expect(find.byKey(const Key('check-in-form')), findsNothing);
    expect(find.byKey(const Key('check-in-upcoming')), findsNothing);
  });

  testWidgets('shows the server message when the check-in is refused', (
    tester,
  ) async {
    final api = FakeApiClient(
      checkInError: const ApiException(
        'Your clinic follows your schedule without check-ins.',
        statusCode: 409,
      ),
    );
    await tester.pumpWidget(
      _wrap(CheckInCard(api: api, checkIn: _state(), now: _dueDay)),
    );

    await tester.tap(find.byKey(const Key('check-in-switched')));
    await tester.tap(find.byKey(const Key('fit-seated')));
    await _send(tester);

    expect(
      find.text('Your clinic follows your schedule without check-ins.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('check-in-thanks')), findsNothing);
  });

  testWidgets('takes intraoral photos by view, removes one, sends the rest', (
    tester,
  ) async {
    final api = FakeApiClient();
    final camera = FakeCamera();
    await tester.pumpWidget(
      _wrap(
        CheckInCard(
          api: api,
          checkIn: _state(),
          now: _dueDay,
          cameraSupported: true,
          takePhoto: camera.take,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('check-in-switched')));
    await tester.tap(find.byKey(const Key('fit-loose')));
    await tester.pump();
    expect(
      find.text(
        'Photos of your teeth with the aligner in help your clinic see what\'s wrong.',
      ),
      findsOneWidget,
    );
    for (final view in IntraoralView.values) {
      expect(find.byKey(Key('photo-take-${view.key}')), findsOneWidget);
    }

    for (final key in ['front', 'upper', 'lower']) {
      await tester.ensureVisible(find.byKey(Key('photo-take-$key')));
      await tester.tap(find.byKey(Key('photo-take-$key')));
      await tester.pumpAndSettle();
    }
    expect(camera.prompts.first.title, 'Front photo');

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('photo-upper')),
        matching: find.byIcon(Icons.close_rounded),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('photo-take-upper')), findsOneWidget);

    await _send(tester);

    final photos = api.sentCheckIns.single.photos;
    expect(photos.keys, [IntraoralView.front, IntraoralView.lower]);
    expect(photos[IntraoralView.lower]!.filename, 'photo-3.png');
  });

  testWidgets('on web a calm note replaces the camera', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CheckInCard(
          api: FakeApiClient(),
          checkIn: _state(),
          now: _dueDay,
          cameraSupported: false,
          takePhoto: FakeCamera().take,
        ),
      ),
    );

    expect(find.byKey(const Key('photos-unavailable')), findsOneWidget);
    expect(find.byKey(const Key('photo-take-front')), findsNothing);
  });
}
