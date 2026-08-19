import 'package:flutter/material.dart';

/// Mushaf-specific tokens that don't fit Material's [ColorScheme] — page
/// background, ayah highlighting, grade buttons, and the progress heatmap.
/// See docs/01-architecture.md §4 and docs/00-brief.md for the vocabulary
/// (page `status`: untouched, learning, consolidating, maintained, lapsed;
/// review grades: Again, Hard, Good, Easy).
@immutable
class MushafTheme extends ThemeExtension<MushafTheme> {
  const MushafTheme({
    required this.pageBackground,
    required this.highlightColor,
    required this.highlightOpacity,
    required this.maskColor,
    required this.gradeAgain,
    required this.gradeHard,
    required this.gradeGood,
    required this.gradeEasy,
    required this.statusUntouched,
    required this.statusLearning,
    required this.statusConsolidating,
    required this.statusMaintained,
    required this.statusLapsed,
  });

  /// Background behind the mushaf page image/glyphs.
  final Color pageBackground;

  /// Colour used to highlight the ayah currently playing or being drilled.
  final Color highlightColor;

  /// Opacity applied to [highlightColor] when painted over the page.
  final double highlightOpacity;

  /// Colour used to mask (hide) ayahs during peek/reveal drills.
  final Color maskColor;

  final Color gradeAgain;
  final Color gradeHard;
  final Color gradeGood;
  final Color gradeEasy;

  final Color statusUntouched;
  final Color statusLearning;
  final Color statusConsolidating;
  final Color statusMaintained;
  final Color statusLapsed;

  static const MushafTheme light = MushafTheme(
    pageBackground: Color(0xFFFFFFFF),
    highlightColor: Color(0xFF0B6E4F),
    highlightOpacity: 0.18,
    maskColor: Color(0xFF1B1B1B),
    gradeAgain: Color(0xFFB3261E),
    gradeHard: Color(0xFFE8A33D),
    gradeGood: Color(0xFF4C8C4A),
    gradeEasy: Color(0xFF0B6E4F),
    statusUntouched: Color(0xFFD9D9D9),
    statusLearning: Color(0xFFE8A33D),
    statusConsolidating: Color(0xFF9AC97C),
    statusMaintained: Color(0xFF0B6E4F),
    statusLapsed: Color(0xFFB3261E),
  );

  static const MushafTheme dark = MushafTheme(
    pageBackground: Color(0xFF121212),
    highlightColor: Color(0xFF5FCB9C),
    highlightOpacity: 0.22,
    maskColor: Color(0xFFE6E6E6),
    gradeAgain: Color(0xFFCF6B66),
    gradeHard: Color(0xFFE8B968),
    gradeGood: Color(0xFF7FB77E),
    gradeEasy: Color(0xFF5FCB9C),
    statusUntouched: Color(0xFF3A3A3A),
    statusLearning: Color(0xFFE8B968),
    statusConsolidating: Color(0xFF7FB77E),
    statusMaintained: Color(0xFF5FCB9C),
    statusLapsed: Color(0xFFCF6B66),
  );

  static const MushafTheme sepia = MushafTheme(
    pageBackground: Color(0xFFF4ECD8),
    highlightColor: Color(0xFF0B6E4F),
    highlightOpacity: 0.16,
    maskColor: Color(0xFF3E2E22),
    gradeAgain: Color(0xFFA13F2E),
    gradeHard: Color(0xFFC2842B),
    gradeGood: Color(0xFF4C7A3E),
    gradeEasy: Color(0xFF0B6E4F),
    statusUntouched: Color(0xFFE0D3B3),
    statusLearning: Color(0xFFC2842B),
    statusConsolidating: Color(0xFF8FAE6E),
    statusMaintained: Color(0xFF0B6E4F),
    statusLapsed: Color(0xFFA13F2E),
  );

  @override
  MushafTheme copyWith({
    Color? pageBackground,
    Color? highlightColor,
    double? highlightOpacity,
    Color? maskColor,
    Color? gradeAgain,
    Color? gradeHard,
    Color? gradeGood,
    Color? gradeEasy,
    Color? statusUntouched,
    Color? statusLearning,
    Color? statusConsolidating,
    Color? statusMaintained,
    Color? statusLapsed,
  }) {
    return MushafTheme(
      pageBackground: pageBackground ?? this.pageBackground,
      highlightColor: highlightColor ?? this.highlightColor,
      highlightOpacity: highlightOpacity ?? this.highlightOpacity,
      maskColor: maskColor ?? this.maskColor,
      gradeAgain: gradeAgain ?? this.gradeAgain,
      gradeHard: gradeHard ?? this.gradeHard,
      gradeGood: gradeGood ?? this.gradeGood,
      gradeEasy: gradeEasy ?? this.gradeEasy,
      statusUntouched: statusUntouched ?? this.statusUntouched,
      statusLearning: statusLearning ?? this.statusLearning,
      statusConsolidating: statusConsolidating ?? this.statusConsolidating,
      statusMaintained: statusMaintained ?? this.statusMaintained,
      statusLapsed: statusLapsed ?? this.statusLapsed,
    );
  }

  @override
  MushafTheme lerp(ThemeExtension<MushafTheme>? other, double t) {
    if (other is! MushafTheme) return this;
    return MushafTheme(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      highlightOpacity:
          highlightOpacity + (other.highlightOpacity - highlightOpacity) * t,
      maskColor: Color.lerp(maskColor, other.maskColor, t)!,
      gradeAgain: Color.lerp(gradeAgain, other.gradeAgain, t)!,
      gradeHard: Color.lerp(gradeHard, other.gradeHard, t)!,
      gradeGood: Color.lerp(gradeGood, other.gradeGood, t)!,
      gradeEasy: Color.lerp(gradeEasy, other.gradeEasy, t)!,
      statusUntouched: Color.lerp(statusUntouched, other.statusUntouched, t)!,
      statusLearning: Color.lerp(statusLearning, other.statusLearning, t)!,
      statusConsolidating: Color.lerp(
        statusConsolidating,
        other.statusConsolidating,
        t,
      )!,
      statusMaintained: Color.lerp(
        statusMaintained,
        other.statusMaintained,
        t,
      )!,
      statusLapsed: Color.lerp(statusLapsed, other.statusLapsed, t)!,
    );
  }
}
