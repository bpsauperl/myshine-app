import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'reminders/reminders.dart';
import 'state/session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final session = Session(
    storage: DeviceSessionStorage(),
    reminders: kIsWeb ? const NoReminders() : LocalReminders(),
  );
  runApp(MyShineApp(session: session));
  await session.load();
}
