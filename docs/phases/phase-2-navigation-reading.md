# Phase 2 — Navigation & Reading Experience

| | |
|---|---|
| **Version on completion** | `v0.3.0` (`+3`) |
| **Depends on** | Phase 1 |
| **Estimate** | 2–3 weeks part-time |
| **Status** | Not started |

## Objective

Turn a page renderer into a usable mushaf. After this phase the reader is genuinely
pleasant to use on its own, which makes it testable by real people well before the
hifz engine exists.

## In scope

`MUS-05` `MUS-06` `MUS-07` `MUS-08` `MUS-09`, `NAV-01` through `NAV-06`,
`MUS-12` (only if the glyph spike succeeded).

## Out of scope

Text search (`NAV-07`, `NAV-08`) — post-v1. Audio. Any hifz feature.

---

## Batches

### Batch 2.1 — Zoom and pan

**Goal:** `MUS-05`.

Tasks:
- `InteractiveViewer` with sensible min and max scale.
- Double-tap to zoom and to reset.
- **Hit-testing must remain correct at every zoom level and pan offset.** This is the
  batch's real work — coordinate transforms compose, and getting it wrong produces
  taps that select the wrong ayah only when zoomed, which is easy to miss.
- Zoom state resets on page change; scale preference persists.

**Done when:** tapping the correct ayah works at 1×, 2×, and 4×, panned to each corner.

### Batch 2.2 — Reading themes on the page

**Goal:** `MUS-06`.

Tasks:
- Sepia and dark applied to the mushaf page. Under the image renderer this is a blend
  or colour filter — **never a shipped altered image** (`docs/02-data-sources.md` §4).
- Tune all three modes on a real device in real lighting. Bad dark mode on a mushaf
  reads as disrespectful, not merely ugly; the text must stay crisp and the paper tone
  must not go muddy grey.
- Verify highlight colours retain contrast in all three modes.
- Optional brightness override within the reader.

**Done when:** all three modes are legible and attractive on a real device; highlight
contrast meets WCAG AA in each.

### Batch 2.3 — Ayah context menu

**Goal:** `MUS-07`.

Tasks:
- Long-press an ayah opens a context sheet.
- Actions: copy reference, bookmark, mark as weak spot, share reference. Play appears
  in Phase 3, copy text (`MUS-12`) only if the glyph spike succeeded.
- Menu is data-driven so Phase 3 and Phase 8 add entries without restructuring it.

**Done when:** long-press works at every zoom level; each action functions; actions
unavailable in this phase are absent rather than disabled-and-confusing.

### Batch 2.4 — Navigation index

**Goal:** `NAV-01` through `NAV-04`.

Tasks:
- Surah index: Arabic name, transliteration, ayah count, revelation place, page number.
- Juz and hizb index.
- Jump to page number.
- Jump to an ayah reference.
- Fast filter across the index by name, number, or transliteration.

**Done when:** every jump target lands on the correct page; the index is usable
one-handed; filtering is instant across all 114 surahs.

### Batch 2.5 — Bookmarks and last-read

**Goal:** `NAV-05` `NAV-06`.

Tasks:
- Bookmark table in `app.db`. Bookmarks are ayah-anchored, not page-anchored, so they
  survive a renderer change.
- Optional name and colour, unlimited count.
- Bookmark list with jump-to.
- Last-read position saved continuously, restored on launch.
- Bookmarks are included in backup (Phase 9) — design the schema with export in mind.

**Done when:** bookmarks survive app restart; last-read restores to the exact page;
deleting `app.db` degrades gracefully rather than crashing.

### Batch 2.6 — Landscape spread and reading comfort

**Goal:** `MUS-08` `MUS-09`.

Tasks:
- Landscape shows two pages, correctly ordered right-to-left.
- Keep-screen-awake toggle while the reader is open, off by default, restored on exit.
- Immersive mode: chrome hides on tap, returns on tap.
- Verify hit-testing on both pages of a spread.

**Done when:** rotating preserves position; both pages of a spread are tappable;
screen-awake does not leak outside the reader.

---

## Phase Definition of Done

- [ ] Zoom, pan, and hit-testing correct together at all scales
- [ ] Three reading modes tuned and legible on a real device
- [ ] Context menu works at every zoom level
- [ ] Every navigation path lands correctly
- [ ] Bookmarks and last-read persist across restarts
- [ ] Landscape spread correct and interactive
- [ ] Widget tests for every controller added in this phase
- [ ] Someone other than the developer has used the reader for 15 minutes and reported back
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Zoom transforms break hit-testing subtly | Explicit tests at multiple scales and pan offsets — this is the most likely bug in the phase |
| Dark mode looks poor over a bitmap | Tune on real hardware; accept a lighter sepia over a bad pure-black if necessary |
| Index performance with 114 surahs plus 604 pages | Trivial data volume; if it is slow, the query is wrong, not the data |

## Release

Version `0.3.0+3`, tag `v0.3.0`, message `Phase 2 — Navigation & Reading Experience`.
