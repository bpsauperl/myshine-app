/// Data the myShine API sends (contract v1, section B). Parsing is lenient:
/// a missing or oddly typed field becomes null or empty rather than a crash.
library;

String? _string(Object? value) => value?.toString();

int? _int(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<Map<String, dynamic>> _list(Object? value) => value is List
    ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : const [];

/// A calendar date (`2026-10-26`) as a local midnight DateTime.
DateTime? parseDate(Object? value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return null;
  }
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// A moment (`2026-10-26T09:30:00+01:00`) in local time.
DateTime? parseMoment(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

class Clinic {
  const Clinic({required this.name, this.phone, this.email, this.city});

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    name: _string(json['name']) ?? 'Your clinic',
    phone: _string(json['phone']),
    email: _string(json['email']),
    city: _string(json['city']),
  );

  final String name;
  final String? phone;
  final String? email;
  final String? city;
}

class Patient {
  const Patient({
    required this.firstName,
    required this.clinic,
    this.doctorName,
    this.status,
    this.statusLabel,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    firstName: _string(json['first_name']) ?? '',
    clinic: Clinic.fromJson(_map(json['clinic'])),
    doctorName: _string(_map(json['doctor'])['name']),
    status: _string(json['status']),
    statusLabel: _string(json['status_label']),
  );

  final String firstName;
  final Clinic clinic;
  final String? doctorName;
  final String? status;
  final String? statusLabel;
}

class PlanLink {
  const PlanLink({required this.shared, this.url, this.series});

  factory PlanLink.fromJson(Map<String, dynamic> json) {
    final url = _string(json['url']);
    return PlanLink(
      shared: json['shared'] == true && url != null && url.isNotEmpty,
      url: url,
      series: _int(json['series']),
    );
  }

  final bool shared;
  final String? url;
  final int? series;
}

class CurrentAligner {
  const CurrentAligner({
    required this.aligner,
    required this.from,
    required this.to,
    required this.days,
    required this.day,
  });

  factory CurrentAligner.fromJson(Map<String, dynamic> json) => CurrentAligner(
    aligner: _int(json['aligner']) ?? 0,
    from: parseDate(json['from']),
    to: parseDate(json['to']),
    days: _int(json['days']) ?? 0,
    day: _int(json['day']) ?? 0,
  );

  final int aligner;
  final DateTime? from;
  final DateTime? to;
  final int days;
  final int day;
}

enum AlignerState { done, now, next }

class ScheduleRow {
  const ScheduleRow({
    required this.aligner,
    required this.from,
    required this.to,
    required this.days,
    required this.state,
  });

  factory ScheduleRow.fromJson(Map<String, dynamic> json) => ScheduleRow(
    aligner: _int(json['aligner']) ?? 0,
    from: parseDate(json['from']),
    to: parseDate(json['to']),
    days: _int(json['days']) ?? 0,
    state: switch (json['state']) {
      'done' => AlignerState.done,
      'now' => AlignerState.now,
      _ => AlignerState.next,
    },
  );

  final int aligner;
  final DateTime? from;
  final DateTime? to;
  final int days;
  final AlignerState state;
}

class Therapy {
  const Therapy({
    this.started,
    this.series,
    required this.total,
    this.current,
    this.nextChange,
    this.endsOn,
    required this.rows,
  });

  factory Therapy.fromJson(Map<String, dynamic> json) {
    final rows = _list(json['rows']).map(ScheduleRow.fromJson).toList();
    return Therapy(
      started: parseDate(json['started']),
      series: _int(json['series']),
      total: _int(json['total']) ?? rows.length,
      current: json['current'] is Map
          ? CurrentAligner.fromJson(_map(json['current']))
          : null,
      nextChange: parseDate(json['next_change']),
      endsOn: parseDate(json['ends_on']),
      rows: rows,
    );
  }

  final DateTime? started;
  final int? series;
  final int total;
  final CurrentAligner? current;
  final DateTime? nextChange;
  final DateTime? endsOn;
  final List<ScheduleRow> rows;
}

class CheckIn {
  const CheckIn({
    required this.id,
    this.aligner,
    required this.fit,
    this.fitLabel,
    this.wearHours,
    this.comfort,
    this.outcome,
    this.outcomeLabel,
    this.source,
    this.at,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) => CheckIn(
    id: _int(json['id']) ?? 0,
    aligner: _int(json['aligner']),
    fit: _string(json['fit']) ?? '',
    fitLabel: _string(json['fit_label']),
    wearHours: _int(json['wear_hours']),
    comfort: _string(json['comfort']),
    outcome: _string(json['outcome']),
    outcomeLabel: _string(json['outcome_label']),
    source: _string(json['source']),
    at: parseMoment(json['at']),
  );

  final int id;
  final int? aligner;
  final String fit;
  final String? fitLabel;
  final int? wearHours;
  final String? comfort;
  final String? outcome;
  final String? outcomeLabel;
  final String? source;
  final DateTime? at;
}

class Consent {
  const Consent({
    required this.id,
    required this.status,
    this.devices,
    this.signedAt,
    this.signUrl,
  });

  factory Consent.fromJson(Map<String, dynamic> json) => Consent(
    id: _int(json['id']) ?? 0,
    status: _string(json['status']) ?? 'pending',
    devices: _string(json['devices']),
    signedAt: parseMoment(json['signed_at']),
    signUrl: _string(json['sign_url']),
  );

  final int id;
  final String status;
  final String? devices;
  final DateTime? signedAt;
  final String? signUrl;

  bool get isSigned => status == 'signed';
}

/// Everything `GET /me` returns.
class MeData {
  const MeData({
    required this.patient,
    required this.plan,
    this.therapy,
    required this.checkIns,
    required this.consents,
    required this.unreadMessages,
  });

  factory MeData.fromJson(Map<String, dynamic> json) => MeData(
    patient: Patient.fromJson(_map(json['patient'])),
    plan: PlanLink.fromJson(_map(json['plan'])),
    therapy: json['therapy'] is Map
        ? Therapy.fromJson(_map(json['therapy']))
        : null,
    checkIns: _list(json['check_ins']).map(CheckIn.fromJson).toList(),
    consents: _list(json['consents']).map(Consent.fromJson).toList(),
    unreadMessages: _int(json['unread_messages']) ?? 0,
  );

  final Patient patient;
  final PlanLink plan;
  final Therapy? therapy;
  final List<CheckIn> checkIns;
  final List<Consent> consents;
  final int unreadMessages;
}

enum MessageAuthor { clinic, patient }

class Message {
  const Message({
    required this.id,
    required this.author,
    this.name,
    required this.body,
    this.at,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: _int(json['id']) ?? 0,
    author: json['author'] == 'patient'
        ? MessageAuthor.patient
        : MessageAuthor.clinic,
    name: _string(json['name']),
    body: _string(json['body']) ?? '',
    at: parseMoment(json['at']),
  );

  final int id;
  final MessageAuthor author;
  final String? name;
  final String body;
  final DateTime? at;
}

/// What `POST /connect` returns.
class ConnectResult {
  const ConnectResult({required this.token, required this.patient});

  final String token;
  final Patient patient;
}

/// A check-in as the patient fills it in.
class CheckInDraft {
  const CheckInDraft({
    required this.fit,
    this.wearHours,
    this.comfort,
    this.notes,
  });

  /// seated | loose | tight | damaged
  final String fit;
  final int? wearHours;

  /// none | mild | strong
  final String? comfort;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'fit': fit,
    if (wearHours != null) 'wear_hours': wearHours,
    if (comfort != null) 'comfort': comfort,
    if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
  };
}
