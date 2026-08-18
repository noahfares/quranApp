import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/core/clock.dart';

void main() {
  group('SystemClock', () {
    test('now() returns a real, current instant', () {
      final before = DateTime.now();
      final result = const SystemClock().now();
      final after = DateTime.now();

      expect(result.isAfter(before) || result.isAtSameMomentAs(before), isTrue);
      expect(result.isBefore(after) || result.isAtSameMomentAs(after), isTrue);
    });
  });

  group('FakeClock', () {
    test('now() returns the initial instant until changed', () {
      final initial = DateTime(2026, 1, 1);
      final clock = FakeClock(initial);

      expect(clock.now(), initial);
    });

    test('set() replaces the current instant', () {
      final clock = FakeClock(DateTime(2026, 1, 1));
      final target = DateTime(2026, 6, 15);

      clock.set(target);

      expect(clock.now(), target);
    });

    test('advance() adds a duration to the current instant', () {
      final clock = FakeClock(DateTime(2026, 1, 1));

      clock.advance(const Duration(days: 30));

      expect(clock.now(), DateTime(2026, 1, 31));
    });
  });
}
