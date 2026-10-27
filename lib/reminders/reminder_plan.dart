import '../api/models.dart';
import '../l10n/app_localizations.dart';
import '../util/dates.dart';

/// One reminder the phone shows at [at] (local time).
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
  });

  final int id;
  final DateTime at;
  final String title;
  final String body;

  @override
  String toString() => 'PlannedReminder($id, $at, $title)';
}

/// The words of the reminders, in the app's language.
abstract class ReminderTexts {
  String changeTitle(int aligner);
  String changeBody(int aligner);
  String checkInBody(int aligner);
  String lateTitle(int aligner);
  String lateBody(int aligner);
}

/// Reminders go out in the morning of the change day and, when the patient
/// checks in and hasn't yet, in the evening two days later.
const int reminderMorningHour = 9;
const int reminderEveningHour = 19;
const int lateReminderAfterDays = 2;

const int changeReminderId = 1;
const int lateReminderId = 2;

/// What to remind the patient of, from `/me`'s therapy. Only reminders still
/// ahead of [now] are returned; an empty list cancels them all.
List<PlannedReminder> planReminders(
  Therapy? therapy,
  ReminderTexts texts, {
  required DateTime now,
}) {
  if (therapy == null) {
    return const [];
  }
  final checkIn = therapy.checkIn;
  final DateTime? day;
  final int? aligner;
  if (checkIn.enabled) {
    day = checkIn.dueOn;
    aligner = checkIn.nextAligner;
  } else {
    final current = therapy.current?.aligner;
    day = therapy.nextChange;
    aligner = current == null || current >= therapy.total ? null : current + 1;
  }
  if (day == null || aligner == null) {
    return const [];
  }

  final change = _at(day, reminderMorningHour);
  final late = _at(
    dateOnly(day).add(const Duration(days: lateReminderAfterDays)),
    reminderEveningHour,
  );
  return [
    if (change.isAfter(now))
      PlannedReminder(
        id: changeReminderId,
        at: change,
        title: texts.changeTitle(aligner),
        body: checkIn.enabled
            ? texts.checkInBody(aligner)
            : texts.changeBody(aligner),
      ),
    if (checkIn.enabled && late.isAfter(now))
      PlannedReminder(
        id: lateReminderId,
        at: late,
        title: texts.lateTitle(aligner),
        body: texts.lateBody(aligner),
      ),
  ];
}

DateTime _at(DateTime day, int hour) =>
    DateTime(day.year, day.month, day.day, hour);

/// The reminders in the app's language.
class LocalizedReminderTexts implements ReminderTexts {
  const LocalizedReminderTexts(this.l10n);

  final AppLocalizations l10n;

  @override
  String changeTitle(int aligner) => l10n.reminderChangeTitle(aligner);

  @override
  String changeBody(int aligner) => l10n.reminderChangeBody(aligner);

  @override
  String checkInBody(int aligner) => l10n.reminderCheckInBody(aligner);

  @override
  String lateTitle(int aligner) => l10n.reminderLateTitle(aligner);

  @override
  String lateBody(int aligner) => l10n.reminderLateBody;
}

/// English reminders without a `BuildContext` (tests).
class EnglishReminderTexts implements ReminderTexts {
  const EnglishReminderTexts();

  @override
  String changeTitle(int aligner) => 'Time for aligner $aligner';

  @override
  String changeBody(int aligner) => 'Put in aligner $aligner today.';

  @override
  String checkInBody(int aligner) =>
      'Put in aligner $aligner today, then check in in myShine.';

  @override
  String lateTitle(int aligner) => 'Did you switch to aligner $aligner?';

  @override
  String lateBody(int aligner) =>
      'Check in when you have, so your schedule stays right.';
}
