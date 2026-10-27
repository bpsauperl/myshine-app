import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/reminders/reminder_plan.dart';

import 'fakes.dart';

Therapy _therapy({bool checkIn = true, int lateDays = 0}) =>
    MeData.fromJson(meJson(checkIn: checkIn, lateDays: lateDays)).therapy!;

List<PlannedReminder> _plan(Therapy? therapy, DateTime now) =>
    planReminders(therapy, const EnglishReminderTexts(), now: now);

void main() {
  test('with check-in: the morning of the change, and two days later', () {
    final plan = _plan(_therapy(), DateTime(2026, 10, 27, 12));

    expect(plan.map((r) => r.at), [
      DateTime(2026, 10, 29, 9),
      DateTime(2026, 10, 31, 19),
    ]);
    expect(plan.first.title, 'Time for aligner 5');
    expect(plan.first.body, contains('check in'));
    expect(plan.last.title, 'Did you switch to aligner 5?');
  });

  test('late: only the follow-up is still ahead', () {
    final plan = _plan(_therapy(lateDays: 1), DateTime(2026, 10, 30, 8));

    expect(plan.map((r) => r.id), [lateReminderId]);
  });

  test('more than two days late: nothing more', () {
    expect(_plan(_therapy(), DateTime(2026, 11, 1)), isEmpty);
  });

  test('without check-in: only the change day, from the plan', () {
    final plan = _plan(_therapy(checkIn: false), DateTime(2026, 10, 27));

    expect(plan.single.at, DateTime(2026, 10, 29, 9));
    expect(plan.single.title, 'Time for aligner 5');
    expect(plan.single.body, isNot(contains('check in')));
  });

  test('before treatment there is nothing to remind of', () {
    expect(_plan(null, DateTime(2026, 10, 27)), isEmpty);
  });
}
