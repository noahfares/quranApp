# Phase 7 — Notifications & Prayer Times

| | |
|---|---|
| **Version on completion** | `v0.8.0` (`+8`) |
| **Depends on** | Phase 5 (deterministic future plans — hard dependency) |
| **Estimate** | 2–3 weeks part-time |
| **Status** | Not started |

## Objective

Deliver reminders that actually arrive, anchored to prayer times, with no background
execution. Android's notification landscape is hostile and manufacturer-dependent; this
phase is mostly about defeating that rather than about writing notification code.

## In scope

`NTF-01` through `NTF-08`.

## Out of scope

Full iOS polish — Phase 11. **But the iOS notification budget is checked here**, as the
second and last of the two pre-Phase-11 checkpoints (ADR `0007`).

The authorisation flow and the 64-item budget are built in this phase regardless,
because retrofitting a budget into a scheduler is a redesign rather than a fix. The
checkpoint confirms the accounting is actually correct: install on the developer's own
iPhone via TestFlight, run a 7-day schedule, and verify the pending count never exceeds
64 and that authorisation refusal degrades gracefully. Roughly an hour of setup and
then passive observation — it does not pull focus from Android.

Everything else iOS waits for Phase 11.

---

## Batches

### Batch 7.1 — Prayer times

**Goal:** `NTF-07` `NTF-08`.

Tasks:
- `adhan` integration, fully offline after a location is set.
- Location: manual city search from a bundled offline city list, or one-time GPS.
  **GPS is optional and never required** — the app must work fully with a manually
  entered location, since requiring location permission for a Quran app is both
  unnecessary and off-putting.
- Calculation method selection (MWL, ISNA, Egyptian, Umm al-Qura, Karachi, and the
  rest `adhan` supports) with sensible defaulting from the chosen location.
- Madhhab selection for Asr.
- High-latitude rule handling.
- Display today's prayer times so the user can sanity-check them against their local
  masjid — this is how they will trust the anchoring.

**Done when:** prayer times match a known-good reference for several cities and dates;
everything works in airplane mode after the location is set; high-latitude locations do
not produce nonsense.

### Batch 7.2 — Prayer-anchored scheduling

**Goal:** `NTF-01`, as pure domain logic.

Tasks:
- `PrayerAnchor`: a prayer plus an offset — "20 minutes after Fajr", "1 hour before
  Maghrib".
- Resolve an anchor to a concrete `DateTime` for any date.
- Handle the awkward cases: an offset that crosses into the next prayer window, an
  offset that lands in the past when scheduling for today, prayer times shifting across
  a DST change.
- Pure Dart, injected clock, no plugin dependency.

**Done when:** anchors resolve correctly across a full year including DST transitions;
every edge case above is tested.

### Batch 7.3 — Notification precompute and scheduling

**Goal:** `NTF-02` `NTF-05` `NTF-06`. The core of the phase.

The strategy (`docs/00-brief.md` §10.2): compute text when scheduling, never when
firing. This removes any need for background Dart execution, which is the thing Android
will not reliably give you.

Tasks:
- On each app launch: cancel all pending notifications, recompute, reschedule the next
  7–14 days.
- For each day, generate the plan (Phase 5), resolve anchors, and build fully-populated
  notification text — "Review pages 210–216 and Juz 3 today".
- Use `AndroidScheduleMode.exactAllowWhileIdle`.
- Request `SCHEDULE_EXACT_ALARM` on Android 12+, with a clear explanation, and degrade
  gracefully to inexact alarms if it is refused rather than breaking.
- **Track the pending count against a configurable budget, default 64.** Android has no
  such limit; iOS does, and it is hard. At three reminders per day the budget allows 21
  days, so the 7–14 day window has less headroom than it appears. The scheduler must
  account for its own usage rather than assume room (ADR `0007`).
- Per-track configuration: separate reminders for sabaq, sabqi, and manzil, each with
  its own anchor and its own on/off.
- Quiet hours suppressing everything in a window.
- Tapping a notification deep-links to the relevant session.

**Done when:** notifications arrive at the correct times over a 7-day real-device test;
text is correct and pre-populated; the pending count never exceeds the budget; refusing
the exact-alarm permission degrades rather than breaks.

### Batch 7.4 — Boot and time-change re-arming

**Goal:** `NTF-03`.

Tasks:
- `BOOT_COMPLETED` receiver re-arming all alarms.
- Handle timezone change, manual clock change, and DST transitions.
- Re-arm after an app update.
- Verify alarms survive a force-stop followed by a manual app launch.

**Done when:** verified on a real device — reboot, timezone change, and app update each
leave notifications correctly scheduled.

### Batch 7.5 — Reliability diagnostics

**Goal:** `NTF-04`. The batch that determines whether reminders work for real users.

Manufacturer battery optimisation silently kills scheduled alarms on a large share of
Android devices, and the user blames the app. This screen exists because that is the
single most common cause of "the reminders stopped working" reports for every app in
this category.

Tasks:
- Detect: battery optimisation status, exact alarm permission, notification permission,
  manufacturer.
- A diagnostic screen showing each with a clear pass or fail.
- **Per-brand guidance** with direct intent links where they exist — Xiaomi (MIUI
  autostart), Huawei (protected apps), Oppo/Realme/OnePlus (ColorOS), Samsung (sleeping
  apps), Vivo. Each has a different settings path and users cannot be expected to find
  them.
- A "send a test notification in 1 minute" button so the user can verify for themselves.
- Prompt the diagnostic proactively after onboarding, and again if a scheduled
  notification appears to have been missed.

**Done when:** the screen correctly detects state on at least two physical devices from
different manufacturers; the test notification works; guidance links open the right
settings page where the intent is available.

---

## Phase Definition of Done

- [ ] Prayer times correct for multiple cities, verified against a reference
- [ ] Fully offline after location is set
- [ ] Anchors resolve correctly across a year including DST
- [ ] Notifications arrive correctly over a 7-day real-device test
- [ ] Text is precomputed and correct — no computation at fire time
- [ ] Pending count stays within budget
- [ ] Re-arming verified after reboot, timezone change, and app update
- [ ] Diagnostic screen tested on at least two manufacturers
- [ ] Exact-alarm refusal degrades gracefully
- [ ] Quiet hours and per-track configuration work
- [ ] Anchor resolution is pure domain code with no Flutter imports
- [ ] iOS pending-count budget verified on a physical iPhone over 7 days, **or** explicitly skipped and recorded in `PROGRESS.md`
- [ ] All batch DoDs met; analyze, test, layering, format clean

The 7-day real-device test cannot be shortened or simulated. Notification reliability
is not testable any other way, and this is the feature most likely to be quietly broken.

## Risks

| Risk | Mitigation |
|---|---|
| Manufacturer battery killers silently break reminders | The entire point of Batch 7.5 |
| Exact alarm permission refused or revoked | Graceful degradation to inexact; explain the cost |
| Prayer times wrong for the user's convention | Multiple calculation methods; display times so users can verify against their masjid |
| Plan changes make precomputed text stale | Full reschedule on every app launch |

## Release

Version `0.8.0+8`, tag `v0.8.0`, message `Phase 7 — Notifications & Prayer Times`.
