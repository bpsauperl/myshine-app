// A preview of the connected app with made-up example data and no server.
// Build: flutter build web -t tool/preview_main.dart -o build/web-preview
import 'package:flutter/material.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/app.dart';
import 'package:myshine/state/session.dart';

String _day(int offset) {
  final d = DateTime.now().add(Duration(days: offset));
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

Map<String, dynamic> _me() => {
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
  'plan': {'shared': true, 'url': 'https://example.test/plan', 'series': 1},
  'therapy': {
    'started': _day(-23),
    'series': 1,
    'total': 22,
    'current': {
      'aligner': 4,
      'from': _day(-2),
      'to': _day(4),
      'days': 7,
      'day': 3,
    },
    'next_change': _day(5),
    'ends_on': _day(-23 + 22 * 7 - 1),
    'rows': [
      for (var i = 1; i <= 22; i++)
        {
          'aligner': i,
          'from': _day(-23 + (i - 1) * 7),
          'to': _day(-23 + i * 7 - 1),
          'days': 7,
          'state': i < 4 ? 'done' : (i == 4 ? 'now' : 'next'),
        },
    ],
  },
  'check_ins': [],
  'consents': [
    {
      'id': 1,
      'status': 'signed',
      'devices': 'Shine aligners',
      'signed_at': '${_day(-25)}T10:00:00+02:00',
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
  'unread_messages': 1,
};

class _PreviewApi implements ApiClient {
  final List<Message> _messages = [
    Message(
      id: 1,
      author: MessageAuthor.clinic,
      name: 'Example Dental Studio',
      body: 'Hello Ana, how are the new aligners?',
      at: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Message(
      id: 2,
      author: MessageAuthor.patient,
      body: 'A little tight on the first day, fine now.',
      at: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  @override
  Future<ConnectResult> connect(
    String code, {
    String device = 'myShine',
  }) async =>
      ConnectResult(token: 'preview', patient: MeData.fromJson(_me()).patient);

  @override
  Future<void> logout() async {}

  @override
  Future<MeData> me() async => MeData.fromJson(_me());

  @override
  Future<CheckIn> sendCheckIn(CheckInDraft draft) async =>
      CheckIn(id: 1, aligner: 4, fit: draft.fit);

  @override
  Future<List<Message>> messages() async => List.of(_messages);

  @override
  Future<Message> sendMessage(String body) async {
    final message = Message(
      id: _messages.length + 1,
      author: MessageAuthor.patient,
      body: body,
      at: DateTime.now(),
    );
    _messages.add(message);
    return message;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = _PreviewApi();
  final session = Session(
    storage: MemorySessionStorage(
      token: Uri.base.queryParameters.containsKey('welcome') ? null : 'preview',
    ),
    clientFactory: (_, _) => api,
  );
  await session.load();
  runApp(MyShineApp(session: session));
}
