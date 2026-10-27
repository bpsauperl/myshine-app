import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/l10n/l10n.dart';
import 'package:myshine/screens/home/schedule_tab.dart';
import 'package:myshine/screens/home/today_tab.dart';
import 'package:myshine/state/me_controller.dart';

import 'fakes.dart';

void main() {
  testWidgets('Today speaks Slovenian, dates included', (tester) async {
    final me = MeController(api: FakeApiClient());
    await me.refresh();
    await tester.pumpWidget(
      localized(
        Scaffold(
          body: TodayTab(me: me, now: DateTime(2026, 10, 24)),
        ),
        locale: const Locale('sl'),
      ),
    );

    expect(find.text('Živjo, Ana'), findsOneWidget);
    expect(find.text('sobota, 24. oktober'), findsOneWidget);
    expect(find.text('Četrtek', findRichText: true), findsOneWidget);
    expect(find.text('Alajner 5 v četrtek'), findsOneWidget);
  });

  testWidgets('the schedule shows Slovenian dates and the dual', (
    tester,
  ) async {
    final me = MeController(
      api: FakeApiClient(
        me: meJson()
          ..['check_ins'] = [
            {
              'id': 9,
              'aligner': 4,
              'fit': 'seated',
              'aligner_change': true,
              'late_days': 2,
              'at': '2026-10-24T08:00:00+02:00',
            },
          ],
      ),
    );
    await me.refresh();
    await tester.pumpWidget(
      localized(
        Scaffold(body: ScheduleTab(me: me)),
        locale: const Locale('sl'),
      ),
    );

    expect(
      find.text('Menjava prijavljena 24. okt. · 2 dneva zamude'),
      findsOneWidget,
    );
  });

  test('plurals follow each language', () {
    final sl = lookupAppLocalizations(const Locale('sl'));
    expect(sl.commonDaysLate(1), '1 dan zamude');
    expect(sl.commonDaysLate(2), '2 dneva zamude');
    expect(sl.commonDaysLate(3), '3 dnevi zamude');
    expect(sl.commonDaysLate(5), '5 dni zamude');

    final sr = lookupAppLocalizations(serbianLatin);
    expect(sr.scheduleAligners(21), '21 alajner');
    expect(sr.scheduleAligners(22), '22 alajnera');
    expect(sr.scheduleAligners(25), '25 alajnera');
  });

  test('Serbian is always Latin, unknown languages fall back to English', () {
    expect(
      resolveAppLocale([
        const Locale('sr', 'RS'),
      ], AppLocalizations.supportedLocales),
      serbianLatin,
    );
    expect(
      resolveAppLocale([const Locale('fr')], AppLocalizations.supportedLocales),
      const Locale('en'),
    );
  });
}
