import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// True when the page was opened from the home screen icon: the browser's
/// display mode is standalone, or (on iPhone) `navigator.standalone` is set.
bool runsFromHomeScreen() {
  try {
    final query = globalContext.callMethod<JSObject>('matchMedia'.toJS, '(display-mode: standalone)'.toJS);
    final standalone = (query.getProperty<JSBoolean?>('matches'.toJS))?.toDart ?? false;
    final navigator = globalContext.getProperty<JSObject>('navigator'.toJS);
    final ios = (navigator.getProperty<JSAny?>('standalone'.toJS) as JSBoolean?)?.toDart ?? false;
    return standalone || ios;
  } catch (_) {
    return true;
  }
}
