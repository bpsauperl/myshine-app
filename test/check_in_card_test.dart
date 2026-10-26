import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/screens/home/check_in_card.dart';
import 'package:myshine/theme.dart';

import 'fakes.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: buildShineTheme(Brightness.light),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets('sends fit, hours, discomfort and notes, then says thank you', (
    tester,
  ) async {
    final api = FakeApiClient();
    await tester.pumpWidget(_wrap(CheckInCard(api: api, aligner: 4)));

    expect(find.text('How is aligner 4?'), findsOneWidget);
    expect(find.text('22 h'), findsOneWidget);

    await tester.tap(find.byKey(const Key('fit-tight')));
    await tester.tap(find.byKey(const Key('hours-minus')));
    await tester.tap(find.byKey(const Key('hours-minus')));
    await tester.tap(find.byKey(const Key('comfort-mild')));
    await tester.enterText(
      find.byKey(const Key('check-in-notes')),
      'A bit tight at the front.',
    );
    await tester.pump();
    expect(find.text('20 h'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('check-in-send')));
    await tester.tap(find.byKey(const Key('check-in-send')));
    await tester.pumpAndSettle();

    final draft = api.sentCheckIns.single;
    expect(draft.fit, 'tight');
    expect(draft.wearHours, 20);
    expect(draft.comfort, 'mild');
    expect(draft.notes, 'A bit tight at the front.');
    expect(find.byKey(const Key('check-in-thanks')), findsOneWidget);
  });

  testWidgets('asks for the fit before sending', (tester) async {
    final api = FakeApiClient();
    await tester.pumpWidget(_wrap(CheckInCard(api: api)));

    await tester.ensureVisible(find.byKey(const Key('check-in-send')));
    await tester.tap(find.byKey(const Key('check-in-send')));
    await tester.pump();

    expect(find.text('Choose how your aligner fits.'), findsOneWidget);
    expect(api.sentCheckIns, isEmpty);
  });

  testWidgets('hours stop at 24', (tester) async {
    await tester.pumpWidget(_wrap(CheckInCard(api: FakeApiClient())));
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byKey(const Key('hours-plus')));
      await tester.pump();
    }
    expect(find.text('24 h'), findsOneWidget);
  });

  testWidgets('shows the server message when the check-in is refused', (
    tester,
  ) async {
    final api = FakeApiClient(
      checkInError: const ApiException(
        'Your treatment hasn\'t started yet.',
        statusCode: 409,
      ),
    );
    await tester.pumpWidget(_wrap(CheckInCard(api: api)));

    await tester.tap(find.byKey(const Key('fit-seated')));
    await tester.ensureVisible(find.byKey(const Key('check-in-send')));
    await tester.tap(find.byKey(const Key('check-in-send')));
    await tester.pumpAndSettle();

    expect(find.text('Your treatment hasn\'t started yet.'), findsOneWidget);
    expect(find.byKey(const Key('check-in-thanks')), findsNothing);
  });
}
