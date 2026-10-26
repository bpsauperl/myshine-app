import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/http_api_client.dart';

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
}
