# Progress

**Single source of truth for project state.** Update this at the end of every batch.
If this file disagrees with your memory, this file wins.

---

## Current position

| | |
|---|---|
| **Current version** | `v0.0.1` (pre-development) |
| **Current phase** | Phase 0 — Foundation & Toolchain |
| **Current batch** | Batch 0.4 — not started |
| **Next action** | Batch 0.4 — asset licence verification and pipeline. See `docs/phases/phase-0-foundation.md` |
| **Last updated** | 2026-08-18 |

## Phase ledger

| Phase | Name | Version | Status |
|---|---|---|---|
| 0 | Foundation & Toolchain | `v0.1.0` | In progress |
| 1 | Mushaf Reader Core | `v0.2.0` | Not started |
| 2 | Navigation & Reading Experience | `v0.3.0` | Not started |
| 3 | Audio Engine | `v0.4.0` | Not started |
| 4 | Memorization Domain & Scheduler | `v0.5.0` | Not started |
| 5 | Plan Generator & Review Session | `v0.6.0` | Not started |
| 6 | Home & Progress | `v0.7.0` | Not started |
| 7 | Notifications & Prayer Times | `v0.8.0` | Not started |
| 8 | Hifz Drills | `v0.9.0` | Not started |
| 9 | Backup, Downloads & Settings | `v0.10.0` | Not started |
| 10 | Hardening & Play Store Release | `v1.0.0` | Not started |
| 11 | iOS Release | `v1.1.0` | Not started |

Status values: `Not started` · `In progress` · `Blocked` · `Complete`

## Batch log

Append one row per completed batch. Newest at the bottom.

| Date | Batch | Summary | Commit |
|---|---|---|---|
| — | — | Project skeleton authored | — |
| 2026-08-18 | 0.1 | Flutter project created (`com.noahfares.hifz`, display name "Hifz"); dependency set pinned exact per spec; `analysis_options.yaml`, Android min/target SDK + core library desugaring configured; `FLUTTER_VERSION` in both workflows updated to `3.47.0` (the `3.44.9` pin from the skeleton commit could not resolve `riverpod_generator` against its own bundled `flutter_test` — see blocker below). `flutter analyze`, `dart format --set-exit-if-changed`, `flutter test`, and `tool/verify_layering.dart` all pass. **Not yet verified on a real Android device** — this sandbox has no Android SDK and `dl.google.com` is blocked by org egress policy. | `f6d4596` |
| 2026-08-18 | 0.2 | Full `lib/` and `test/` tree scaffolded per `docs/01-architecture.md` §2, with `.gitkeep` placeholders in directories with no content yet. Added `core/clock.dart` (`Clock`/`SystemClock`/`FakeClock`) and `core/result.dart` (`Result`/`Ok`/`Err`), both with unit tests. `tool/verify_layering.dart` already existed from the skeleton commit; proved it against all 5 violation types (Flutter import in `domain/`, `data`/`features` import in `ui/`, cross-feature import, hardcoded `Colors.` in `features/`, stray `DateTime.now()`) by committing each violation locally, confirming the checker failed with the right message, then reverting. `flutter analyze`, `dart format --set-exit-if-changed`, `flutter test`, and the layering checker all pass. | `d7982cb` |
| 2026-08-18 | 0.3 | Design tokens: `ui/tokens/{spacing,radii,durations,typography}.dart`, all named semantically. `ui/theme/color_schemes.dart` — light/dark/sepia `ColorScheme`s seeded from one accent colour (a deep green, `0xFF0B6E4F` — no accent was specified anywhere in the docs, so this is a placeholder pick, easy to swap by changing one constant). `ui/theme/mushaf_theme.dart` — a `ThemeExtension<MushafTheme>` carrying page background, highlight colour/opacity, mask colour, the four FSRS grade colours (Again/Hard/Good/Easy per `HFZ-10`), and the five page-status colours (untouched/learning/consolidating/maintained/lapsed per the brief's `status` enum). `ui/theme/app_theme.dart` assembles all three into `ThemeData` via `AppThemeMode`. Added a debug-only `ThemePreviewScreen` (tabbed, one tab per theme) and wired `lib/main.dart` to show it as the temporary home screen until Batch 0.7 builds real routing. `flutter analyze`, `dart format --set-exit-if-changed`, `flutter test`, and the layering checker all pass. | `pending` |

## Open blockers

| # | Blocker | Impact | Owner |
|---|---|---|---|
| 1 | Asset licence verification not yet done (page images, QPC fonts, ayah coordinates) | Blocks bundling any mushaf asset | Batch 0.4 |
| 2 | Audio CDN redistribution permission not requested | Blocks v1.0.0 release, not development | Phase 10 |
| 3 | Apple Developer Program not enrolled. An iPhone is available, but TestFlight needs the paid account to install on it | Blocks the Batch 3.7 iOS audio checkpoint. Skippable — see ADR `0007` | Batch 3.7 |
| 4 | The cloud dev sandbox has no Android SDK and no real device, and `dl.google.com` is blocked by org egress policy — cannot be installed from this environment | Blocks the "runs on a real Android device" half of Batch 0.1's Definition of Done. Everything else (dependency resolution, `flutter analyze`, `flutter test`, layering check) is verified. Needs a run on a real device or an environment with Android SDK access before Batch 0.1 is fully closed | Batch 0.1 |

## Decisions pending

| # | Question | Needed by |
|---|---|---|
| 1 | **Take the Batch 3.7 iOS audio checkpoint, or skip it?** Taking it costs 99 USD/yr starting several months earlier and about a day of work. Skipping it defers the cost and keeps Android momentum, but an `AVAudioSession` failure then surfaces at Phase 11 as 2–3 weeks of structural rework. Recommended: take it. See ADR `0007`. | Batch 3.7 |
| 2 | **Publishing identity** — personal, masjid, or registered nonprofit. Nonprofit status permanently waives the 99 USD/year Apple fee, so this now matters more than it did when iOS was out of scope. | Phase 10 (decide before Batch 11.1) |
| 3 | Does the QPC glyph spike succeed? If yes, promote the glyph renderer to default and reconsider word-level highlighting for v1. | End of Phase 1 |
