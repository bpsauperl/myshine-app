import 'models.dart';

/// The most photos one message may carry.
const int maxMessagePhotos = 3;

/// The myShine API (contract v1, section B). The app only talks to the server
/// through this interface, so tests can pass a fake.
abstract class ApiClient {
  /// Swaps a clinic's connect code for a token. Throws [ApiException] (422 for
  /// an unknown or expired code, 429 after too many tries).
  Future<ConnectResult> connect(String code, {String device = 'myShine'});

  Future<void> logout();

  Future<MeData> me();

  Future<CheckIn> sendCheckIn(CheckInDraft draft);

  Future<List<Message>> messages();

  /// [body] may be empty when [photos] are attached (up to
  /// [maxMessagePhotos]).
  Future<Message> sendMessage(
    String body, {
    List<PhotoUpload> photos = const [],
  });

  /// Records that the patient read the clinic's short rules
  /// ([Features.rulesSeen]).
  Future<void> acceptRules();
}

/// Why a call failed, when the app (not the server) words it: the screens
/// show it in the patient's language.
enum ApiFailure {
  slow,
  offline,
  unauthorized,
  forbidden,
  tooManyTries,
  server,
  unknown,
}

/// A failed call: [statusCode] is null when the server couldn't be reached.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.errors = const {},
    this.failure,
  });

  /// In English, for logs; screens show [failure] in the patient's language,
  /// or this message when the server wrote it ([failure] is null).
  final String message;
  final ApiFailure? failure;
  final int? statusCode;
  final Map<String, List<String>> errors;

  /// The token is invalid or expired: the app goes back to the welcome screen.
  bool get isUnauthorized => statusCode == 401;

  /// The first validation message for [field], else [message].
  String messageFor(String field) {
    final list = errors[field];
    return list != null && list.isNotEmpty ? list.first : message;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
