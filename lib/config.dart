import 'package:flutter/foundation.dart';

/// App-wide constants.
class AppConfig {
  AppConfig._();

  /// The drShine server the app talks to. A build can name another with
  /// `--dart-define=MYSHINE_SERVER=https://…`; in development builds the
  /// hidden "Server" setting (long-press the logo on the welcome screen) can
  /// also change it.
  static const String defaultBaseUrl = String.fromEnvironment(
    'MYSHINE_SERVER',
    defaultValue: 'https://drshine-production-8tmpnh.laravel.cloud',
  );

  /// Whether the hidden "Server" setting exists. Release builds always use
  /// [defaultBaseUrl], so a patient can't point the app anywhere else.
  static const bool serverSettingEnabled = !kReleaseMode;

  /// Where "Find a Shine clinic" goes. A placeholder until there is a clinic finder.
  static const String clinicFinderUrl = 'https://shine.smilelabs.si';

  /// The path prefix of the myShine API (contract v1, section B).
  static const String apiPrefix = '/api/myshine/v1';

  /// How often the Messages tab looks for new messages while it is open.
  static const Duration messagesPollInterval = Duration(seconds: 30);

  /// The daily wear goal shown on Today.
  static const int wearHoursGoal = 22;
}
