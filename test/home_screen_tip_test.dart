import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/widgets/home_screen_tip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

void main() {
  testWidgets('the home screen tip shows how, and "Not now" hides it for good', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(localized(const Scaffold(body: HomeScreenTip(force: true))));
    await tester.pumpAndSettle();

    expect(find.text('Put myShine on your home screen'), findsOneWidget);
    await tester.tap(find.byKey(const Key('home-screen-tip-dismiss')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-screen-tip')), findsNothing);
    expect((await SharedPreferences.getInstance()).getBool(HomeScreenTip.dismissedKey), isTrue);

    await tester.pumpWidget(localized(const Scaffold(body: HomeScreenTip(force: true, key: ValueKey(2)))));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-screen-tip')), findsNothing);
  });

  testWidgets('outside the browser there is no tip', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(localized(const Scaffold(body: HomeScreenTip())));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-screen-tip')), findsNothing);
  });
}
