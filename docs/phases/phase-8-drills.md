# Phase 8 — Hifz Drills

| | |
|---|---|
| **Version on completion** | `v0.9.0` (`+9`) |
| **Depends on** | Phase 1 (boxes, masking), Phase 3 (playback state machine), Phase 5 (weak spots) |
| **Estimate** | 2–3 weeks part-time |
| **Status** | Not started |

## Objective

Build the practice tools that make this app better than its competitors. Everything up
to now has been table stakes that a good Quran app must have. **This phase is the
differentiator.**

Every drill here consumes `MushafRenderer.boxes()` and the masking machinery from
Phase 1, so all of them work under either renderer for free. That was the point of ADR
`0001`.

## In scope

`DRL-01` through `DRL-06`.

## Out of scope

Mutashabihat warnings (`DRL-07`) — post-v1, blocked on data sourcing. Voice-based
checking — permanently out of v1.

---

## Batches

### Batch 8.1 — Drill framework

**Goal:** shared infrastructure, so five drills are not five one-off screens.

Tasks:
- A `Drill` abstraction: setup, present, capture response, score, advance.
- Drill session flow reusing the Phase 5 session shell.
- Drill results recorded — which drill, what content, how it went. Feeds weak spots.
- Drill selection from the reader, from a page detail, and from Home.
- Configurable difficulty where it makes sense.

**Done when:** the framework supports all five drills without special-casing; adding a
sixth drill requires no framework change.

### Batch 8.2 — Peek and reveal

**Goal:** `DRL-01`. The core hifz practice tool.

Tasks:
- Mask the whole page, then reveal only the first word of each ayah using word boxes
  where available, falling back to the leading portion of the ayah box.
- Tap an ayah to reveal it fully; tap again to re-hide.
- "Reveal all" and "hide all".
- Reveal progressively, ayah by ayah, as the user recites.
- Optionally record which ayahs needed revealing — those become weak spots.

**Done when:** masking aligns precisely with the printed text at every zoom level;
reveal is instant; the drill is usable one-handed while reciting aloud.

### Batch 8.3 — Progressive fade

**Goal:** `DRL-02`.

Tasks:
- A slider from full opacity to fully blank, applied to the page.
- Fade the text, not the page background — the mushaf border and ayah markers stay
  visible as anchors.
- Preset levels: 100%, 70%, 40%, 15%, 0%.
- Auto-fade mode stepping down each time the page is reviewed successfully — a
  quantified sense of the memory consolidating, which is genuinely motivating.

**Done when:** fade is smooth and legible at every level; auto-fade tracks review
history correctly; the printed page is never permanently altered.

### Batch 8.4 — Audio gap mode

**Goal:** `DRL-03`. The single highest-value feature in the app.

The reciter recites one ayah, falls silent for exactly the duration of the next while
the user recites it, then resumes. It is the only way to practise alone at recitation
speed, and no free app does it well.

Tasks:
- Extend `PlaybackPlan` (Batch 3.1) with an alternating recite/silence pattern. The
  state machine was designed for this — if it needs restructuring, that is a Phase 3
  design error worth noting.
- Silence duration from the actual ayah audio duration, with a configurable multiplier
  for users who recite slower or faster.
- Configurable pattern: alternate every ayah, every two ayahs, or user-selected ayahs.
- Optional visual cue during the silence — a countdown or the masked ayah — so the user
  knows the app has not stalled.
- Optional "prompt" mode playing the first second of the silent ayah as a hint.

**Done when:** the alternating pattern is accurate across a full page including page
transitions; silence duration is correct; the user is never left wondering whether
playback has stopped.

### Batch 8.5 — Transition and recall drills

**Goal:** `DRL-04` `DRL-06`.

Page transitions are the classic hafiz failure point — the end of a page is well
memorized, but the leap to the next page is not, because it is practised least.

Tasks:
- `DRL-04`: present the last ayah of page N, prompt for the first ayah of page N+1,
  reveal to check. Drawn from the user's memorized range.
- `DRL-06`: present a page number or a juz, prompt for that page's first ayah.
- Both are self-graded, and both feed weak spots.
- Prioritise transitions the user has failed before.

**Done when:** both drills draw correctly from the memorized range; both handle surah
and juz boundaries; failures are recorded and prioritised on repeat.

### Batch 8.6 — Weak-spot drill

**Goal:** `DRL-05`.

Tasks:
- A session composed only of ayahs tagged weak (Phase 5).
- Present each in context — the surrounding ayahs matter, since a weak ayah is usually
  weak because of what precedes it.
- Mark resolved after several consecutive successes.
- Sort by occurrence count and recency.
- Empty state that is a genuine achievement, not a blank screen.

**Done when:** the drill draws all unresolved weak spots; resolution logic works;
context display is correct at page boundaries.

---

## Phase Definition of Done

- [ ] All five drills work under the active renderer
- [ ] Masking aligns precisely at every zoom level
- [ ] Audio gap mode is accurate across page transitions
- [ ] Drills are reachable from the reader, page detail, and Home
- [ ] Drill results feed weak spots correctly
- [ ] The drill framework required no restructuring to support all five
- [ ] Each drill has been used in a real memorization session by the developer
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Masking misaligns, revealing or hiding the wrong text | Reuses Phase 1 boxes; tested at multiple zoom levels |
| `PlaybackPlan` cannot express the gap pattern | Batch 3.1 was designed for it; if not, restructure there rather than hacking around it here |
| Word boxes unavailable, so peek/reveal is imprecise | Fall back to a leading fraction of the ayah box; acceptable, and exact under the glyph renderer |
| Five drills feel like five disconnected features | The shared framework in Batch 8.1 exists to prevent this |

## Release

Version `0.9.0+9`, tag `v0.9.0`, message `Phase 8 — Hifz Drills`.
