# Hifz — Quran Memorization App

A free, offline-first Quran app built around memorization (hifz) rather than reading.
It tracks your progress page by page, generates a daily plan across the traditional
sabaq / sabqi / manzil tracks, schedules revision with a spaced-repetition scheduler
tuned for Quran, and reminds you at prayer-anchored times.

No ads. No accounts. No tracking. No paid tier. No server.
Intended as sadaqah jariyah.

> **Status: in development.** Phase 0 has not started. Nothing is released yet.
> See [PROGRESS.md](PROGRESS.md) for current state.

---

## What it does

- **Memorization tracking** across all 604 pages, rolled up by juz and surah
- **Daily plan** combining new memorization (sabaq), recent review (sabqi), and long-term
  revision (manzil)
- **A scheduler built for Quran** — FSRS with an interval cap and contiguous-block
  batching, or a traditional fixed-cycle rotation if you prefer
- **Faithful mushaf** — the printed Madani layout, never re-typeset
- **Recitation** from multiple reciters with ayah highlighting and a repeat engine
- **Practice drills** — peek and reveal, progressive fade, audio gap mode, page
  transitions, weak-spot review
- **Prayer-anchored reminders** that work without a network connection
- **Backup and restore** to a file you control

## What it will never do

Social features, leaderboards, ads, telemetry, mandatory accounts, or requiring a
network connection to function. These are permanent boundaries, not deferred features.

## Platforms

Android and iOS, from one Flutter codebase. Android ships first as `v1.0.0`; iOS
follows as `v1.1.0` — see [ADR 0007](docs/decisions/0007-ios-in-scope.md).

## Built with

Flutter · Riverpod · Drift · just_audio · flutter_local_notifications · adhan

## Documentation

Start at [CLAUDE.md](CLAUDE.md) — it routes to everything else.

| | |
|---|---|
| [PROGRESS.md](PROGRESS.md) | Where the project currently stands |
| [docs/00-brief.md](docs/00-brief.md) | What this is and why |
| [docs/01-architecture.md](docs/01-architecture.md) | Layers, boundaries, and seams |
| [docs/05-features.md](docs/05-features.md) | Full feature catalogue |
| [docs/phases/](docs/phases/) | The roadmap, one file per phase |
| [docs/decisions/](docs/decisions/) | Why things are the way they are |

## Building

Requires the Flutter SDK version pinned in `.github/workflows/pr-check.yml`.

```bash
flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

```bash
flutter run
```

Before opening a pull request:

```bash
dart format . && flutter analyze && dart run tool/verify_layering.dart && flutter test
```

## Contributing

Contributions are welcome. Please read [docs/03-conventions.md](docs/03-conventions.md)
and [docs/04-workflow.md](docs/04-workflow.md) first — this project has firm
architectural boundaries and they are enforced in CI.

If you want to add a feature, check [docs/phases/post-v1.md](docs/phases/post-v1.md)
first. It is probably already there with a reason attached.

## Licence

Source code: [Apache-2.0](LICENSE).

Quran text, mushaf page images, fonts, and coordinate data are **not** covered by that
licence. They carry their own terms from their respective publishers, reproduced in
`assets/licences/` and shown in the app's About screen. See
[docs/02-data-sources.md](docs/02-data-sources.md).

## Acknowledgements

This app stands on work donated by others — Tanzil, the King Fahd Glorious Quran
Printing Complex, the Quran.com and Quran Foundation projects, everyayah.com, and the
maintainers of every package it depends on. Full attribution is in the app and in
[NOTICE](NOTICE).
