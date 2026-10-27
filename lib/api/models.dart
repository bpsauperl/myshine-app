/// Data the myShine API sends (contract v1, section B). Parsing is lenient:
/// a missing or oddly typed field becomes null or empty rather than a crash.
library;

import 'dart:typed_data';

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
    this.checkIn = CheckInState.off,
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
      checkIn: json['check_in'] is Map
          ? CheckInState.fromJson(_map(json['check_in']))
          : CheckInState.off,
    );
  }

  final DateTime? started;
  final int? series;
  final int total;
  final CurrentAligner? current;
  final DateTime? nextChange;
  final DateTime? endsOn;
  final List<ScheduleRow> rows;

  /// Whether the patient checks in each aligner change (the doctor's choice).
  final CheckInState checkIn;
}

/// Check-in as the doctor set it: when on, the patient confirms each aligner
/// change, and the schedule follows. [nextAligner] is null after the last.
class CheckInState {
  const CheckInState({
    required this.enabled,
    this.nextAligner,
    this.dueOn,
    this.lateDays = 0,
  });

  factory CheckInState.fromJson(Map<String, dynamic> json) => CheckInState(
    enabled: json['enabled'] == true,
    nextAligner: _int(json['next_aligner']),
    dueOn: parseDate(json['due_on']),
    lateDays: _int(json['late_days']) ?? 0,
  );

  static const CheckInState off = CheckInState(enabled: false);

  final bool enabled;
  final int? nextAligner;
  final DateTime? dueOn;

  /// Days past [dueOn] without a check-in.
  final int lateDays;

  /// There is an aligner change the patient can check in.
  bool get canCheckIn => enabled && nextAligner != null;
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
    this.photos = 0,
    this.alignerChange = false,
    this.lateDays = 0,
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
    photos: json['photos'] is List
        ? (json['photos'] as List).length
        : _int(json['photos']) ?? 0,
    alignerChange: json['aligner_change'] == true,
    lateDays: _int(json['late_days']) ?? 0,
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

  /// How many photos the server stored with this check-in.
  final int photos;

  /// The patient's aligner change (to [aligner]), rather than a clinic check-in.
  final bool alignerChange;

  /// How many days after it was due the patient changed.
  final int lateDays;
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
    this.photos = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: _int(json['id']) ?? 0,
    author: json['author'] == 'patient'
        ? MessageAuthor.patient
        : MessageAuthor.clinic,
    name: _string(json['name']),
    body: _string(json['body']) ?? '',
    at: parseMoment(json['at']),
    photos: _list(json['photos'])
        .map(MessagePhoto.fromJson)
        .where((p) => p.url.isNotEmpty)
        .toList(),
  );

  final int id;
  final MessageAuthor author;
  final String? name;
  final String body;
  final DateTime? at;
  final List<MessagePhoto> photos;
}

/// A photo attached to a message. [url] is a short-lived private link.
class MessagePhoto {
  const MessagePhoto({required this.id, required this.url});

  factory MessagePhoto.fromJson(Map<String, dynamic> json) =>
      MessagePhoto(id: _int(json['id']) ?? 0, url: _string(json['url']) ?? '');

  final int id;
  final String url;
}

/// What `POST /connect` returns.
class ConnectResult {
  const ConnectResult({required this.token, required this.patient});

  final String token;
  final Patient patient;
}

/// The patient's aligner change as they fill it in: how the new aligner fits,
/// discomfort, a note and optional intraoral photos. The server knows which
/// aligner is next.
class CheckInDraft {
  const CheckInDraft({
    required this.fit,
    this.comfort,
    this.notes,
    this.photos = const {},
  });

  /// seated | loose | tight | damaged
  final String fit;

  /// none | mild | strong
  final String? comfort;
  final String? notes;

  /// Intraoral photos, all optional; sent as `photos[front]` etc. in a
  /// multipart request.
  final Map<IntraoralView, PhotoUpload> photos;

  Map<String, dynamic> toJson() => {
    'fit': fit,
    if (comfort != null) 'comfort': comfort,
    if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
  };
}

/// The five intraoral views a check-in can carry, in the order shown.
enum IntraoralView {
  front(
    'front',
    'Front',
    'Bite together and smile wide, so all front teeth show.',
  ),
  right(
    'right',
    'Right',
    'Bite together, pull your right cheek back and turn a little.',
  ),
  left(
    'left',
    'Left',
    'Bite together, pull your left cheek back and turn a little.',
  ),
  upper(
    'upper',
    'Upper',
    'Tilt your head back and open wide to show your upper teeth.',
  ),
  lower(
    'lower',
    'Lower',
    'Tilt your head down and open wide to show your lower teeth.',
  );

  const IntraoralView(this.key, this.label, this.hint);

  /// The API's word, as in `photos[front]`.
  final String key;
  final String label;
  final String hint;
}

/// A photo taken in the app, ready to upload with a check-in or message.
class PhotoUpload {
  const PhotoUpload({required this.bytes, required this.filename});

  final Uint8List bytes;

  /// With its extension (jpg, png, heic or webp).
  final String filename;
}
