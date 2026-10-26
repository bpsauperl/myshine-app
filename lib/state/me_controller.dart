import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/models.dart';

/// Loads `GET /me` and keeps it for all tabs.
class MeController extends ChangeNotifier {
  MeController({required this.api, this.onUnauthorized});

  final ApiClient api;

  /// Called when the server says the token no longer works.
  final Future<void> Function()? onUnauthorized;

  MeData? _data;
  ApiException? _error;
  bool _loading = false;

  MeData? get data => _data;
  ApiException? get error => _error;
  bool get isLoading => _loading;

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    try {
      _data = await api.me();
      _error = null;
    } on ApiException catch (e) {
      _error = e;
      if (e.isUnauthorized) {
        await onUnauthorized?.call();
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Puts a just-sent check-in at the top without waiting for a reload.
  void addCheckIn(CheckIn checkIn) {
    final current = _data;
    if (current == null) {
      return;
    }
    _data = MeData(
      patient: current.patient,
      plan: current.plan,
      therapy: current.therapy,
      checkIns: [checkIn, ...current.checkIns],
      consents: current.consents,
      unreadMessages: current.unreadMessages,
    );
    notifyListeners();
  }

  /// The Messages tab was opened: the server marks the clinic's messages read.
  void markMessagesRead() {
    final current = _data;
    if (current == null || current.unreadMessages == 0) {
      return;
    }
    _data = MeData(
      patient: current.patient,
      plan: current.plan,
      therapy: current.therapy,
      checkIns: current.checkIns,
      consents: current.consents,
      unreadMessages: 0,
    );
    notifyListeners();
  }
}
