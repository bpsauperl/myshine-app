import 'package:flutter/services.dart';

/// The connect code a clinic gives the patient: 8 characters, shown as
/// `ABCD-2345`. Codes never use 0, O, 1, I or L, so they are easy to read aloud.
class ConnectCode {
  ConnectCode._();

  static const int length = 8;
  static const String alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  /// Uppercase letters and digits only, at most [length] of them.
  static String normalize(String input) {
    final cleaned = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    return cleaned.length > length ? cleaned.substring(0, length) : cleaned;
  }

  /// `abcd2345` → `ABCD-2345`; a dash appears once the fifth character is typed.
  static String format(String input) {
    final code = normalize(input);
    if (code.length <= 4) {
      return code;
    }
    return '${code.substring(0, 4)}-${code.substring(4)}';
  }

  /// Null when [input] is a complete, well-formed code; otherwise what's wrong,
  /// in plain words.
  static String? validate(String input) {
    final code = normalize(input);
    if (code.isEmpty) {
      return 'Type the code from your clinic.';
    }
    final confusing = RegExp('[01OIL]').firstMatch(code);
    if (confusing != null) {
      return 'Codes don\'t use 0, O, 1, I or L. Check the letter "${confusing.group(0)}".';
    }
    if (code.length < length) {
      return 'The code has $length characters.';
    }
    return null;
  }

  static bool isValid(String input) => validate(input) == null;
}

/// Keeps the code field uppercase with the dash in place while typing.
class ConnectCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // A full code stays as it is: extra typing doesn't push characters out.
    final raw = newValue.text.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    if (raw.length > ConnectCode.length &&
        ConnectCode.normalize(oldValue.text).length == ConnectCode.length) {
      return oldValue;
    }

    // Characters before the cursor, so the cursor stays where the patient types.
    final beforeCursor = newValue.selection.isValid
        ? ConnectCode.normalize(
            newValue.text.substring(
              0,
              newValue.selection.end.clamp(0, newValue.text.length),
            ),
          ).length
        : ConnectCode.normalize(newValue.text).length;

    final formatted = ConnectCode.format(newValue.text);
    var offset = beforeCursor > 4 ? beforeCursor + 1 : beforeCursor;
    if (offset > formatted.length) {
      offset = formatted.length;
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
