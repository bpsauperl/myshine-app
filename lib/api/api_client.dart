import 'models.dart';

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

  Future<Message> sendMessage(String body);
}

/// A failed call: [statusCode] is null when the server couldn't be reached.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.errors = const {}});

  final String message;
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
