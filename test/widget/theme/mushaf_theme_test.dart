import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/ui/theme/mushaf_theme.dart';

void main() {
  group('MushafTheme.copyWith', () {
    test('replaces only the given fields', () {
      const original = MushafTheme.light;

      final updated = original.copyWith(highlightOpacity: 0.5);

      expect(updated.highlightOpacity, 0.5);
      expect(updated.pageBackground, original.pageBackground);
      expect(updated.gradeEasy, original.gradeEasy);
    });
  });

  group('MushafTheme.lerp', () {
    test('at t=0 returns this', () {
      const a = MushafTheme.light;
      const b = MushafTheme.dark;

      final result = a.lerp(b, 0);

      expect(result.pageBackground, a.pageBackground);
      expect(result.highlightOpacity, a.highlightOpacity);
    });

    test('at t=1 returns the other theme', () {
      const a = MushafTheme.light;
      const b = MushafTheme.dark;

      final result = a.lerp(b, 1);

      expect(result.pageBackground, b.pageBackground);
      expect(result.highlightOpacity, b.highlightOpacity);
    });

    test('returns this unchanged when other is not a MushafTheme', () {
      const a = MushafTheme.light;

      final result = a.lerp(null, 0.5);

      expect(result, same(a));
    });
  });

  group('theme variants', () {
    test('light, dark, and sepia are all distinct', () {
      expect(
        MushafTheme.light.pageBackground,
        isNot(MushafTheme.dark.pageBackground),
      );
      expect(
        MushafTheme.dark.pageBackground,
        isNot(MushafTheme.sepia.pageBackground),
      );
      expect(
        MushafTheme.light.pageBackground,
        isNot(MushafTheme.sepia.pageBackground),
      );
    });
  });
}
