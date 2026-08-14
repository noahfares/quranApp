# Hifz — Quran Memorization App

**Read this file first. It routes you to everything else.**

This is a Flutter app for Quran memorization (hifz). It tracks progress per page,
generates a daily plan, schedules revision, and sends prayer-anchored reminders.
The mushaf reader supports the memorization engine. The memorization engine is the product.

Free. Offline-first. No backend. Open source (Apache-2.0). Intent is sadaqah jariyah.

---

## How to work on this project

The user will say things like **"start Phase 3"** or **"do Batch 4.2"**.

1. Open `PROGRESS.md` — it is the single source of truth for what is done and what is next.
2. Open `docs/phases/phase-<N>-*.md` — it contains the full scope, batches, and definition
   of done for that phase. Everything you need for that phase is in that one file.
3. Work batch by batch. Do not start a batch whose dependencies are unmet.
4. Follow `docs/04-workflow.md` for branching, commits, versioning, tagging, and CI.

**Never skip ahead to a later phase's scope.** Each phase de-risks the next. If you
believe a phase is mis-scoped, say so before writing code — do not silently expand it.

## Document map

| File | What it is | When to read it |
|---|---|---|
| `PROGRESS.md` | Current state, next action | Every session, first |
| `docs/00-brief.md` | Canonical product brief | Once, for context |
| `docs/01-architecture.md` | Layers, boundaries, seams, folder layout | Before writing any code |
| `docs/02-data-sources.md` | Assets, licences, checksums, provenance | Any asset work |
| `docs/03-conventions.md` | Code style, naming, testing, error handling | Before writing any code |
| `docs/04-workflow.md` | Git, batches, phases, versions, tags, CI | Every commit, every release |
| `docs/05-features.md` | Full feature catalogue with stable IDs | Scoping discussions |
| `docs/phases/*.md` | One file per phase — scope and DoD | When working that phase |
| `docs/phases/post-v1.md` | Everything deferred past v1.0.0 | When tempted to build it early |
| `docs/decisions/*.md` | ADRs — locked decisions and their reasoning | Before reversing a decision |

## Locked decisions

These are settled. Do not relitigate them in code review or planning. To change one,
write a new ADR that supersedes the old one — see `docs/decisions/`.

| Decision | Choice | ADR |
|---|---|---|
| Framework | Flutter (Dart) | — (brief) |
| State management | Riverpod | `0002` |
| Database | Drift (SQLite) | — (brief) |
| Mushaf rendering | Abstraction + image renderer default, QPC glyph spike | `0001` |
| Manzil scheduler | FSRS with interval cap and contiguity batching; cyclical mode offered | `0003` |
| Platforms | Android and iOS, one Flutter codebase. Android releases first at `v1.0.0`, iOS follows at `v1.1.0` | `0007` (supersedes `0004`) |
| CI | Fast check on PRs; full pipeline on version tags only | `0005` |
| Licence | Apache-2.0 | `0006` |

## Hard rules

1. **Never modify the Arabic Quran text.** Not by script, not by hand, not to fix an
   encoding issue. Ship source files byte-identical and verify checksums at build time.
   If text looks wrong, the renderer is wrong, not the text.
2. **`lib/domain/` must never import Flutter.** It is pure Dart. This is enforced in CI.
3. **No hardcoded colours, spacing, or type sizes in `lib/features/` or `lib/ui/widgets/`.**
   Use design tokens. This is enforced in CI.
4. **No social features, leaderboards, or ads. Ever.** Not a v1 deferral — a permanent
   product boundary.
5. **No analytics, telemetry, or network calls** except explicit user-initiated audio
   streaming and asset downloads.
6. **Do not run CI on every push.** See `docs/04-workflow.md`.
7. **Preserve all attribution notices** for text, fonts, images, and audio.

## Quick commands

```bash
flutter analyze && flutter test
```

```bash
dart run tool/verify_version.dart
```
