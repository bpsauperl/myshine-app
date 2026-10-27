import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// Reads a photo the camera just saved and deletes the file, so no photo of
/// the patient stays in the app's cache.
Future<Uint8List> readAndDeleteCapture(XFile file) async {
  try {
    return await file.readAsBytes();
  } finally {
    if (!kIsWeb) {
      try {
        await File(file.path).delete();
      } on FileSystemException {
        // Already gone.
      }
    }
  }
}
