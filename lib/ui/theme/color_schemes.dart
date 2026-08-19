import 'package:flutter/material.dart';

/// The app's single accent colour. Every scheme below derives from this —
/// see docs/00-brief.md ("one accent colour").
const Color _seed = Color(0xFF0B6E4F);

/// Light, dark, and sepia Material 3 [ColorScheme]s, all seeded from
/// [_seed]. Sepia further overrides surface tones with warm paper colours,
/// since Material's seeded generator has no "sepia" brightness.
abstract final class AppColorSchemes {
  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  );

  static final ColorScheme sepia =
      ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
      ).copyWith(
        surface: const Color(0xFFF4ECD8),
        onSurface: const Color(0xFF3E2E22),
        surfaceContainerLowest: const Color(0xFFFAF3E4),
        surfaceContainerLow: const Color(0xFFF7EFDD),
        surfaceContainer: const Color(0xFFF1E7D2),
        surfaceContainerHigh: const Color(0xFFEBDFC6),
        surfaceContainerHighest: const Color(0xFFE4D6BA),
      );
}
