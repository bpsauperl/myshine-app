/// A photo from the browser: the phone's own camera through the page
/// (`web/index.html`, `myShinePickPhoto`). Outside the browser there is the
/// app's own camera (`PhotoCameraScreen`), and this returns nothing.
library;

export 'photo_pick_stub.dart' if (dart.library.js_interop) 'photo_pick_web.dart';
