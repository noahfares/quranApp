# Phase 9 — Backup, Downloads & Settings

| | |
|---|---|
| **Version on completion** | `v0.10.0` (`+10`) |
| **Depends on** | All prior phases |
| **Estimate** | 2–3 weeks part-time |
| **Status** | Not started |

## Objective

Make the app's data safe, its assets manageable, and its behaviour configurable. Backup
is the headline item and it is not negotiable.

## In scope

`SET-01` through `SET-11`, `AUD-09`, `AUD-11`, `PRG-09`, and `SET-09` / glyph renderer
completion if the Phase 1 spike succeeded.

## Out of scope

Cloud sync (`SET-12`) — post-v1 and possibly permanently.

---

## Batches

### Batch 9.1 — Backup and restore

**Goal:** `SET-01` `SET-02` `SET-03`. **The most important batch in this phase.**

There is no cloud sync. A lost or reset phone destroys every page state, every review
record, every weak spot — potentially years of hifz tracking. That is a real harm to a
real person, not an inconvenience, and it is why this ships in v1 rather than as
polish.

Tasks:
- Export all user data — page states, sessions, weak spots, bookmarks, settings,
  streak, khatm history — as a single versioned file.
- A documented, stable, human-readable format (JSON, optionally compressed). Someone
  should be able to recover their data with a text editor if this app disappears.
- Include a schema version. Restore must handle older versions.
- Write via Android's Storage Access Framework so the user chooses the destination.
- Restore with a clear preview of what will be overwritten, and an explicit
  confirmation. **Never merge silently** — show the user what they are about to replace.
- Validate on import; reject a corrupt file with a useful message rather than a partial
  restore.
- Track the last backup date and prompt after 30 days, unobtrusively.
- Offer a backup automatically before any destructive operation.

**Done when:** a full export and restore round-trips every field on a fresh install;
restoring an older schema version works; a corrupted file is rejected cleanly; the
format is documented in `docs/`.

### Batch 9.2 — Asset download manager

**Goal:** `SET-06`, higher-resolution images, and `AUD-09`.

Tasks:
- Download higher-resolution page image sets on request.
- Download audio per surah or per juz for offline playback.
- Progress, pause, resume, and cancel. Resume after an interrupted download rather than
  restarting a 200 MB transfer.
- Storage usage display, with per-category deletion.
- Wi-Fi-only option, default on. Users on metered data will not forgive a silent 200 MB
  download.
- Store in cache-class locations with the do-not-backup flag where applicable
  (`docs/01-architecture.md` §7).
- Handle running out of storage mid-download without corrupting anything.

**Done when:** downloads resume correctly after interruption; storage figures are
accurate; deleting downloaded assets falls back to streaming or bundled assets without
error.

### Batch 9.3 — Translations

**Goal:** `SET-07`.

Tasks:
- Translation catalogue from the Quran Foundation API.
- Download per translation, cache locally.
- Display below the Arabic in the reader, toggleable, with adjustable text size.
- **Per-translation attribution shown in the picker**, not buried in About — it is a
  licence obligation and it is also useful information.
- At least two English translations plus one other language.

**Done when:** translations download, display, and toggle; text size is adjustable;
attribution is visible at the point of selection.

### Batch 9.4 — Settings consolidation

**Goal:** `SET-04` `SET-09` `SET-10` `SET-11`, and every setting scattered across
earlier phases gathered into one coherent screen.

Tasks:
- Structured settings: Reading, Audio, Memorization, Reminders, Data, About.
- Theme selection including system-follow (`SET-04`).
- Day-boundary setting, default Fajr (`SET-10`).
- Renderer selection if the glyph spike succeeded (`SET-09`).
- Full data wipe with typed confirmation and a forced backup offer (`SET-11`).
- Re-run onboarding.
- Every setting has a one-line explanation. A setting a user does not understand is a
  setting they will set wrongly.
- Search within settings.

**Done when:** every setting introduced in Phases 1–8 is present, explained, and
persists; the wipe path is safe and deliberate.

### Batch 9.5 — Halaqah report

**Goal:** `PRG-09`.

A student showing their teacher a clean progress summary is a small feature with real
value in the actual social context of hifz, and it costs almost nothing.

Tasks:
- Generate a PDF: overall progress, per-juz breakdown, recent activity, current
  sabaq/sabqi/manzil, weak areas.
- Clean, printable, respectful typography. This gets handed to a sheikh.
- Configurable date range.
- Share via the system share sheet.
- Fully offline — no server involved.

**Done when:** the PDF generates correctly with real data, prints legibly on A4, and
shares through the system sheet.

### Batch 9.6 — Glyph renderer completion (conditional)

**Goal:** `MUS-10`, and reconsider `MUS-11` / `MUS-12`.

**Only if the Batch 1.6 spike succeeded.** If it did not, skip this batch entirely and
note it in `PROGRESS.md`.

Tasks:
- Complete `GlyphMushafRenderer` to production quality from the spike prototype.
- Lazy font loading with a bounded cache across 604 fonts.
- Font size control (`MUS-10`).
- Word-level highlighting (`MUS-11`) if word data is available.
- Copy ayah text (`MUS-12`).
- Renderer selection in settings, with the image renderer retained as a fallback.
- Verify every drill and highlight feature works identically under both renderers.

**Done when:** the glyph renderer passes every golden test the image renderer passes;
switching renderers at runtime breaks nothing; memory stays bounded across 50 pages.

### Batch 9.7 — Sleep timer and reading comfort

**Goal:** `AUD-11` and remaining small items.

Tasks:
- Sleep timer: fixed durations, end-of-surah, end-of-juz.
- Fade out rather than cutting abruptly.
- Any deferred comfort items from earlier phases.

**Done when:** the timer stops playback correctly for each mode and survives
backgrounding.

---

## Phase Definition of Done

- [ ] Backup and restore round-trips every field on a fresh install
- [ ] Backup format documented and version-tolerant
- [ ] Corrupt backup files rejected cleanly
- [ ] Downloads resume after interruption; storage figures accurate
- [ ] Translations display with attribution at the point of selection
- [ ] Every setting from Phases 1–8 is present, explained, and persistent
- [ ] Halaqah PDF generates and prints correctly
- [ ] Glyph renderer complete, or explicitly skipped with a recorded reason
- [ ] Data wipe is safe, deliberate, and offers a backup first
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Backup format changes later and breaks restores | Schema version from day one; restore tested against older versions |
| Large downloads fail on poor connections | Resumable transfers; Wi-Fi-only default |
| Settings screen becomes an unnavigable dumping ground | Structured sections, per-setting explanations, in-screen search |
| Glyph renderer diverges in behaviour from images | Must pass the identical golden test suite |

## Release

Version `0.10.0+10`, tag `v0.10.0`, message `Phase 9 — Backup, Downloads & Settings`.
