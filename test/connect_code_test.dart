import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshine/util/connect_code.dart';

void main() {
  group('ConnectCode.format', () {
    test('uppercases and adds the dash after four characters', () {
      expect(ConnectCode.format('abcd2345'), 'ABCD-2345');
      expect(ConnectCode.format('abc'), 'ABC');
      expect(ConnectCode.format('abcd'), 'ABCD');
      expect(ConnectCode.format('abcde'), 'ABCD-E');
    });

    test('drops spaces, dashes and extra characters', () {
      expect(ConnectCode.format(' ab-cd 23 45 '), 'ABCD-2345');
      expect(ConnectCode.format('ABCD-2345-XYZ'), 'ABCD-2345');
    });
  });

  group('ConnectCode.validate', () {
    test('accepts a complete code, with or without the dash', () {
      expect(ConnectCode.validate('ABCD-2345'), isNull);
      expect(ConnectCode.isValid('abcd2345'), isTrue);
    });

    test('asks for all eight characters', () {
      expect(ConnectCode.validate(''), 'Type the code from your clinic.');
      expect(ConnectCode.validate('ABCD-23'), 'The code has 8 characters.');
    });

    test('points at characters codes never use', () {
      expect(ConnectCode.validate('ABC0-2345'), contains('"0"'));
      expect(ConnectCode.validate('ABCO-2345'), contains('"O"'));
      expect(ConnectCode.isValid('ABCL-2345'), isFalse);
    });
  });

  test('the input formatter keeps the dash and the cursor at the end', () {
    final formatter = ConnectCodeInputFormatter();
    final result = formatter.formatEditUpdate(
      const TextEditingValue(text: 'ABCD'),
      const TextEditingValue(
        text: 'ABCDe',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    expect(result.text, 'ABCD-E');
    expect(result.selection.baseOffset, 6);
  });

  test('a full code ignores extra typing', () {
    final formatter = ConnectCodeInputFormatter();
    const full = TextEditingValue(
      text: 'ABCD-2345',
      selection: TextSelection.collapsed(offset: 8),
    );
    final result = formatter.formatEditUpdate(
      full,
      const TextEditingValue(
        text: 'ABCD-234A5',
        selection: TextSelection.collapsed(offset: 9),
      ),
    );
    expect(result.text, 'ABCD-2345');
  });
}
