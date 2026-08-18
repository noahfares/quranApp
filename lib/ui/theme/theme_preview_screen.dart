import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'mushaf_theme.dart';
import '../tokens/durations.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Debug-only screen showing every design token in every [AppThemeMode]
/// side by side. Not part of the shipped app — see Batch 0.3 in
/// docs/phases/phase-0-foundation.md.
class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AppThemeMode.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Theme preview'),
          bottom: TabBar(
            tabs: [
              for (final mode in AppThemeMode.values) Tab(text: mode.name),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final mode in AppThemeMode.values) _ThemePanel(mode: mode),
          ],
        ),
      ),
    );
  }
}

class _ThemePanel extends StatelessWidget {
  const _ThemePanel({required this.mode});

  final AppThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(mode);
    return Theme(
      data: theme,
      child: Container(
        color: theme.colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          children: [
            _Section(
              title: 'Typography',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Headline large',
                    style: AppTypography.textTheme.headlineLarge,
                  ),
                  Text(
                    'Title large',
                    style: AppTypography.textTheme.titleLarge,
                  ),
                  Text('Body large', style: AppTypography.textTheme.bodyLarge),
                  Text(
                    'Body medium',
                    style: AppTypography.textTheme.bodyMedium,
                  ),
                  Text(
                    'Label large',
                    style: AppTypography.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _Section(
              title: 'Colour scheme',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _Swatch('primary', theme.colorScheme.primary),
                  _Swatch('secondary', theme.colorScheme.secondary),
                  _Swatch('tertiary', theme.colorScheme.tertiary),
                  _Swatch('surface', theme.colorScheme.surface),
                  _Swatch('error', theme.colorScheme.error),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _Section(
              title: 'Mushaf tokens',
              child: Builder(
                builder: (context) {
                  final mushaf = theme.extension<MushafTheme>()!;
                  return Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _Swatch('page background', mushaf.pageBackground),
                      _Swatch('highlight', mushaf.highlightColor),
                      _Swatch('mask', mushaf.maskColor),
                      _Swatch('grade: again', mushaf.gradeAgain),
                      _Swatch('grade: hard', mushaf.gradeHard),
                      _Swatch('grade: good', mushaf.gradeGood),
                      _Swatch('grade: easy', mushaf.gradeEasy),
                      _Swatch('status: untouched', mushaf.statusUntouched),
                      _Swatch('status: learning', mushaf.statusLearning),
                      _Swatch(
                        'status: consolidating',
                        mushaf.statusConsolidating,
                      ),
                      _Swatch('status: maintained', mushaf.statusMaintained),
                      _Swatch('status: lapsed', mushaf.statusLapsed),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _Section(
              title: 'Spacing',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpacingBar('xs', AppSpacing.xs),
                  _SpacingBar('sm', AppSpacing.sm),
                  _SpacingBar('md', AppSpacing.md),
                  _SpacingBar('lg', AppSpacing.lg),
                  _SpacingBar('xl', AppSpacing.xl),
                  _SpacingBar('xxl', AppSpacing.xxl),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _Section(
              title: 'Radii',
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _RadiusBox('sm', AppRadii.sm),
                  _RadiusBox('md', AppRadii.md),
                  _RadiusBox('lg', AppRadii.lg),
                  _RadiusBox('card', AppRadii.card),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            _Section(
              title: 'Durations',
              child: Text(
                'fast ${AppDurations.fast.inMilliseconds}ms · '
                'medium ${AppDurations.medium.inMilliseconds}ms · '
                'slow ${AppDurations.slow.inMilliseconds}ms · '
                'pageTransition ${AppDurations.pageTransition.inMilliseconds}ms',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.mdRadius,
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTypography.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _SpacingBar extends StatelessWidget {
  const _SpacingBar(this.label, this.value);

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label)),
          Container(height: 12, width: value, color: Colors.blueGrey),
        ],
      ),
    );
  }
}

class _RadiusBox extends StatelessWidget {
  const _RadiusBox(this.label, this.value);

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(value),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.textTheme.labelSmall),
      ],
    );
  }
}
