import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'mushaf_theme.dart';
import '../tokens/typography.dart';

/// The three theme modes the app offers. See docs/00-brief.md
/// ("dark mode and a warm sepia reading mode").
enum AppThemeMode { light, dark, sepia }

/// Assembles a [ColorScheme], the shared [AppTypography.textTheme], and a
/// [MushafTheme] extension into one [ThemeData] per [AppThemeMode].
abstract final class AppTheme {
  static ThemeData of(AppThemeMode mode) {
    final (scheme, mushaf) = switch (mode) {
      AppThemeMode.light => (AppColorSchemes.light, MushafTheme.light),
      AppThemeMode.dark => (AppColorSchemes.dark, MushafTheme.dark),
      AppThemeMode.sepia => (AppColorSchemes.sepia, MushafTheme.sepia),
    };

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      scaffoldBackgroundColor: scheme.surface,
      extensions: [mushaf],
    );
  }

  static ThemeData get light => of(AppThemeMode.light);
  static ThemeData get dark => of(AppThemeMode.dark);
  static ThemeData get sepia => of(AppThemeMode.sepia);
}
