import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import '../api/models.dart';

/// Opens the phone's camera through the page and returns the photo, made
/// smaller by the page (long side 1600, JPEG). Null when the patient comes
/// back without one, or the browser can't do it.
Future<PhotoUpload?> pickPhotoInBrowser() async {
  try {
    final picked = await globalContext.callMethod<JSPromise<JSObject?>>('myShinePickPhoto'.toJS).toDart;
    if (picked == null) {
      return null;
    }
    final bytes = picked.getProperty<JSUint8Array>('bytes'.toJS).toDart;
    final name = picked.getProperty<JSString>('name'.toJS).toDart;
    return bytes.isEmpty ? null : PhotoUpload(bytes: bytes, filename: name);
  } catch (_) {
    return null;
  }
}
