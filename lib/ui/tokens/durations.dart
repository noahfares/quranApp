/// Semantic animation-duration scale.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 350);

  /// Mushaf page-to-page transitions.
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Highlight fade-in/out during ayah drills.
  static const Duration highlightFade = Duration(milliseconds: 250);
}
