import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'connect_code.dart';

/// The code after `#` in the page's address (`ABCD-2345`), or null when the
/// address carries none. A code is removed from the address bar, without a
/// reload and without a new history entry; anything else after `#` is left
/// alone.
String? takeCodeFromAddress() {
  String? code;
  try {
    final location = globalContext.getProperty<JSObject>('location'.toJS);
    code = ConnectCode.fromLink(
      location.getProperty<JSString>('hash'.toJS).toDart,
    );
    if (code == null) {
      return null;
    }
    final address =
        location.getProperty<JSString>('pathname'.toJS).toDart +
        location.getProperty<JSString>('search'.toJS).toDart;
    final history = globalContext.getProperty<JSObject>('history'.toJS);
    history.callMethod<JSAny?>(
      'replaceState'.toJS,
      history.getProperty<JSAny?>('state'.toJS),
      ''.toJS,
      address.toJS,
    );
  } catch (_) {
    // A browser that won't change the address still gets the code.
  }
  return code;
}
