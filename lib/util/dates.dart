import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

const List<String> _weekdayKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

/// The intl locale for dates in [l10n]'s language: English dates read
/// `26 Oct` (as in Europe), Serbian ones are in Latin script.
///
/// The date symbols are loaded by `GlobalMaterialLocalizations`, so dates are
/// formatted inside a `MaterialApp` with its delegates.
String dateLocale(AppLocalizations l10n) => switch (l10n.localeName) {
  'en' => 'en_GB',
  'sr' => 'sr_Latn',
  final name => name,
};

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// `Thursday` (`četrtek`, `Donnerstag`).
String weekdayName(AppLocalizations l10n, DateTime date) =>
    DateFormat.EEEE(dateLocale(l10n)).format(date);

/// `Saturday 24 October` (`sobota, 24. oktober`): the date at the top of Today.
String headerDate(AppLocalizations l10n, DateTime date) =>
    DateFormat.MMMMEEEEd(dateLocale(l10n)).format(date);

/// `26 Oct` (or `26 Oct 2027` when it isn't this year); `26. okt.` in Slovenian.
String shortDate(AppLocalizations l10n, DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final locale = dateLocale(l10n);
  return date.year == today.year
      ? DateFormat.MMMd(locale).format(date)
      : DateFormat.yMMMd(locale).format(date);
}

/// `26 Oct 2026`.
String longDate(AppLocalizations l10n, DateTime date) =>
    DateFormat.yMMMd(dateLocale(l10n)).format(date);

/// "today", "tomorrow", "Thursday" (within a week) or "4 Nov", on its own
/// (e.g. under "Next aligner").
String dayName(AppLocalizations l10n, DateTime date, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  final days = dateOnly(date).difference(today).inDays;
  if (days == 0) {
    return l10n.dateToday;
  }
  if (days == 1) {
    return l10n.dateTomorrow;
  }
  if (days > 1 && days < 7) {
    return weekdayName(l10n, date);
  }
  return shortDate(l10n, date, now: today);
}

/// "today", "tomorrow", "on Thursday" (within a week) or "on 4 Nov", to go
/// inside a sentence ("Due on Thursday.").
String relativeDay(AppLocalizations l10n, DateTime date, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  final days = dateOnly(date).difference(today).inDays;
  if (days == 0) {
    return l10n.dateToday;
  }
  if (days == 1) {
    return l10n.dateTomorrow;
  }
  if (days > 1 && days < 7) {
    return l10n.dateOnWeekday(_weekdayKeys[date.weekday - 1]);
  }
  return l10n.dateOnDate(shortDate(l10n, date, now: today));
}

/// `09:30`.
String clockTime(DateTime moment) =>
    '${moment.hour.toString().padLeft(2, '0')}:${moment.minute.toString().padLeft(2, '0')}';
