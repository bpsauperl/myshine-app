const List<String> _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String weekdayName(DateTime date) => _weekdays[date.weekday - 1];

/// `26 Oct` (or `26 Oct 2027` when it isn't this year).
String shortDate(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final base = '${date.day} ${_months[date.month - 1]}';
  return date.year == today.year ? base : '$base ${date.year}';
}

/// `26 Oct 2026`.
String longDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';

/// "today", "tomorrow", "on Thursday" (within a week) or "on 4 Nov".
String relativeDay(DateTime date, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  final days = dateOnly(date).difference(today).inDays;
  if (days == 0) {
    return 'today';
  }
  if (days == 1) {
    return 'tomorrow';
  }
  if (days > 1 && days < 7) {
    return 'on ${weekdayName(date)}';
  }
  return 'on ${shortDate(date, now: today)}';
}

/// `09:30`.
String clockTime(DateTime moment) =>
    '${moment.hour.toString().padLeft(2, '0')}:${moment.minute.toString().padLeft(2, '0')}';
