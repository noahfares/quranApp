import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_screen.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/theme/theme_mode_controller.dart';
import '../../ui/tokens/spacing.dart';

/// Settings tab landing screen — a theme-mode picker and the entry point
/// to About. Everything else lands in Phase 9. See
/// docs/phases/phase-0-foundation.md Batch 0.7.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageMargin,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l10n.settingsTheme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          RadioGroup<AppThemeMode>(
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeControllerProvider.notifier).set(value);
              }
            },
            child: Column(
              children: [
                for (final mode in AppThemeMode.values)
                  RadioListTile<AppThemeMode>(
                    title: Text(_themeModeLabel(l10n, mode)),
                    value: mode,
                  ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsAbout),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(AppLocalizations l10n, AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => l10n.themeLight,
      AppThemeMode.dark => l10n.themeDark,
      AppThemeMode.sepia => l10n.themeSepia,
    };
  }
}
