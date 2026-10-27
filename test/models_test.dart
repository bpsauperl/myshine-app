import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/models.dart';

import 'fakes.dart';

void main() {
  test('parses /me with a therapy', () {
    final me = MeData.fromJson(meJson(planShared: true));

    expect(me.patient.firstName, 'Ana');
    expect(me.patient.clinic.name, 'Example Dental Studio');
    expect(me.patient.doctorName, 'Dr. Example');
    expect(me.plan.shared, isTrue);
    expect(me.plan.url, 'https://example.test/plan');

    final therapy = me.therapy!;
    expect(therapy.total, 22);
    expect(therapy.current!.aligner, 4);
    expect(therapy.current!.day, 3);
    expect(therapy.current!.days, 7);
    expect(therapy.nextChange, DateTime(2026, 10, 29));
    expect(therapy.endsOn, DateTime(2027, 3, 3));
    expect(therapy.rows.map((r) => r.state), [
      AlignerState.done,
      AlignerState.now,
      AlignerState.next,
    ]);

    expect(me.checkIns.single.fitLabel, 'Fits well');
    expect(me.consents.first.isSigned, isTrue);
    expect(me.consents.last.signUrl, 'https://example.test/sign');
    expect(me.unreadMessages, 2);
  });

  test('parses /me before treatment starts (therapy null)', () {
    final me = MeData.fromJson(meJson(withTherapy: false));

    expect(me.therapy, isNull);
    expect(me.plan.shared, isFalse);
    expect(me.plan.url, isNull);
  });

  test('a shared plan without a link is treated as not shared', () {
    final plan = PlanLink.fromJson({'shared': true, 'url': null});
    expect(plan.shared, isFalse);
  });

  test('check-in drafts leave out empty optional fields', () {
    expect(const CheckInDraft(fit: 'tight', notes: '  ').toJson(), {
      'fit': 'tight',
    });
    expect(
      const CheckInDraft(
        fit: 'seated',
        comfort: 'mild',
        notes: ' Ok ',
      ).toJson(),
      {'fit': 'seated', 'comfort': 'mild', 'notes': 'Ok'},
    );
  });

  test('check-in state: off when missing, the next change when on', () {
    final off = Therapy.fromJson({'total': 22});
    expect(off.checkIn.canCheckIn, isFalse);

    final on = MeData.fromJson(meJson()).therapy!.checkIn;
    expect(on.enabled, isTrue);
    expect(on.nextAligner, 5);
    expect(on.dueOn, DateTime(2026, 10, 29));
    expect(on.lateDays, 0);
  });
}
