# Architecture

Read before writing any code.

The governing constraint: **the UI will be redesigned after the backend is built.**
Every structural decision here exists to make that redesign cheap. A change to how
something looks must never require touching how something works.

---

## 1. Layers

Four layers, strict one-directional dependencies.

```
┌──────────────────────────────────────────────┐
│  features/        screens: controller + view │  ──┐
├──────────────────────────────────────────────┤    │ may import
│  ui/              design system, tokens      │  ←─┤
├──────────────────────────────────────────────┤    │
│  data/            Drift, repos, assets, net  │  ←─┘
├──────────────────────────────────────────────┤
│  domain/          PURE DART. no Flutter.     │  ← imports nothing above
└──────────────────────────────────────────────┘
```

| Layer | May import | Must never import |
|---|---|---|
| `domain/` | Dart SDK, pure packages only | Flutter, Drift, any plugin |
| `data/` | `domain/`, Drift, plugins | `features/`, `ui/` |
| `ui/` | Flutter, `ui/tokens` | `domain/`, `data/`, `features/` |
| `features/` | `domain/`, `data/`, `ui/` | another feature's internals |
| `core/` | Dart SDK | everything else |

**`domain/` never importing Flutter is the single most important rule in this
codebase.** It is roughly 60% of the code — FSRS, plan generation, page state
transitions, prayer-time anchoring, repeat state machines — and keeping it pure means
all of it is unit-testable in milliseconds with no widget tree, and none of it is at
risk when the UI is redesigned. CI fails the build if a Flutter import appears there.

## 2. Folder layout

```
lib/
  main.dart                     entry point, minimal
  app/
    app.dart                    MaterialApp, theme wiring
    router.dart                 go_router config
    bootstrap.dart              startup sequence, DB open, notification re-arm
  core/
    result.dart                 Result<T, E> type
    clock.dart                  injectable time source (never call DateTime.now())
    logging.dart
    extensions/
  domain/                       ← PURE DART, no flutter imports
    mushaf/
      models/                   SurahRef, AyahRef, PageRef, JuzRef, AyahBox
      mushaf_repository.dart    abstract interface
    hifz/
      models/                   PageState, PageStatus, Grade, WeakSpot
      fsrs/                     FSRS implementation + parameters
      scheduler/                due calculation, contiguity batching, cyclical mode
      plan/                     daily plan generator (sabaq/sabqi/manzil)
      hifz_repository.dart      abstract interface
    audio/
      playback_plan.dart        repeat state machine (pure)
      audio_repository.dart     abstract interface
    prayer/
      prayer_anchor.dart        "20 min after Fajr" → DateTime
    notifications/
      notification_plan.dart    pure: given plan + prayer times → scheduled items
  data/
    db/
      app_database.dart         Drift: user data (writable)
      quran_database.dart       Drift: bundled Quran data (read-only)
      tables/
      migrations/
    repositories/               concrete impls of domain interfaces
    assets/
      asset_manifest.dart       checksums, bundled vs downloadable
      asset_downloader.dart
    audio/
      audio_handler.dart        audio_service integration
    platform/
      paths.dart                platform-correct storage locations
      battery_diagnostics.dart
  ui/
    tokens/
      spacing.dart              AppSpacing
      radii.dart
      durations.dart
      typography.dart
    theme/
      app_theme.dart            light / dark / sepia
      mushaf_theme.dart         ThemeExtension: mushaf-specific tokens
      color_schemes.dart
    widgets/                    generic, reusable, feature-agnostic
    mushaf/
      mushaf_renderer.dart      ← the abstraction (see §4)
      image_renderer/
      glyph_renderer/
  features/
    home/
      home_controller.dart      Riverpod notifier — all state and logic
      home_screen.dart          dumb view
      widgets/
    reader/
    progress/
    review/
    settings/
    onboarding/
test/
  domain/                       fast, pure, the bulk of the suite
  data/
  widget/
  golden/
tool/
  verify_version.dart
  verify_checksums.dart
  verify_layering.dart
```

## 3. Riverpod usage

- `Notifier` / `AsyncNotifier` with `riverpod_generator`. No `StateProvider` for
  anything non-trivial.
- **Providers live beside the thing they provide**, not in a global registry file.
- Repositories are exposed as providers; feature controllers depend on the abstract
  `domain/` interface, never on the concrete `data/` class.
- Feature controllers hold **all** state and logic for a screen. The screen widget
  reads the controller's state and renders it. That is all it does.

### The headless-widget rule

Every screen is exactly two files: a controller and a view.

- **Controller** — a Riverpod notifier. Contains state, computation, and every
  callback the view can trigger. Imports nothing from `ui/`. Testable without Flutter.
- **View** — reads state, renders widgets, forwards user events to the controller.
  Contains no business logic, no conditionals beyond presentation, no `DateTime`
  arithmetic, no formatting rules that could differ by locale.

