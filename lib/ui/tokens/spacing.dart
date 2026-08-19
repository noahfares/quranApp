/// Semantic spacing scale. Never hard-code a spacing value in `features/`
/// or `ui/widgets/` — use one of these. See docs/01-architecture.md §10
/// rule 4, enforced by `tool/verify_layering.dart`.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal margin from the screen edge to page content.
  static const double pageMargin = 16;

  /// Inner padding for a card-like surface.
  static const double cardPadding = 16;

  /// Vertical gap between distinct sections on a screen.
  static const double sectionGap = 24;
}
