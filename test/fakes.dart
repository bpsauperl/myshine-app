import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/screens/home/photo_camera_screen.dart';

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
  final List<List<PhotoUpload>> sentMessagePhotos = [];
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
      photos: draft.photos.length,
    );
  }

  @override
  Future<List<Message>> messages() async => const [];

  @override
  Future<Message> sendMessage(
    String body, {
    List<PhotoUpload> photos = const [],
  }) async {
    sentMessages.add(body);
    sentMessagePhotos.add(photos);
    return Message(
      id: sentMessages.length,
      author: MessageAuthor.patient,
      body: body,
      photos: [
        for (var i = 0; i < photos.length; i++)
          MessagePhoto(id: i + 1, url: 'https://example.test/photos/${i + 1}'),
      ],
    );
  }
}

/// A valid 1×1 PNG, so thumbnails decode in widget tests.
final Uint8List kTinyPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0xF8,
  0xCF,
  0xC0,
  0xF0,
  0x1F,
  0x00,
  0x05,
  0x00,
  0x01,
  0xFF,
  0x89,
  0x99,
  0x3D,
  0x1D,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

/// Stands in for the in-app camera: each call returns the next example photo
/// and remembers what was asked for.
class FakeCamera {
  final List<PhotoPrompt> prompts = [];

  Future<PhotoUpload?> take(BuildContext _, PhotoPrompt prompt) async {
    prompts.add(prompt);
    return PhotoUpload(
      bytes: kTinyPng,
      filename: 'photo-${prompts.length}.png',
    );
  }
}
