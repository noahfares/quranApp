# Phase 4 — Memorization Domain & Scheduler

| | |
|---|---|
| **Version on completion** | `v0.5.0` (`+5`) |
| **Depends on** | Phase 0 (clock, DB), Phase 1 (page model) |
| **Estimate** | 2–3 weeks part-time |
| **Status** | Not started |

## Objective

Build the memorization engine as pure domain code with no UI whatsoever. This is the
product's core, and it is the most correctness-critical code in the app — a scheduling
bug silently damages someone's hifz over months.

**Every line in this phase is pure Dart, unit-tested, with an injected clock.** If you
find yourself opening a widget file, you are in the wrong phase.

## In scope

`HFZ-01` through `HFZ-05`.

## Out of scope

All UI. The plan generator (`HFZ-08`) is Phase 5 — it composes what is built here.
Personal parameter training (`HFZ-15`) — post-v1, permanently out of v1.

---

## Batches

### Batch 4.1 — Page state model and persistence

**Goal:** `HFZ-01`.

Tasks:
- `PageState`: page ref, `status` (untouched · learning · consolidating · maintained ·
  lapsed), `firstMemorizedAt`, `lastReviewedAt`, `stability`, `difficulty`,
  `lapseCount`, `reviewCount`, `dueAt`.
- Explicit status transition rules — which transitions are legal, and what triggers
  each. Write them as a table in code comments; they are not obvious and will be
  questioned later.
- Drift table plus repository, seeded with 604 untouched rows on first run.
- Rollup queries: totals by juz and by surah.
- `WeakSpot`: ayah ref, created at, resolved at, occurrence count.

**Done when:** all 604 rows seed correctly; rollups are accurate against hand-computed
fixtures; illegal status transitions are rejected; round-trip persistence is tested.

### Batch 4.2 — FSRS implementation

**Goal:** `HFZ-02` — a correct, own implementation.

Tasks:
- FSRS memory state update: stability, difficulty, retrievability.
- The four grades — Again, Hard, Good, Easy.
- Interval calculation from stability and target retention.
- Published default parameters, in one clearly-labelled constants file with a comment
  recording their source and version.
- Handle first review, lapse, and relearning paths.
- **Test against published reference vectors.** Do not accept "it looks reasonable" —
  a subtly wrong FSRS is worse than no FSRS because it is trusted.

**Done when:** the implementation reproduces reference vectors; every grade path is
tested; behaviour at boundary values (first review, immediate lapse, very high
stability) is tested and sane.

### Batch 4.3 — Interval cap and scheduling policy

**Goal:** `HFZ-03` and the surrounding policy layer (ADR `0003`).

Tasks:
- Configurable maximum interval, default 30 days, applied after FSRS computes.
- Configurable target retention.
- Fuzzing so intervals do not clump into a single overloaded day.
- Load balancing: cap reviews per day and defer overflow, oldest-due first.
- Cite ADR `0003` in comments at each departure from stock FSRS.

**Done when:** no computed interval exceeds the cap; a simulated year of reviews at
realistic pace never exceeds the daily cap; fuzzing demonstrably spreads due dates.

### Batch 4.4 — Contiguity batching

**Goal:** `HFZ-04`. The hardest and most valuable batch in this phase.

Tasks:
- Given the due set, expand to contiguous blocks using a configurable lookahead
  (default 3 days).
- Respect block size limits so a block never becomes an unreasonable session.
- Prefer natural boundaries — juz, hizb, surah — when choosing where to cut.
- Pages pulled forward are graded and rescheduled normally, with no early-review
  penalty.
- Handle the awkward realities: sparse memorization where no block can form;
  non-sequential memorization (Juz 30 first, then Juz 1 — extremely common and must
  work well); a single isolated due page.

**Done when:** the scheduler produces contiguous blocks for realistic memorization
patterns; a user who memorized Juz 30 then Juz 1 gets two sensible blocks, not one
absurd span; isolated pages are handled without pathological behaviour.

### Batch 4.5 — Cyclical manzil mode

**Goal:** `HFZ-05` — the traditional alternative (ADR `0003`).

Tasks:
- Fixed rotation over all consolidated pages, cycle length configurable, default 30
  days.
- Even distribution across the cycle, respecting juz boundaries where possible.
- Handles a growing memorized set — newly consolidated pages join the rotation without
  disrupting it.
- Switching modes preserves page state; only the due-date computation changes.
- Track khatm completions (`PRG-08` data).

**Done when:** a full simulated cycle covers every consolidated page exactly once;
adding pages mid-cycle behaves sensibly; switching between modes in either direction
loses no data.

### Batch 4.6 — Simulation harness

**Goal:** confidence that the engine behaves over years, not just over unit tests.

This batch is not optional. Unit tests prove individual functions; only simulation
reveals that the schedule becomes unusable in month eight.

Tasks:
- A test harness simulating a user over 1–3 years: memorization pace, grade
  distribution, missed days, extended breaks.
- Report: daily review load over time, pages per session, blocks per session, lapse
  rate, time to full hifz.
- Run several personas — 1 page/day steady, 3 pages/day aggressive, sporadic with
  frequent breaks, already-hafiz doing maintenance only.
- Assert the load stays bounded and no persona produces an unusable schedule.

**Done when:** all personas produce sane, bounded review loads across three simulated
years; the report is committed so future scheduler changes can be compared against it.

---

## Phase Definition of Done

- [ ] All 604 page states persist and roll up correctly
- [ ] FSRS matches published reference vectors
- [ ] Interval cap, fuzzing, and daily load balancing all working
- [ ] Contiguity batching produces sensible blocks for every tested memorization pattern
- [ ] Cyclical mode covers all pages exactly once per cycle
- [ ] Mode switching is lossless in both directions
- [ ] Simulation harness runs four personas over three years with bounded load
- [ ] **Zero Flutter imports anywhere in this phase's code**
- [ ] Test coverage of `lib/domain/hifz/` is comprehensive — this is the one place to be strict about it
- [ ] Every departure from stock FSRS cites ADR `0003` in a comment
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Subtly wrong FSRS, silently trusted | Reference vectors, not eyeballing |
| Contiguity batching pathological on non-sequential memorization | Explicitly tested as a first-class case, not an edge case |
| Review load explodes at high hifz percentages | The simulation harness exists to catch exactly this |
| Hidden `DateTime.now()` makes tests non-deterministic | Enforced by the layering checker |

## Release

Version `0.5.0+5`, tag `v0.5.0`, message `Phase 4 — Memorization Domain & Scheduler`.
