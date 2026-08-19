import 'package:flutter/widgets.dart';

/// Semantic corner-radius scale.
abstract final class AppRadii {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;

  /// Fully rounded — pills, chips, circular buttons.
  static const double pill = 999;

  /// The standard radius for card-like surfaces.
  static const double card = 12;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
}
