# Progress

**Single source of truth for project state.** Update this at the end of every batch.
If this file disagrees with your memory, this file wins.

---

## Current position

| | |
|---|---|
| **Current version** | `v0.0.0` (pre-development) |
| **Current phase** | Phase 0 — Foundation & Toolchain |
| **Current batch** | Not started |
| **Next action** | Begin Batch 0.1 — see `docs/phases/phase-0-foundation.md` |
| **Last updated** | 2026-08-14 |

## Phase ledger

| Phase | Name | Version | Status |
|---|---|---|---|
| 0 | Foundation & Toolchain | `v0.1.0` | Not started |
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

## Open blockers

| # | Blocker | Impact | Owner |
|---|---|---|---|
| 1 | Asset licence verification not yet done (page images, QPC fonts, ayah coordinates) | Blocks bundling any mushaf asset | Batch 0.4 |
| 2 | Audio CDN redistribution permission not requested | Blocks v1.0.0 release, not development | Phase 10 |
| 3 | Apple Developer Program not enrolled. An iPhone is available, but TestFlight needs the paid account to install on it | Blocks the Batch 3.7 iOS audio checkpoint. Skippable — see ADR `0007` | Batch 3.7 |

## Decisions pending

| # | Question | Needed by |
|---|---|---|
| 1 | **Take the Batch 3.7 iOS audio checkpoint, or skip it?** Taking it costs 99 USD/yr starting several months earlier and about a day of work. Skipping it defers the cost and keeps Android momentum, but an `AVAudioSession` failure then surfaces at Phase 11 as 2–3 weeks of structural rework. Recommended: take it. See ADR `0007`. | Batch 3.7 |
| 2 | **Publishing identity** — personal, masjid, or registered nonprofit. Nonprofit status permanently waives the 99 USD/year Apple fee, so this now matters more than it did when iOS was out of scope. | Phase 10 (decide before Batch 11.1) |
| 3 | Does the QPC glyph spike succeed? If yes, promote the glyph renderer to default and reconsider word-level highlighting for v1. | End of Phase 1 |
