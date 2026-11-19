import 'package:flutter/foundation.dart';

/// App-wide constants.
class AppConfig {
  AppConfig._();

  static const String _namedServer = String.fromEnvironment('MYSHINE_SERVER');

  /// The drShine server the app talks to. A build can name one with
  /// `--dart-define=MYSHINE_SERVER=https://…`. Without that, the web app
  /// talks to the address it is served from (myShine on the web is served by
  /// drShine itself, so there is nothing to configure and no CORS), and the
  /// phone apps to myShine's own address (drShine production). In development builds the hidden
  /// "Server" setting (long-press the logo on the welcome screen) can also
  /// change it.
  static String get defaultBaseUrl {
    if (_namedServer.isNotEmpty) {
      return _namedServer;
    }
    return kIsWeb ? Uri.base.origin : 'https://myshine.smilelabs.app';
  }

  /// Whether the hidden "Server" setting exists. Release builds always use
  /// [defaultBaseUrl], so a patient can't point the app anywhere else.
  static const bool serverSettingEnabled = !kReleaseMode;

  /// The version shown in About; keep it the same as `version` in pubspec.yaml.
  static const String version = '1.0.0';

  /// The Help and Privacy pages, served by drShine next to the app, in the
  /// patient's language.
  static Uri pageUrl(String page, String language) =>
      Uri.parse('$defaultBaseUrl/$page')
          .replace(queryParameters: {'lang': language});

  /// The path prefix of the myShine API (contract v1, section B).
  static const String apiPrefix = '/api/myshine/v1';

  /// How often the Messages tab looks for new messages while it is open.
  static const Duration messagesPollInterval = Duration(seconds: 30);

  /// The daily wear goal shown on Today.
  static const int wearHoursGoal = 22;
}
