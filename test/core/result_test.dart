import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/core/result.dart';

void main() {
  group('Result.ok', () {
    test('isOk is true, isErr is false', () {
      const result = Result<int, String>.ok(42);

      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('when() calls the ok branch', () {
      const result = Result<int, String>.ok(42);

      final out = result.when(ok: (v) => 'value: $v', err: (e) => 'error: $e');

      expect(out, 'value: 42');
    });

    test('map() transforms the value', () {
      const result = Result<int, String>.ok(2);

      final mapped = result.map((v) => v * 10);

      expect(mapped.when(ok: (v) => v, err: (_) => -1), 20);
    });

    test('mapErr() leaves the value untouched', () {
      const result = Result<int, String>.ok(2);

      final mapped = result.mapErr((e) => '$e!');

      expect(mapped.when(ok: (v) => v, err: (_) => -1), 2);
    });
  });

  group('Result.err', () {
    test('isErr is true, isOk is false', () {
      const result = Result<int, String>.err('nope');

      expect(result.isErr, isTrue);
      expect(result.isOk, isFalse);
    });

    test('when() calls the err branch', () {
      const result = Result<int, String>.err('nope');

      final out = result.when(ok: (v) => 'value: $v', err: (e) => 'error: $e');

      expect(out, 'error: nope');
    });

    test('map() leaves the error untouched', () {
      const result = Result<int, String>.err('nope');

      final mapped = result.map((v) => v * 10);

      expect(mapped.when(ok: (_) => -1, err: (e) => e), 'nope');
    });

    test('mapErr() transforms the error', () {
      const result = Result<int, String>.err('nope');

      final mapped = result.mapErr((e) => '$e!');

      expect(mapped.when(ok: (_) => '', err: (e) => e), 'nope!');
    });
  });
}
