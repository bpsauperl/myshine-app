import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/http_api_client.dart';
import '../api/models.dart';
import '../config.dart';

/// Where the token and the server address are kept.
abstract class SessionStorage {
  Future<String?> readToken();
  Future<void> writeToken(String token);
  Future<void> clearToken();
  Future<String?> readBaseUrl();
  Future<void> writeBaseUrl(String? url);
}

/// The token in the platform keychain; the server address in preferences.
///
/// The iOS keychain outlives the app, preferences don't: a token without the
/// preferences' install mark is left over from before a reinstall and is
/// deleted, so a reinstalled app starts at the welcome screen.
class DeviceSessionStorage implements SessionStorage {
  DeviceSessionStorage({FlutterSecureStorage? secure})
    : _secure = secure ?? const FlutterSecureStorage();

  static const _tokenKey = 'myshine_token';
  static const _baseUrlKey = 'myshine_base_url';
  static const _installedKey = 'myshine_installed';

  final FlutterSecureStorage _secure;

  @override
  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_installedKey) != true) {
      await _secure.delete(key: _tokenKey);
      await prefs.setBool(_installedKey, true);
      return null;
    }
    return _secure.read(key: _tokenKey);
  }

  @override
  Future<void> writeToken(String token) async {
    await (await SharedPreferences.getInstance()).setBool(_installedKey, true);
    await _secure.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clearToken() => _secure.delete(key: _tokenKey);

  @override
  Future<String?> readBaseUrl() async =>
      (await SharedPreferences.getInstance()).getString(_baseUrlKey);

  @override
  Future<void> writeBaseUrl(String? url) async {
    final prefs = await SharedPreferences.getInstance();
    if (url == null) {
      await prefs.remove(_baseUrlKey);
    } else {
      await prefs.setString(_baseUrlKey, url);
    }
  }
}

/// Keeps everything in memory (tests).
class MemorySessionStorage implements SessionStorage {
  MemorySessionStorage({this.token, this.baseUrl});

  String? token;
  String? baseUrl;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String value) async => token = value;

  @override
  Future<void> clearToken() async => token = null;

  @override
  Future<String?> readBaseUrl() async => baseUrl;

  @override
  Future<void> writeBaseUrl(String? url) async => baseUrl = url;
}

typedef ApiClientFactory = ApiClient Function(String baseUrl, String? token);

ApiClient defaultApiClientFactory(String baseUrl, String? token) =>
    HttpApiClient(baseUrl: baseUrl, token: token);

/// Whether the patient is connected with their clinic, and the API client to use.
class Session extends ChangeNotifier {
  Session({
    required this.storage,
    this.clientFactory = defaultApiClientFactory,
    this.serverSettingEnabled = AppConfig.serverSettingEnabled,
  });

  final SessionStorage storage;
  final ApiClientFactory clientFactory;

  /// Whether a server saved with [setBaseUrl] is used (development builds).
  final bool serverSettingEnabled;

  bool _ready = false;
  String _baseUrl = AppConfig.defaultBaseUrl;
  String? _token;
  ApiClient? _client;

  bool get isReady => _ready;
  bool get isConnected => _token != null;
  String get baseUrl => _baseUrl;

  /// The signed-in client. Only use while [isConnected]. Whichever screen
  /// gets a 401 from it, the session forgets the token and the app goes back
  /// to the welcome screen.
  ApiClient get client => _client ??= _SignedInClient(
    clientFactory(_baseUrl, _token),
    onUnauthorized: handleUnauthorized,
  );

  Future<void> load() async {
    try {
      if (serverSettingEnabled) {
        _baseUrl = (await storage.readBaseUrl()) ?? AppConfig.defaultBaseUrl;
      }
      _token = await storage.readToken();
    } catch (_) {
      _token = null;
    }
    _client = null;
    _ready = true;
    notifyListeners();
  }

  /// Connects with the clinic's code. Throws [ApiException].
  Future<void> connect(String code) async {
    final anonymous = clientFactory(_baseUrl, null);
    final result = await anonymous.connect(code, device: _deviceName());
    await storage.writeToken(result.token);
    _token = result.token;
    _client = null;
    notifyListeners();
  }

  /// Signs out on the server (if it can be reached) and forgets the token.
  Future<void> disconnect() async {
    if (_token != null) {
      try {
        await client.logout();
      } catch (_) {
        // The token is forgotten here either way.
      }
    }
    await _forget();
  }

  /// The server said the token is no longer valid.
  Future<void> handleUnauthorized() async {
    if (_token != null) {
      await _forget();
    }
  }

  Future<void> _forget() async {
    await storage.clearToken();
    _token = null;
    _client = null;
    notifyListeners();
  }

  /// Changes the server (hidden setting). Null or empty goes back to the default.
  Future<void> setBaseUrl(String? url) async {
    final cleaned = url?.trim().replaceAll(RegExp(r'/+$'), '');
    final value = cleaned == null || cleaned.isEmpty ? null : cleaned;
    await storage.writeBaseUrl(value);
    _baseUrl = value ?? AppConfig.defaultBaseUrl;
    _client = null;
    notifyListeners();
  }

  static String _deviceName() {
    if (kIsWeb) {
      return 'myShine web';
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 'myShine iOS',
      TargetPlatform.android => 'myShine Android',
      _ => 'myShine',
    };
  }
}

/// Passes every call through and tells the session about a 401.
class _SignedInClient implements ApiClient {
  _SignedInClient(this._inner, {required this.onUnauthorized});

  final ApiClient _inner;
  final Future<void> Function() onUnauthorized;

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await onUnauthorized();
      }
      rethrow;
    }
  }

  @override
  Future<ConnectResult> connect(String code, {String device = 'myShine'}) =>
      _inner.connect(code, device: device);

  @override
  Future<void> logout() => _inner.logout();

  @override
  Future<MeData> me() => _guard(_inner.me);

  @override
  Future<CheckIn> sendCheckIn(CheckInDraft draft) =>
      _guard(() => _inner.sendCheckIn(draft));

  @override
  Future<List<Message>> messages() => _guard(_inner.messages);

  @override
  Future<Message> sendMessage(
    String body, {
    List<PhotoUpload> photos = const [],
  }) => _guard(() => _inner.sendMessage(body, photos: photos));
}

/// Makes the [Session] available below it.
class SessionScope extends InheritedNotifier<Session> {
  const SessionScope({
    super.key,
    required Session session,
    required super.child,
  }) : super(notifier: session);

  static Session of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SessionScope>()!.notifier!;
}
