import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'api_client.dart';
import 'models.dart';

/// [ApiClient] over HTTPS with a Bearer token.
class HttpApiClient implements ApiClient {
  HttpApiClient({
    required String baseUrl,
    this.token,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 20),
    this.uploadTimeout = const Duration(seconds: 90),
  }) : baseUrl = baseUrl.replaceAll(RegExp(r'/+$'), ''),
       _http = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _http;
  final Duration timeout;

  /// For requests carrying photos (up to 3 × 8 MB).
  final Duration uploadTimeout;

  /// The patient's token, set after connecting.
  String? token;

  Uri _uri(String path) => Uri.parse('$baseUrl${AppConfig.apiPrefix}$path');

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) {
    final request = http.Request(method, _uri(path))
      ..headers.addAll(_headers)
      ..headers['Content-Type'] = 'application/json; charset=utf-8';
    if (body != null) {
      request.body = jsonEncode(body);
    }
    return _dispatch(request, timeout);
  }

  /// A multipart POST: [fields] as form fields, [files] under their names.
  Future<Map<String, dynamic>> _sendMultipart(
    String path, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) {
    final request = http.MultipartRequest('POST', _uri(path))
      ..headers.addAll(_headers)
      ..fields.addAll(fields)
      ..files.addAll(files);
    return _dispatch(request, uploadTimeout);
  }

  Future<Map<String, dynamic>> _dispatch(
    http.BaseRequest request,
    Duration limit,
  ) async {
    http.Response response;
    try {
      response = await http.Response.fromStream(
        await _http.send(request).timeout(limit),
      );
    } on TimeoutException {
      throw const ApiException(
        'The connection is slow. Please try again in a moment.',
      );
    } catch (_) {
      throw const ApiException(
        'We couldn\'t reach myShine. Check your internet connection.',
      );
    }

    Map<String, dynamic> json = const {};
    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map) {
          json = Map<String, dynamic>.from(decoded);
        }
      } on FormatException {
        json = const {};
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }
    throw _error(response.statusCode, json);
  }

  ApiException _error(int status, Map<String, dynamic> json) {
    final errors = <String, List<String>>{};
    final raw = json['errors'];
    if (raw is Map) {
      raw.forEach((key, value) {
        errors[key.toString()] = value is List
            ? value.map((e) => e.toString()).toList()
            : [value.toString()];
      });
    }
    final serverMessage = json['message'] is String
        ? json['message'] as String
        : null;
    final message = switch (status) {
      401 => 'Please connect with your clinic again.',
      403 => 'This isn\'t available for your account.',
      429 => 'Too many tries. Please wait a few minutes and try again.',
      >= 500 => 'Something went wrong on our side. Please try again later.',
      _ => serverMessage ?? 'Something went wrong. Please try again.',
    };
    return ApiException(message, statusCode: status, errors: errors);
  }

  @override
  Future<ConnectResult> connect(
    String code, {
    String device = 'myShine',
  }) async {
    final json = await _send(
      'POST',
      '/connect',
      body: {'code': code, 'device': device},
    );
    final newToken = json['token'];
    if (newToken is! String || newToken.isEmpty) {
      throw const ApiException('Something went wrong. Please try again.');
    }
    token = newToken;
    return ConnectResult(
      token: newToken,
      patient: Patient.fromJson(
        json['patient'] is Map
            ? Map<String, dynamic>.from(json['patient'] as Map)
            : {},
      ),
    );
  }

  @override
  Future<void> logout() async {
    await _send('POST', '/logout');
  }

  @override
  Future<MeData> me() async => MeData.fromJson(await _send('GET', '/me'));

  @override
  Future<CheckIn> sendCheckIn(CheckInDraft draft) async {
    final json = draft.photos.isEmpty
        ? await _send('POST', '/check-ins', body: draft.toJson())
        : await _sendMultipart(
            '/check-ins',
            fields: draft.toJson().map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            files: [
              for (final photo in draft.photos)
                http.MultipartFile.fromBytes(
                  'photos[]',
                  photo.bytes,
                  filename: photo.filename,
                ),
            ],
          );
    return CheckIn.fromJson(
      json['check_in'] is Map
          ? Map<String, dynamic>.from(json['check_in'] as Map)
          : {},
    );
  }

  @override
  Future<List<Message>> messages() async {
    final json = await _send('GET', '/messages');
    final data = json['data'];
    if (data is! List) {
      return const [];
    }
    return data
        .whereType<Map>()
        .map((e) => Message.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Message> sendMessage(String body) async {
    final json = await _send('POST', '/messages', body: {'body': body});
    return Message.fromJson(
      json['message'] is Map
          ? Map<String, dynamic>.from(json['message'] as Map)
          : {},
    );
  }
}
