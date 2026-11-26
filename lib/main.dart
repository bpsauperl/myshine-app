import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'reminders/reminders.dart';
import 'screens/home/photo_camera_screen.dart';
import 'state/session.dart';
import 'util/photo_pick.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (kIsWeb) {
    // In the browser the phone's own camera takes the photos (no camera screen of ours).
    PhotoCapture.supported = true;
    PhotoCapture.take = (context, prompt) => pickPhotoInBrowser();
  }
  final session = Session(
    storage: DeviceSessionStorage(),
    reminders: kIsWeb ? const NoReminders() : LocalReminders(),
  );
  runApp(MyShineApp(session: session));
  await session.load();
}
