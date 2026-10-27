import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/api/api_client.dart';
import 'package:myshine/api/models.dart';
import 'package:myshine/config.dart';
import 'package:myshine/state/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

/// Answers `/messages` with the given error.
class _FailingMessagesApi extends FakeApiClient {
  _FailingMessagesApi(this.error);

  final ApiException error;

  @override
  Future<List<Message>> messages() async => throw error;
}

/// The keychain, in memory.
class _FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key] = value!;

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values.remove(key);
}

Future<Session> _connected(
  ApiClient api, {
  bool serverSettingEnabled = true,
  String? savedServer,
}) async {
  final session = Session(
    storage: MemorySessionStorage(token: 'test-token', baseUrl: savedServer),
    clientFactory: (_, _) => api,
    serverSettingEnabled: serverSettingEnabled,
  );
  await session.load();
  return session;
}

void main() {
  test('a 401 on any screen forgets the token', () async {
    final session = await _connected(
      _FailingMessagesApi(
        const ApiException('Please connect again.', statusCode: 401),
      ),
    );

    await expectLater(session.client.messages(), throwsA(isA<ApiException>()));

    expect(session.isConnected, isFalse);
    expect(await session.storage.readToken(), isNull);
  });

  test('other errors keep the patient connected', () async {
    final session = await _connected(
      _FailingMessagesApi(
        const ApiException('Something went wrong.', statusCode: 500),
      ),
    );

    await expectLater(session.client.messages(), throwsA(isA<ApiException>()));

    expect(session.isConnected, isTrue);
  });

  test('release builds ignore a saved server', () async {
    final release = await _connected(
      FakeApiClient(),
      serverSettingEnabled: false,
      savedServer: 'https://elsewhere.example.test',
    );
    final development = await _connected(
      FakeApiClient(),
      savedServer: 'https://elsewhere.example.test',
    );

    expect(release.baseUrl, AppConfig.defaultBaseUrl);
    expect(development.baseUrl, 'https://elsewhere.example.test');
  });

  test(
    'a token left in the keychain from before a reinstall is deleted',
    () async {
      SharedPreferences.setMockInitialValues({});
      final secure = _FakeSecureStorage()..values['myshine_token'] = 'old';
      final storage = DeviceSessionStorage(secure: secure);

      expect(await storage.readToken(), isNull);
      expect(secure.values, isEmpty);

      await storage.writeToken('new');
      expect(await storage.readToken(), 'new');
    },
  );
}
