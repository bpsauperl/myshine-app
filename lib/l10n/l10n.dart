import 'package:flutter/widgets.dart';

import '../api/api_client.dart';
import '../api/models.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Serbian is always written in Latin script in myShine.
const Locale serbianLatin = Locale.fromSubtags(
  languageCode: 'sr',
  scriptCode: 'Latn',
);

/// The phone's languages resolved against the app's: English when none match,
/// and Serbian always in Latin script (so Material's own words are Latin too).
Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  final languages = {for (final locale in supported) locale.languageCode};
  final speaksOne =
      preferred?.any((locale) => languages.contains(locale.languageCode)) ??
      false;
  if (!speaksOne) {
    return const Locale('en');
  }
  final resolved = basicLocaleListResolution(preferred, supported);
  return resolved.languageCode == 'sr' ? serbianLatin : resolved;
}

extension AppLocalizationsContext on BuildContext {
  /// The app's words in the current language.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsText on AppLocalizations {
  /// What went wrong with an API call, in the patient's language. Messages the
  /// server wrote itself (validation and the like) are shown as they came.
  String apiError(ApiException error) => switch (error.failure) {
    ApiFailure.slow => apiErrorSlow,
    ApiFailure.offline => apiErrorOffline,
    ApiFailure.unauthorized => apiErrorUnauthorized,
    ApiFailure.forbidden => apiErrorForbidden,
    ApiFailure.tooManyTries => apiErrorTooManyTries,
    ApiFailure.server => apiErrorServer,
    ApiFailure.unknown => apiErrorUnknown,
    null => error.message,
  };

  String intraoralLabel(IntraoralView view) => switch (view) {
    IntraoralView.front => intraoralFront,
    IntraoralView.right => intraoralRight,
    IntraoralView.left => intraoralLeft,
    IntraoralView.upper => intraoralUpper,
    IntraoralView.lower => intraoralLower,
  };

  String intraoralHint(IntraoralView view) => switch (view) {
    IntraoralView.front => intraoralFrontHint,
    IntraoralView.right => intraoralRightHint,
    IntraoralView.left => intraoralLeftHint,
    IntraoralView.upper => intraoralUpperHint,
    IntraoralView.lower => intraoralLowerHint,
  };
}
