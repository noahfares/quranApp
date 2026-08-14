# Phase 0 — Foundation & Toolchain

| | |
|---|---|
| **Version on completion** | `v0.1.0` (`+1`) |
| **Depends on** | Nothing |
| **Estimate** | 1–2 weeks part-time |
| **Status** | Not started |

## Objective

Stand up the project so that every later phase is pure feature work. When this phase
closes, the architecture is enforced by tooling rather than by discipline, the release
pipeline works end to end, and every asset licence question is answered.

Nothing user-facing ships here beyond an About screen. That is expected.

## In scope

`SET-08` (About with attribution). Everything else here is infrastructure.

## Out of scope

Any Quran rendering, any hifz logic, any real screen. If you find yourself writing
domain logic in this phase, you have drifted.

---

## Batches

### Batch 0.1 — Flutter project and dependencies

**Goal:** a Flutter app that builds and runs on Android with the dependency set pinned.

Tasks:
- `flutter create` with organisation identifier and package name settled now — renaming
  the package after a Play Store release is impossible.
- Add and **pin exact versions**: `flutter_riverpod`, `riverpod_annotation`,
  `riverpod_generator`, `drift`, `sqlite3_flutter_libs`, `freezed`, `json_serializable`,
  `go_router`, `just_audio`, `audio_service`, `flutter_local_notifications`, `adhan`,
  `path_provider`, `intl`, `build_runner`, `crypto` (required by
  `tool/verify_checksums.dart`, which CI already runs).
- Pin the Flutter SDK version in `pubspec.yaml` to match
  `FLUTTER_VERSION` in both workflow files. They must not drift.
- Configure `analysis_options.yaml`: `flutter_lints` plus the project rules from
  `docs/03-conventions.md`.
- Set minimum Android SDK, target SDK, and enable core library desugaring
  (`flutter_local_notifications` requires it).
- `.gitignore` covering build output, generated `.g.dart`/`.freezed.dart`, and local
  config.

**Done when:** `flutter run` shows a placeholder screen on a real Android device;
`flutter analyze` reports zero issues.

### Batch 0.2 — Layer scaffolding and enforcement

**Goal:** the folder structure from `docs/01-architecture.md` exists and violating it
fails the build.

Tasks:
- Create the full `lib/` tree with a placeholder in each directory.
- Write `tool/verify_layering.dart` checking all five rules in architecture §10.
- Add `core/clock.dart` with an injectable `Clock` and a `FakeClock` for tests.
- Add `core/result.dart`.
- Prove the checker works: commit a deliberate violation, watch it fail, revert it.

**Done when:** `dart run tool/verify_layering.dart` exits 0 on a clean tree and
non-zero on each of the five violation types.

### Batch 0.3 — Design token system and theming

**Goal:** the layer that makes the later UI redesign cheap.

This batch matters more than its size suggests. Every screen built in Phases 5–9
consumes these tokens, and tokens added late are tokens that half the app ignores.

Tasks:
- `ui/tokens/`: spacing, radii, durations, typography scales. Named semantically
  (`AppSpacing.pageMargin`) not by value (`AppSpacing.s16`).
- `ui/theme/color_schemes.dart`: light, dark, and sepia Material 3 schemes from one
  accent colour.
- `ui/theme/mushaf_theme.dart`: a `ThemeExtension` carrying mushaf-specific tokens —
  page background, highlight colour and opacity, mask colour, grade-button colours,
  status colours for the progress heatmap.
- `ui/theme/app_theme.dart` assembling all three themes.
- A theme-preview screen, debug-only, showing every token in every theme side by side.

**Done when:** the preview screen renders all three themes; the layering checker
rejects a hardcoded colour added to a feature widget.

### Batch 0.4 — Asset licence verification and pipeline

**Goal:** answer every licence question before a single byte is bundled. This is
blocker #1 in `PROGRESS.md`.

Tasks:
- For each asset in `docs/02-data-sources.md` §2, follow the verification procedure in
  §3: source URL and version, licence text copied to `assets/licences/`, redistribution
  permission confirmed, required attribution wording recorded.
- Where a licence is unclear, contact the maintainer. Record the request and the
  response. **Do not bundle anything unresolved.**
