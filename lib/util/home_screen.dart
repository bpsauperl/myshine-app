/// Whether myShine already runs from the phone's home screen (the browser's
/// "standalone" mode). Always true outside the browser.
library;

export 'home_screen_stub.dart' if (dart.library.js_interop) 'home_screen_web.dart';
