/// The connect code in the address the clinic's email opens
/// (`https://…/#ABCD-2345`), in the browser only. It is read once at the
/// start and taken out of the address bar, so it is not kept or shared.
library;

export 'link_code_stub.dart' if (dart.library.js_interop) 'link_code_web.dart';