- Write `assets/ATTRIBUTION.md`.
- Write `tool/verify_checksums.dart` and `assets/CHECKSUMS.txt`.
- Build the About screen (`SET-08`) rendering `ATTRIBUTION.md`.

**Done when:** every row in the asset inventory reads verified or explicitly deferred
with a reason; the checksum tool fails on a deliberately corrupted file.

### Batch 0.5 — Database foundation

**Goal:** both databases open, migrate, and are testable.

Tasks:
- `data/db/quran_database.dart` — read-only, opened from a bundled asset, copied to
  app storage on first run only if the bundled version is newer.
- `data/db/app_database.dart` — read-write, in app support directory, with a migration
  strategy in place from day one even though there is nothing to migrate yet.
- `data/platform/paths.dart` with Android and iOS branches. The iOS branch is written
  and CI-compiled from here, but not behaviourally verified until Phase 11 — see
  ADR `0007`.
- An in-memory Drift setup for tests.

**Done when:** both databases open on a real device; a test opens an in-memory `app.db`
and round-trips a row; deleting `app.db` and relaunching recovers cleanly.

### Batch 0.6 — CI, release pipeline, and repository configuration

**Goal:** the whole release machine works before there is anything to release.

Proving the pipeline on an empty app is the point — debugging a release workflow while
also trying to ship a feature is how phase-end deadlines slip.

Tasks:
- `.github/workflows/pr-check.yml` per ADR `0005`, including the **iOS build job**.
  macOS runners are free because this repository is public; this job is what stops the
  iOS target silently rotting between now and Phase 11 (ADR `0007`).
- `.github/workflows/release.yml` per ADR `0005`.
- Make the repository public before relying on the iOS job — macOS runner minutes are
  billed at 10× on private repositories.
- `tool/verify_version.dart` — asserts git tag equals `pubspec.yaml` version.
- Android release signing: keystore generated, **backed up outside the repo**, secrets
  configured in GitHub. A lost keystore permanently ends the ability to update the app
  on Play Store.
- `CHANGELOG.md`, `LICENSE` (Apache-2.0), `NOTICE`, PR template.
- Branch protection on `main`: PR required, `pr-check` required, linear history, no
  force push.

**Done when:** a test tag (`v0.0.1-test`) triggers the release workflow end to end and
produces a signed APK as a release asset. Delete the test tag and release afterwards.

### Batch 0.7 — App shell, routing, and localisation

**Goal:** navigable skeleton screens wired to the theme.

Tasks:
- `app/app.dart`, `app/router.dart` (go_router), `app/bootstrap.dart`.
- Bottom navigation: Home, Reader, Progress, Settings. Empty placeholders.
- `flutter_localizations` and ARB setup with English only, per `docs/03-conventions.md`
  §11.
- Global error handler and recovery screen.
- Riverpod `ProviderScope` and observer for debug logging.

**Done when:** all four tabs navigate; theme switches at runtime; every visible string
comes from the ARB file, not a literal.

---

## Phase Definition of Done

- [ ] App builds and runs on a real Android device
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — passes
- [ ] `dart run tool/verify_layering.dart` — passes, and demonstrably fails on each violation type
- [ ] `dart run tool/verify_checksums.dart` — passes
- [ ] `dart run tool/verify_version.dart` — passes
- [ ] Every asset licence verified or explicitly deferred with a written reason
- [ ] About screen shows full attribution
- [ ] All three themes render correctly via the preview screen
- [ ] PR check workflow green on a real PR, **including the iOS build job**
- [ ] Release workflow proven end to end on a test tag, producing a signed APK
- [ ] Release keystore backed up in at least two places outside the repo
- [ ] Branch protection active on `main`
- [ ] `PROGRESS.md` updated

## Risks

| Risk | Mitigation |
|---|---|
| Asset licences unresolvable | Discovered here rather than in Phase 1 — that is why this batch is in Phase 0. If page images are blocked, the glyph spike moves up and becomes critical rather than optional. |
| Android signing misconfigured | Proven on a test tag before any real release |
| Token system too thin, extended ad hoc later | Build the preview screen; it makes gaps visible immediately |

## Release

Follow `docs/04-workflow.md` §3. Version `0.1.0+1`, tag `v0.1.0`, message
`Phase 0 — Foundation & Toolchain`.
