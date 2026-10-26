import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/models.dart';

/// Example data only: a made-up patient and clinic.
Map<String, dynamic> meJson({
  bool withTherapy = true,
  bool planShared = false,
}) => {
  'patient': {
    'first_name': 'Ana',
    'clinic': {
      'name': 'Example Dental Studio',
      'phone': '+386 1 000 0000',
      'email': 'hello@example.test',
      'city': 'Ljubljana',
    },
    'doctor': {'name': 'Dr. Example'},
    'status': 'in_treatment',
    'status_label': 'In treatment',
  },
  'plan': {
    'shared': planShared,
    'url': planShared ? 'https://example.test/plan' : null,
    'series': 1,
  },
  'therapy': withTherapy
      ? {
          'started': '2026-10-01',
          'series': 1,
          'total': 22,
          'current': {
            'aligner': 4,
            'from': '2026-10-22',
            'to': '2026-10-28',
            'days': 7,
            'day': 3,
          },
          'next_change': '2026-10-29',
          'ends_on': '2027-03-03',
          'rows': [
            {
              'aligner': 3,
              'from': '2026-10-15',
              'to': '2026-10-21',
              'days': 7,
              'state': 'done',
            },
            {
              'aligner': 4,
              'from': '2026-10-22',
              'to': '2026-10-28',
              'days': 7,
              'state': 'now',
            },
            {
              'aligner': 5,
              'from': '2026-10-29',
              'to': '2026-11-04',
              'days': 7,
              'state': 'next',
            },
          ],
        }
      : null,
  'check_ins': [
    {
      'id': 7,
      'aligner': 3,
      'fit': 'seated',
      'fit_label': 'Fits well',
      'wear_hours': 22,
      'comfort': 'none',
      'outcome': 'continue',
      'outcome_label': 'Continue as planned',
      'source': 'app',
      'at': '2026-10-20T09:30:00+02:00',
    },
  ],
  'consents': [
    {
      'id': 1,
      'status': 'signed',
      'devices': 'Shine aligners',
      'signed_at': '2026-09-30T10:00:00+02:00',
      'sign_url': null,
    },
    {
      'id': 2,
      'status': 'pending',
      'devices': 'Retainers',
      'signed_at': null,
      'sign_url': 'https://example.test/sign',
    },
  ],
  'unread_messages': 2,
};

class FakeApiClient implements ApiClient {
  FakeApiClient({Map<String, dynamic>? me, this.meError, this.checkInError})
    : _me = me ?? meJson();

  final Map<String, dynamic> _me;
  final ApiException? meError;
  final ApiException? checkInError;

  final List<CheckInDraft> sentCheckIns = [];
  final List<String> sentMessages = [];
  int meCalls = 0;
  bool loggedOut = false;

  @override
  Future<ConnectResult> connect(
    String code, {
    String device = 'myShine',
  }) async {
    if (code != 'ABCD-2345') {
      throw const ApiException(
        'The given data was invalid.',
        statusCode: 422,
        errors: {
          'code': ['That code doesn\'t work. Ask your clinic for a new one.'],
        },
      );
    }
    return ConnectResult(
      token: 'test-token',
      patient: MeData.fromJson(_me).patient,
    );
  }

  @override
  Future<void> logout() async => loggedOut = true;

  @override
  Future<MeData> me() async {
    meCalls++;
    if (meError != null) {
      throw meError!;
    }
    return MeData.fromJson(_me);
  }

  @override
  Future<CheckIn> sendCheckIn(CheckInDraft draft) async {
    if (checkInError != null) {
      throw checkInError!;
    }
    sentCheckIns.add(draft);
    return CheckIn(
      id: 99,
      aligner: 4,
      fit: draft.fit,
      wearHours: draft.wearHours,
      comfort: draft.comfort,
    );
  }

  @override
  Future<List<Message>> messages() async => const [];

  @override
  Future<Message> sendMessage(String body) async {
    sentMessages.add(body);
    return Message(id: 1, author: MessageAuthor.patient, body: body);
  }
}
