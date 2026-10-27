import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/http_api_client.dart';
import 'package:myshine/api/models.dart';

void main() {
  test('connect posts the code and keeps the token for later calls', () async {
    final requests = <http.Request>[];
    final client = HttpApiClient(
      baseUrl: 'https://example.test/',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/connect')) {
          return http.Response(
            jsonEncode({
              'token': 'abc',
              'patient': {'first_name': 'Ana'},
            }),
            200,
          );
        }
        return http.Response('', 204);
      }),
    );

    final result = await client.connect('ABCD-2345');
    await client.logout();

    expect(result.token, 'abc');
    expect(
      requests.first.url.toString(),
      'https://example.test/api/myshine/v1/connect',
    );
    expect(jsonDecode(requests.first.body)['code'], 'ABCD-2345');
    expect(requests.last.headers['Authorization'], 'Bearer abc');
  });

  test('a 422 carries the field message', () async {
    final client = HttpApiClient(
      baseUrl: 'https://example.test',
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'message': 'Invalid.',
            'errors': {
              'code': ['That code doesn\'t work.'],
            },
          }),
          422,
        ),
      ),
    );

    expect(
      () => client.connect('ABCD-2345'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 422)
            .having(
              (e) => e.messageFor('code'),
              'code message',
              'That code doesn\'t work.',
            ),
      ),
    );
  });

  test('a 401 is reported as unauthorized', () async {
    final client = HttpApiClient(
      baseUrl: 'https://example.test',
      token: 'old',
      httpClient: MockClient(
        (_) async => http.Response('{"message":"Unauthenticated."}', 401),
      ),
    );

    expect(
      () => client.me(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.isUnauthorized,
          'unauthorized',
          isTrue,
        ),
      ),
    );
  });

  group('sendCheckIn', () {
    late List<http.BaseRequest> requests;
    late HttpApiClient client;

    setUp(() {
      requests = [];
      client = HttpApiClient(
        baseUrl: 'https://example.test',
        token: 'abc',
        httpClient: _RecordingClient(requests, {
          'check_in': {'id': 5, 'fit': 'tight', 'photos': 2},
        }),
      );
    });

    test('sends JSON without photos', () async {
      final checkIn = await client.sendCheckIn(
        const CheckInDraft(fit: 'seated', wearHours: 22, notes: ' Fine. '),
      );

      final request = requests.single as http.Request;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/myshine/v1/check-ins');
      expect(request.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(request.body), {
        'fit': 'seated',
        'wear_hours': 22,
        'notes': 'Fine.',
      });
      expect(checkIn.photos, 2);
    });

    test('sends multipart with photos[]', () async {
      await client.sendCheckIn(
        CheckInDraft(
          fit: 'tight',
          wearHours: 20,
          comfort: 'mild',
          photos: [
            CheckInPhoto(
              bytes: Uint8List.fromList([1, 2, 3]),
              filename: 'a.jpg',
            ),
            CheckInPhoto(bytes: Uint8List.fromList([4, 5]), filename: 'b.png'),
          ],
        ),
      );

      final request = requests.single as http.MultipartRequest;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/myshine/v1/check-ins');
      expect(request.headers['Authorization'], 'Bearer abc');
      expect(request.headers['Accept'], 'application/json');
      expect(request.fields, {
        'fit': 'tight',
        'wear_hours': '20',
        'comfort': 'mild',
      });
      expect(request.files.map((f) => f.field), ['photos[]', 'photos[]']);
      expect(request.files.map((f) => f.filename), ['a.jpg', 'b.png']);
      expect(request.files.first.length, 3);
    });
  });

  test('a check-in without photos in the response counts 0', () {
    expect(CheckIn.fromJson({'id': 1, 'fit': 'seated'}).photos, 0);
  });
}

/// Keeps every request (MockClient only sees plain [http.Request]s) and
/// answers with [json].
class _RecordingClient extends http.BaseClient {
  _RecordingClient(this.requests, this.json);

  final List<http.BaseRequest> requests;
  final Map<String, dynamic> json;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request);
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(json))),
      201,
    );
  }
}
