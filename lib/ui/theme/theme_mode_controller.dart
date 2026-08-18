import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';

/// The app's current theme mode. Lives here (not in `app/`) so
/// `features/settings` can depend on it without importing `app/` —
/// `features/` may import `ui/`, per docs/01-architecture.md §1.
class ThemeModeController extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => AppThemeMode.light;

  void set(AppThemeMode mode) => state = mode;
}

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, AppThemeMode>(
      ThemeModeController.new,
    );
