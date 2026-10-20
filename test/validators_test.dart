import 'package:flutter_shop_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty', () => expect(Validators.email(''), isNotNull));
    test('rejects malformed',
        () => expect(Validators.email('abc@'), isNotNull));
    test('accepts valid',
        () => expect(Validators.email('test@example.com'), isNull));
  });

  group('Validators.password', () {
    test('rejects empty', () => expect(Validators.password(''), isNotNull));
    test('rejects short', () => expect(Validators.password('123'), isNotNull));
    test('accepts valid', () => expect(Validators.password('Test@123'), isNull));
  });
}
