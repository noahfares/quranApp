# Phase 5 — Plan Generator & Review Session

| | |
|---|---|
| **Version on completion** | `v0.6.0` (`+6`) |
| **Depends on** | Phase 4 (scheduler), Phase 1 (reader), Phase 3 (audio, optional in session) |
| **Estimate** | 3 weeks part-time |
| **Status** | Not started |

## Objective

Combine the three tracks into a daily plan, and build the review session where the
user actually does the work. This is the moment the app becomes the product described
in the brief rather than a mushaf reader with a scheduler attached.

## In scope

`HFZ-06` through `HFZ-14`.

## Out of scope

Home screen presentation (Phase 6) — this phase produces the plan as data and a
session UI to execute it. Notifications (Phase 7). Drills (Phase 8).

---

## Batches

### Batch 5.1 — Sabaq and sabqi tracks

**Goal:** `HFZ-06` `HFZ-07`.

Both are rolling windows. **Do not over-engineer them** — the brief is explicit, and
the temptation to give them their own algorithm should be resisted.

Tasks:
- Sabaq: the next unmemorized page or line range, from a configurable daily target
  (lines or pages per day) and a user-set direction (sequential from Juz 1, from Juz 30
  backwards, or a chosen starting point).
- Sabqi: a rolling window over the last N pages memorized, default 7, configurable;
  alternatively the current juz.
- Both are pure functions of page state plus settings.
- Transition rules: when sabaq graduates to sabqi, and when sabqi graduates to manzil.
  These thresholds are user-visible settings with sensible defaults, and they need
  explaining in the UI because users will ask.

**Done when:** both tracks produce correct content for a range of memorization states;
graduation thresholds are tested at their boundaries.

### Batch 5.2 — Daily plan generator

**Goal:** `HFZ-08`.

Tasks:
- Compose sabaq, sabqi, and manzil into one `DailyPlan` for a given date.
- Respect the day boundary setting (default Fajr, not midnight —
  `docs/01-architecture.md` §6).
- Respect rest days and the daily load cap.
- **The plan for a future date must be computable today.** Phase 7's notification
  precompute depends entirely on this, so it is a hard requirement, not a nicety.
- Plan items carry everything needed to render or announce them: track, page range,
  ayah range, estimated minutes.
- Estimate session duration from historical pace, falling back to a default.

**Done when:** a plan generates for any date; tomorrow's plan is computable today and
matches what tomorrow actually produces given no intervening activity; the plan is
pure domain code.

### Batch 5.3 — Review session flow

**Goal:** `HFZ-09` `HFZ-10`.

Tasks:
- Session screen: present a page, offer hide/reveal, take a grade, advance.
- Reuse the Phase 1 renderer and masking. **Do not build a second rendering path.**
- Four grade buttons, colours from `MushafTheme`, positioned in the lower half of the
  screen for one-handed use.
- Progress within the session — item 3 of 12.
- Optional audio playback within the session for checking yourself.
- Pause, resume, and abandon. **An abandoned session must not lose grades already
  given.**
- Session summary on completion.

**Done when:** a full session runs end to end; grades persist immediately rather than
at session end; killing the app mid-session loses nothing; the session works for all
three track types.

### Batch 5.4 — Weak-spot capture

**Goal:** `HFZ-11`.

Tasks:
- After grading a page, offer to tap the ayahs that were difficult.
- Store as `WeakSpot` records. **These do not create FSRS cards** —
  `docs/00-brief.md` §9.5.
- Repeated weak spots on the same ayah increment a count.
- Weak spots resolve when the page is graded Good or Easy several times consecutively,
  or manually.
- Surface them on the page as a subtle marker.
- This data feeds `DRL-05` in Phase 8.

**Done when:** weak spots are capturable in under two taps; they persist; they render
on the page without competing visually with the selection highlight; they never affect
FSRS scheduling.

### Batch 5.5 — Onboarding and starting point

**Goal:** `HFZ-12`.

The first-run experience determines whether an existing hafiz can use the app at all.
Someone with 20 juz memorized who is forced to start from zero will uninstall.

Tasks:
- Ask what is already memorized: nothing, selected juz, selected surahs, or a page
  range. Multi-select over juz is the common case.
- Seed those pages as `maintained` with reasonable initial stability, staggered due
  dates so the first week is not an avalanche of 400 pages.
- Ask the daily target, preferred direction, and rest days.
- Ask the manzil mode — FSRS or cyclical — with a plain-language explanation of each.
- Skippable and fully re-runnable from settings. People get this wrong the first time.

**Done when:** a user declaring 20 juz memorized gets a sane, non-overwhelming first
week; onboarding is re-runnable without data loss; skipping it leaves a usable app.

### Batch 5.6 — Pause, resume, and load adjustment

**Goal:** `HFZ-13` `HFZ-14`.

This batch is a retention feature, not a convenience. Every hifz app punishes a break
with an avalanche of overdue reviews, and users abandon the app rather than face it.

Tasks:
- Explicit pause that freezes scheduling — no due dates advance, nothing accumulates.
- Resume with **graduated catch-up**: spread the backlog over several days rather than
  dumping it on day one.
- Adjust daily load at any time, with the effect on projected completion shown before
  confirming.
- Rest days, weekly recurring.
- A "light day" option that trims today's plan to the highest-priority items without
  penalising the rest.

**Done when:** a 30-day pause and resume produces a manageable catch-up rather than a
wall; load changes take effect on the next plan; nothing is lost across a pause.

---

## Phase Definition of Done

- [ ] All three tracks generate correct content
- [ ] A daily plan generates for any date, including future dates, deterministically
- [ ] Review sessions run end to end for all three track types
- [ ] Grades persist immediately; app kill mid-session loses nothing
- [ ] Weak spots capture, persist, and display without affecting scheduling
- [ ] Onboarding handles an existing hafiz with 20 juz sensibly
- [ ] Pause and resume produce graduated catch-up, verified over a simulated 30-day break
- [ ] Plan generation is pure domain code with no Flutter imports
- [ ] Simulation harness from Batch 4.6 extended to cover full plans
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Plan not deterministic for future dates | Hard requirement in Batch 5.2 — Phase 7 is blocked without it |
| Existing hafiz overwhelmed on day one | Staggered seeding in Batch 5.5, explicitly tested |
| Session state lost on app kill | Persist each grade on entry, never batch at session end |
| Track graduation thresholds confuse users | Sensible defaults, plain-language explanation, settable |

## Release

Version `0.6.0+6`, tag `v0.6.0`, message `Phase 5 — Plan Generator & Review Session`.