When the UI is redesigned, views are deleted and rewritten. Controllers are untouched.
That is the whole point.

## 4. The mushaf renderer seam

The most important abstraction in the app (ADR `0001`). Two implementations must be
interchangeable at runtime via a setting.

```dart
/// Renders one page of the mushaf and resolves taps to ayahs.
abstract interface class MushafRenderer {
  /// Whether this renderer can serve [page] right now
  /// (assets present, fonts loaded).
  Future<bool> isReady(PageRef page);

  /// Ensure assets for [page] are loaded. Called ahead of display.
  Future<void> prepare(PageRef page);

  /// The page itself, sized to [constraints]. Must not apply app chrome,
  /// padding, or decoration — the caller owns layout.
  Widget buildPage(PageRef page, MushafRenderStyle style);

  /// Ayah bounding boxes in the page's own coordinate space.
  /// Used for highlight painting and masking.
  Future<List<AyahBox>> boxes(PageRef page);

  /// Resolve a tap. [position] is in the page's coordinate space.
  Future<AyahRef?> hitTest(PageRef page, Offset position);

  /// Whether word-level boxes are available. False for the image renderer
  /// unless the word coordinate DB is bundled.
  bool get supportsWordLevel;
}
```

Rules:

- Highlighting, masking, fading, and tap handling are implemented **once**, above the
  interface, driven by `boxes()`. Neither implementation owns highlight logic.
- Drills (peek/reveal, progressive fade) operate on `boxes()` and therefore work with
  both renderers for free.
- The active renderer is a Riverpod provider. Switching it must require no changes
  outside `ui/mushaf/`.

## 5. Two databases

| DB | File | Mode | Contents |
|---|---|---|---|
| Quran | `quran.db` (bundled asset) | read-only | Surahs, ayahs, page/juz mapping, coordinates |
| App | `app.db` (app support dir) | read-write | Page states, sessions, settings, weak spots |

Never write to `quran.db`. Never store Quran content in `app.db`. This split means a
corrupt user database is recoverable by deletion, and a Quran data update is a file
swap with no migration.

## 6. Time

**Never call `DateTime.now()` outside `core/clock.dart`.** Inject `Clock`.

The scheduler, plan generator, and notification builder are all time-dependent and all
must be testable at arbitrary dates. A single `DateTime.now()` buried in domain code
makes the FSRS tests non-deterministic and is the most likely source of a subtle
scheduling bug.

Related: the app's "day" boundary is **not** midnight — it should be configurable and
default to Fajr, because that is how the user's day actually works. Store dates as
local civil dates, not UTC instants, for anything the user reasons about as "today".

## 7. Storage locations

`data/platform/paths.dart` abstracts this so neither platform's rules leak into
feature code.

| Content | Android | iOS |
|---|---|---|
| `app.db` | app support dir | Application Support |
| Downloaded images/audio | external cache or files dir | Caches, **do-not-backup flag set** |
| Backups | user-chosen via SAF | Documents (intentionally iCloud-synced) |

Downloaded assets must never land in a directory that syncs to cloud backup. 200 MB
of page images syncing to iCloud is an App Store rejection and a user complaint.

## 8. Error handling

- `domain/` returns `Result<T, E>` for expected failures. It never throws for
  control flow.
- `data/` translates plugin and platform exceptions into domain errors at the
  boundary. A `DriftException` must never reach a controller.
- Unexpected exceptions bubble to a top-level handler that logs and shows a recovery
  screen. There is no crash reporting service — see the no-telemetry rule.
- **Never swallow an error silently.** If recovery is impossible, surface it.

## 9. Testing

| Kind | Location | Bar |
|---|---|---|
| Domain unit | `test/domain/` | Every scheduler, FSRS, plan, and state-transition path. Non-negotiable. |
| Data | `test/data/` | Repository contracts against an in-memory Drift DB |
| Widget | `test/widget/` | Controllers via `ProviderContainer`; views only for interaction wiring |
| Golden | `test/golden/` | Mushaf rendering and highlight placement only |

Do not chase coverage on views — they are disposable by design. Chase it in `domain/`,
which is permanent.

## 10. Enforced in CI

`tool/verify_layering.dart` fails the build on:

1. Any `package:flutter` import under `lib/domain/` or `lib/core/`.
2. Any `data/` or `features/` import under `lib/ui/`.
3. A cross-feature import (`features/a/` importing `features/b/`).
4. A raw `Color(0x…)`, `Colors.`, or numeric literal `EdgeInsets`/`SizedBox` in
   `lib/features/` or `lib/ui/widgets/`. Use tokens.
5. `DateTime.now()` anywhere outside `core/clock.dart`.

These are cheap to check and expensive to fix later.
