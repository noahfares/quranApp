# Phase 6 — Home & Progress

| | |
|---|---|
| **Version on completion** | `v0.7.0` (`+7`) |
| **Depends on** | Phase 5 (plan, sessions) |
| **Estimate** | 2 weeks part-time |
| **Status** | Not started |

## Objective

Build the screen the user opens every day, and the screen that shows them how far they
have come. After this phase the app is usable daily by a real person — the first point
at which that is true.

## In scope

`PRG-01` through `PRG-08`, and the Home screen.

## Out of scope

Halaqah PDF export (`PRG-09`) — Phase 9. Notifications — Phase 7.

---

## Batches

### Batch 6.1 — Home screen

**Goal:** the default screen. Today's plan, nothing else competing with it.

**Home never opens to a surah list.** The brief is emphatic and it is right — the app's
entire premise is that it tells you what to do today.

Tasks:
- Render today's `DailyPlan` as three clear sections in the brief's format:
  > Memorize 15:1–5 (sabaq)
  > Review pages 210–216 (sabqi)
  > Review Juz 3 (manzil)
- Each item taps straight into its review session.
- Completed items show as done without vanishing — visible progress through the day
  matters.
- An all-done state that is genuinely satisfying rather than an empty screen.
- Estimated time remaining for the day.
- Quick access to the reader for free reading outside the plan.
- Handle gracefully: nothing memorized yet, everything done, paused, rest day.

**Done when:** the plan renders correctly in every state listed; every item navigates
to the right session; the screen is comprehensible in under three seconds.

### Batch 6.2 — Page and juz heatmap

**Goal:** `PRG-01` `PRG-02`.

Tasks:
- 604-page grid coloured by status, using `MushafTheme` status tokens.
- 30-juz summary with per-juz completion.
- Toggle between the two views.
- Tap a page to see its detail — status, stability, last reviewed, next due, lapse
  count, weak spots.
- Legend, always visible. A colour grid without a legend is decoration, not
  information.
- Must render smoothly; 604 cells is trivial but naive rebuilds will still stutter.

**Done when:** the grid renders all 604 pages smoothly and scrolls at 60fps; colours
are distinguishable in all three themes and for the common forms of colour blindness;
tapping a page shows accurate detail.

### Batch 6.3 — Statistics and history

**Goal:** `PRG-03` `PRG-04` `PRG-05` `PRG-07` `PRG-08`.

Tasks:
- Surah-level breakdown.
- Overall percentage memorized — by page, which is the honest measure.
- Review history calendar showing activity per day.
- Projected completion date from recent pace, with the assumption stated plainly.
  A projection presented as certainty is dishonest when the pace is variable.
- Khatm counter for completed revision cycles.
- Aggregate queries must be efficient; precompute rollups where sensible rather than
  scanning 604 rows on every rebuild.

**Done when:** all statistics are correct against hand-computed fixtures; the
projection is clearly labelled as an estimate; the screen loads instantly.

### Batch 6.4 — Streak

**Goal:** `PRG-06`.

Tasks:
- Daily streak counted on plan completion, respecting rest days and pauses.
- **Private. Never shared, never ranked, never compared** — permanent product boundary
  (`docs/00-brief.md` §6).
- Grace handling: a missed day due to an explicit pause does not break the streak.
- Present it as encouragement, not pressure. A broken streak must not be presented as
  failure — this is Quran memorization, and shame is the wrong lever entirely.

**Done when:** streak counts correctly across rest days and pauses; breaking it
produces a gentle message; nothing about it is shareable.

### Batch 6.5 — Navigation and information architecture

**Goal:** the app coheres as a whole.

Tasks:
- Finalise bottom navigation: Home, Reader, Progress, Settings.
- Consistent back behaviour throughout.
- Deep links from Home and Progress into the reader at a specific page.
- Reader remembers where it was independently of plan navigation.
- Empty and error states for every screen. Every one — they are what a new user sees
  first and what a broken state shows.

**Done when:** every screen is reachable and returnable; no dead ends; every screen has
a designed empty state.

---

## Phase Definition of Done

- [ ] Home shows today's plan and handles every state correctly
- [ ] Heatmap renders 604 pages smoothly with an accurate legend
- [ ] All statistics verified against hand-computed fixtures
- [ ] Projection is honest about being an estimate
- [ ] Streak is private, forgiving, and correct across pauses and rest days
- [ ] Every screen has a designed empty state and error state
- [ ] Colours are distinguishable in all three themes and for common colour blindness
- [ ] Controller tests for every screen added in this phase
- [ ] **The developer has used the app daily for one week before closing this phase**
- [ ] All batch DoDs met; analyze, test, layering, format clean

The one-week daily-use requirement is deliberate. This is the first phase where the app
can be used for its actual purpose, and a week of real use surfaces problems no test
will.

## Risks

| Risk | Mitigation |
|---|---|
| Home too dense, users cannot see the next action | Three-second comprehension test; cut anything that competes |
| Statistics slow with a full history | Precomputed rollups; test with three simulated years of data |
| Streak becomes a source of guilt | Deliberately gentle copy; grace on pauses; never shared |

## Release

Version `0.7.0+7`, tag `v0.7.0`, message `Phase 6 — Home & Progress`.
