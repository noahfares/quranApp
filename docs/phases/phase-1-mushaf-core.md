# Phase 1 — Mushaf Reader Core

| | |
|---|---|
| **Version on completion** | `v0.2.0` (`+2`) |
| **Depends on** | Phase 0 |
| **Estimate** | 3–4 weeks part-time |
| **Status** | Not started |

## Objective

Render the mushaf faithfully, resolve taps to ayahs, and highlight them — behind the
`MushafRenderer` abstraction from ADR `0001`. Prove the highlight overlay and
hit-testing work before anything else is built on top of them.

**This phase and Phase 3 take longer than expected. Budget accordingly.** Every
subsequent feature — audio sync, review sessions, every drill — consumes the box data
and highlight machinery built here. Errors made here propagate everywhere.

## In scope

`MUS-01` `MUS-02` `MUS-03` `MUS-04`, plus the `MUS-10` spike.

## Out of scope

Zoom, themes on the page, context menus, landscape spread — all Phase 2. Any audio.
Any hifz logic. Navigation beyond swiping between adjacent pages.

---

## Batches

### Batch 1.1 — Quran data model and database

**Goal:** the read-only Quran database and its domain models.

Tasks:
- Build `quran.db` from the verified sources: surahs (number, names, ayah count,
  revelation place), ayahs (surah, number, text, page, juz, hizb, sajda), page mapping,
  juz and hizb boundaries.
- A build-time generation script, checked in, so the DB is reproducible from sources
  rather than being an opaque binary.
- Domain value objects: `PageRef`, `AyahRef`, `SurahRef`, `JuzRef` — validated at
  construction per `docs/03-conventions.md` §3.
- `MushafRepository` interface in `domain/`, Drift implementation in `data/`.

**Done when:** repository returns correct ayah ranges for arbitrary pages; a test
asserts 604 pages, 114 surahs, 6236 ayahs, 30 juz; checksums verify.

### Batch 1.2 — Coordinate database

**Goal:** ayah bounding boxes, correctly scaled.

Tasks:
- Import the `ayahinfo` ayah boxes into `quran.db`.
- Record the **source image width** with the boxes. Boxes are resolution-specific —
  see `docs/02-data-sources.md` §5.
- `AyahBox` model: ayah ref, rect, line number, source width.
- Scaling logic converting source-space boxes to rendered-space, tested at several
  widths.
- Handle multi-line ayahs — one ayah spans several boxes, and this is the common case,
  not an edge case.

**Done when:** boxes for a known page match expected positions within one pixel after
scaling; a multi-line ayah returns all of its boxes.

### Batch 1.3 — The renderer abstraction and image renderer

**Goal:** `MushafRenderer` defined and `ImageMushafRenderer` implemented.

Tasks:
- Define the interface exactly as in `docs/01-architecture.md` §4. **Design it against
  the glyph renderer's needs**, not just the image renderer's — that is the whole point
  of the abstraction, and getting it wrong here wastes the spike.
- Bundle the 1024-width page image set.
- `ImageMushafRenderer`: asset loading, caching, precise sizing.
- Preload adjacent pages so swiping never shows a blank frame.
- Memory ceiling on the image cache — 604 full-resolution bitmaps will exhaust a
  low-end device.

**Done when:** any page 1–604 renders correctly at any screen size; memory stays flat
while swiping through 50 consecutive pages.

### Batch 1.4 — Highlight overlay and hit-testing

**Goal:** the machinery every later feature depends on. This is the phase's core batch.

Tasks:
- `CustomPainter` drawing highlights from `boxes()`, styled from `MushafTheme`.
- Hit-testing taps to an `AyahRef`, handling: taps in gaps between boxes (snap to
  nearest on the same line, or return null in true whitespace), multi-line ayahs, and
  page margins.
- A selection controller holding the selected ayah, exposed by Riverpod.
- Implement highlight, mask, and fade **above the interface** so both renderers and all
  Phase 8 drills inherit them.
- A debug overlay drawing every box outline — indispensable for diagnosing
  misalignment, and worth keeping permanently behind a developer flag.

**Done when:** tapping any ayah on any of ten sampled pages across the mushaf selects
exactly that ayah; highlight aligns to the printed text at three screen sizes; golden
tests cover highlight placement.

### Batch 1.5 — Page navigation

**Goal:** move between pages.

Tasks:
- `PageView` with correct RTL direction — page 2 is to the **left** of page 1.
- Swipe, plus tap zones at the screen edges.
- Page indicator showing page number, surah name, and juz.
- Preserve selection state sensibly across page changes.
- Handle boundaries: page 1 and page 604 do not wrap.

**Done when:** swiping through all 604 pages is smooth with no blank frames; direction
is correct; the indicator is accurate at juz and surah boundaries.

### Batch 1.6 — QPC glyph renderer spike (timeboxed, 5 days hard stop)

**Goal:** determine whether the glyph renderer is viable. **This is a spike, not a
feature.** Prototype code, minimal tests, discarded or promoted based on the outcome.

**Stop at 5 working days regardless of progress.** A spike that overruns is no longer a
spike; it is an unplanned phase.

Tasks:
- Verify the QPC font licence first (`docs/02-data-sources.md` §6). If it does not
  permit redistribution, **stop here** and record the outcome — the rest is moot.
- Obtain the fonts and the word-codepoint table.
- Render a single page: load its font, render line by line.
- **Solve justification** — each line filling the exact page width. This is the crux.
  If this cannot be made to work, the spike has failed.
- Compare against the page image at the same size, visually and by golden diff.
- Measure: per-page font load time, memory with fonts for ten pages loaded, total
  bundle size.

**Done when** one of:
- **Success** — a page renders indistinguishably from the image, justified, within
  acceptable load time. Write ADR `0008` promoting the glyph renderer, and schedule its
  completion in Phase 9. Reopen `MUS-11` and `MUS-12` for v1 consideration.
- **Failure** — record precisely what blocked it in ADR `0008`, keep the interface,
  proceed with images. **This is an acceptable outcome, not a failure of the phase.**

---

## Phase Definition of Done

- [ ] All 604 pages render correctly
- [ ] Tapping any ayah selects exactly that ayah
- [ ] Highlights align to printed text at three screen sizes and two orientations
- [ ] Swiping is smooth in the RTL direction with no blank frames
- [ ] Memory stays bounded across 50+ page navigations
- [ ] Multi-line ayahs highlight fully
- [ ] Golden tests cover highlight placement on at least five representative pages
- [ ] Highlight and hit-test logic sits above the renderer interface, not inside the image implementation
- [ ] Glyph spike concluded and ADR `0008` written, either outcome
- [ ] `PROGRESS.md` decision #3 resolved
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Box coordinates misaligned at some resolutions | Debug box-outline overlay; golden tests at several widths |
| Image memory exhaustion on low-end devices | Bounded cache; test on a low-RAM device, not just a flagship |
| Spike overruns | Hard 5-day stop, written into the batch |
| Interface designed only for images | Design against glyph needs first; the spike will expose any mistake |
| Page images licence blocked in Batch 0.4 | The glyph path becomes critical instead of optional; escalate immediately |

## Release

Version `0.2.0+2`, tag `v0.2.0`, message `Phase 1 — Mushaf Reader Core`.
