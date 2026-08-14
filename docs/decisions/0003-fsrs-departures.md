# 0003 — FSRS with interval cap, contiguity batching, and a cyclical alternative

**Status:** Accepted
**Date:** 2026-08-14

## Context

FSRS is the current state of the art for spaced repetition and the brief selects it for
the manzil track. It is the right base. But FSRS was designed for flashcards, and three
of its assumptions do not hold for Quran memorization:

**1. Cards are independent.** They are not. Quran recall is sequential — a hafiz
reaches page 213 by chaining from 212. Adjacent pages interfere with each other. Recall
of a page in isolation is a different skill from recall in sequence, and only the latter
matters.

**2. A scattered due-list is acceptable.** It is not. Stock FSRS on 604 pages produces
something like "pages 47, 112, 113, 288, 401, 511 are due" — six non-adjacent pages
across five juz. No hafiz revises that way, and being handed that list daily is the
kind of friction that makes people abandon an app. Traditional practice revises
contiguous blocks: a juz, a hizb, a run of pages.

**3. Long intervals are safe.** They are not, here. FSRS will happily push a
well-known page to a six-month interval. Quran memory decays faster than vocabulary
because the material is dense, similar, and long. Traditional practice completes a
manzil khatm every 7 to 30 days for exactly this reason.

Left unmodified, FSRS would produce a technically optimal schedule that fights the
method every user already follows. That is a product failure regardless of how good the
algorithm is.

## Decision

Implement FSRS for manzil with three mandatory departures.

**Interval cap.** A configurable maximum interval, default 30 days. FSRS computes the
interval, then it is clamped. The user may raise it, and the setting explains the
tradeoff plainly.

**Contiguity batching.** Due pages are not presented as a list. When a page is due, the
scheduler expands outward to adjacent pages that are due or due soon (within a
configurable lookahead, default 3 days) and forms a contiguous block. Blocks are
presented as review units. A page pulled forward into a block is graded and rescheduled
normally — early review is not penalised.

**Cyclical manzil mode.** A first-class alternative, selectable in settings. A fixed
rotation over all consolidated pages with a user-set cycle length (default 30 days,
producing roughly one juz per day at full hifz). No algorithm, fully predictable,
matches traditional practice exactly. FSRS-with-caps remains the default.

FSRS ships with published default parameters. **No personal parameter training in v1**
— the review counts a single user generates are far too low to fit meaningfully, and a
badly fitted model is worse than a good default.

## Consequences

**Easy:** users following the traditional method are served without fighting the app.
Users who want algorithmic optimisation get it. Neither is second-class.

**Hard:** contiguity batching means the scheduler is no longer a pure per-card
function. It needs its own tested module and its own edge cases — sparse memorization
where blocks cannot form, a user memorizing non-sequentially (Juz 30 first, which is
extremely common), block boundaries across surah and juz lines.

**Accepted:** the schedule is not FSRS-optimal. The interval cap in particular means
some pages are reviewed more often than strictly necessary. This is the correct
trade — over-reviewing the Quran is not a cost a user will complain about, and
under-reviewing it is.

**Testable:** every departure is pure domain logic with an injected clock, so all of it
is unit-tested at arbitrary dates. This is the most correctness-critical code in the
app; it gets the most tests.

## Alternatives considered

**Stock FSRS, unmodified.** Algorithmically clean, product-hostile. Rejected.

**SM-2.** Simpler and well-understood, but strictly worse scheduling and the same three
problems. No reason to prefer it.

**Pure cyclical only, no algorithm.** Predictable and traditional, but wastes the real
gains available from adapting to which pages a given user actually finds hard. Offered
as an option rather than as the only mode.

**Ayah-level scheduling.** 6236 cards. Rejected in the brief, correctly.
