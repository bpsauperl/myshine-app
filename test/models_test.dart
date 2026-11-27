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
    expect(me.consents.first.id, '0199a1b2-0000-7000-8000-000000000001');
    expect(me.documents.map((d) => d.type), ['consent', 'statement']);
    expect(me.documents.first.isConsent, isTrue);
    expect(me.documents.last.url, 'https://example.test/d/statement');
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

  group('features', () {
    test('an older server sends none: everything as before', () {
      final features = MeData.fromJson(meJson()).features;

      expect(features, same(Features.legacy));
      expect(features.messages, isTrue);
      expect(features.replyDays, isNull);
      expect(features.photosWithCheckIns, isTrue);
      expect(features.photosWithMessages, isTrue);
      expect(features.rulesVersion, isNull);
      expect(features.rulesSeen, isTrue);
    });

    test('the clinic\'s rules as the server sends them', () {
      final features = MeData.fromJson(
        meJson(
          features: {
            'messages': false,
            'reply_days': 3,
            'photos': {'check_ins': true, 'messages': false},
            'rules': {'version': '2026-11', 'seen': false},
          },
        ),
      ).features;

      expect(features.messages, isFalse);
      expect(features.replyDays, 3);
      expect(features.photosWithCheckIns, isTrue);
      expect(features.photosWithMessages, isFalse);
      expect(features.rulesVersion, '2026-11');
      expect(features.rulesSeen, isFalse);
    });

    test('missing parts and odd types fall back to the defaults', () {
      final empty = Features.fromJson({});
      expect(empty.messages, isTrue);
      expect(empty.replyDays, isNull);
      expect(empty.photosWithCheckIns, isTrue);
      expect(empty.photosWithMessages, isTrue);
      expect(empty.rulesSeen, isTrue, reason: 'no rules, nothing to read');

      final odd = Features.fromJson({
        'messages': 'no',
        'reply_days': '2',
        'photos': 'all',
        'rules': {'version': 202611, 'seen': null},
      });
      expect(odd.messages, isTrue);
      expect(odd.replyDays, 2);
      expect(odd.photosWithCheckIns, isTrue);
      expect(odd.rulesVersion, '202611');
      expect(odd.rulesSeen, isTrue);

      expect(Features.fromJson({'reply_days': 0}).replyDays, isNull);
      expect(Features.fromJson({'messages': 0}).messages, isFalse);
      expect(
        MeData.fromJson(meJson()..['features'] = 'on').features,
        same(Features.legacy),
      );
    });
  });
}
