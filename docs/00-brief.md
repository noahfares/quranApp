# Product Brief

Canonical statement of what this app is. Amended from the original brief with the
decisions locked on 2026-08-14. Where this file and the original brief differ, this
file wins.

---

## 1. Purpose

A Quran app for memorization (hifz). It tracks memorization progress, schedules
revision, and sends reminders. The mushaf reader is a supporting feature. The
memorization engine is the main product.

## 2. Goals

1. Track hifz completion per page, per juz, and per surah.
2. Generate a daily plan.
3. Send reliable reminders at prayer-linked times.
4. Present a beautiful, simple, professional interface.
5. Play recitations with ayah highlighting.

## 3. Positioning

The competitive gap this fills: **no one ships a serious, free, fully offline,
hifz-first app with a faithful mushaf.**

| App | Strength | Gap exploited |
|---|---|---|
| Quran.com | Best mushaf rendering, free | No hifz engine |
| Muslim Pro | Distribution | Bloated, ads, freemium, weak mushaf |
| Quran Companion | Hifz-first, closest rival | Freemium, social-gamified, online |
| Tarteel | AI recitation checking | Paid, cloud-dependent, thin tracking |

Two bars must be cleared or the product fails:
the mushaf must look as good as Quran.com's, and the memorization engine must be
better than Quran Companion's. Everything else is secondary.

## 4. Constraints

- Solo developer, part-time.
- Free. No revenue, no ads, no in-app purchases, no paid tiers.
- Intent is sadaqah jariyah.
- No backend server. Offline-first.
- Open source, Apache-2.0.
- **Android and iOS**, one Flutter codebase, both in scope from Phase 0. Android
  releases first at `v1.0.0`; iOS follows at `v1.1.0` (ADR `0007`).
- **Android is the working priority.** iOS ships at `v1.1.0` and is not allowed to
  pull focus before then.
- An iPhone is available for testing; no Mac is owned, and one may never be needed. CI
  builds iOS continuously for free; behavioural verification happens at two deliberate
  checkpoints only, via TestFlight. See ADR `0007`.

## 5. Non-goals for v1

Deferred — see `docs/phases/post-v1.md`:

- Tafsir
- Multiple qira'at (Hafs only)
- Voice-based memorization checking
- Import of external audio or video
- Cloud sync between devices
- Mutashabihat (similar-ayah) warnings — data sourcing not yet done

**Conditionally deferred:** word-level highlighting. Excluded under the image
renderer. If the QPC glyph spike in Phase 1 succeeds, word-level highlighting
becomes nearly free and is reconsidered for v1 at that point — not before.

## 6. Permanent product boundaries

Never build these, in any version:

- Social features, friend lists, leaderboards, public profiles
- Advertising or monetisation of any kind
- Analytics, telemetry, or usage tracking
- Any account system or mandatory sign-in

These are not deferrals. They are what the product is defined against. Streaks and
khatm counters are personal and private; they are never shared or ranked.

## 7. Technology

| Area | Choice | Reason |
|---|---|---|
| Framework | Flutter (Dart) | Developer knows it; logic stays in one codebase |
| Platforms | Android and iOS together | One codebase; Android ships first (ADR `0007`) |
| State | Riverpod | Matches developer's other app; testable; fits headless-widget pattern |
| Database | Drift (SQLite) | Active maintenance; bundles read-only SQLite files |
| Audio | `just_audio` + `audio_service` | Standard stack. Pin versions. |
| Notifications | `flutter_local_notifications` | Exact alarms and boot rescheduling |
| Prayer times | `adhan` | On-device, offline |
| Scheduler | FSRS, own implementation | Current state of the art; owning it allows tuning |

### 7.1 Rejected

- **Fork `quran_android`** — GPL-3.0 conflicts with App Store distribution.
- **Native Kotlin + Swift** — doubles the work forever; ~60% of the code is
  platform-neutral logic.
- **Kotlin Multiplatform / Compose Multiplatform** — CMP is now stable on iOS and is a
  genuine option, but its iOS ecosystem is thinner than Flutter's and the developer
  already knows Flutter. No compensating benefit here.
- **Android-only, native Kotlin + Compose** — would produce the best possible Android
  app, but forecloses iOS, and the English-speaking diaspora audience this app is built
  for skews heavily iOS. Considered and rejected (ADR `0007`).
- **React Native** — no advantage over Flutter here.

### 7.2 Escape hatch

All code in Dart by default. Write a platform channel only after measuring a real
plugin failure.

With both platforms in scope, **every channel implies a Swift counterpart** — native
audio via ExoPlayer and AVPlayer costs roughly 2–3 weeks *per platform*. Treat this as
insurance for Phase 3, not a plan.

## 8. Mushaf rendering

**Do not render Quranic Arabic with the Flutter text engine directly.** Flutter's
renderer has known defects with stacked Arabic diacritics; output will not match the
printed mushaf.

Two viable approaches, both behind a `MushafRenderer` abstraction (ADR `0001`):

- **Image renderer (default, v1).** Page images plus a coordinate database. Draw
  highlights with a `CustomPainter`; hit-test the same boxes for taps.
- **Glyph renderer (spike).** QPC per-page fonts where each codepoint is a
  pre-shaped word glyph from the printed plates. No Arabic shaping occurs, so the
  Flutter defect does not apply.

Full comparison and rationale in ADR `0001`.

## 9. Memorization engine

### 9.1 Scheduling unit

Schedule by **page**. 604 pages. Never by ayah — 6236 cards is an unusable review
load. Ayah-level drill-down exists for weak spots only.

### 9.2 Three tracks

| Track | Content | Cadence |
|---|---|---|
| Sabaq (new) | Today's new lines or page | Daily, fixed target |
| Sabqi (recent) | Last ~7 pages or current juz | Daily, rolling window |
| Manzil (old) | All consolidated pages | Spaced repetition |

Only manzil needs an algorithm. Sabaq and sabqi are rolling windows. Do not
over-engineer them.

### 9.3 Algorithm

FSRS for manzil, default parameters, no personal parameter training in v1 (review
counts are too low to fit).

Grades: Again, Hard, Good, Easy — self-reported.

Three mandatory departures from stock FSRS (ADR `0003`):

1. **Contiguity batching.** Quran recall is sequential and adjacent pages interfere.
   A scattered due-list of non-adjacent pages is unusable. When a page comes due,
   pull in due-soon neighbours to form a contiguous block and schedule the block.
2. **Maximum interval cap.** Default 30 days, configurable. Quran decays faster than
   vocabulary; a six-month interval is wrong both practically and spiritually.
3. **Cyclical manzil mode.** A first-class alternative to FSRS for users who want a
   traditional fixed khatm rotation (e.g. one juz per day, 30-day cycle). One tap in
   settings. Default remains FSRS-with-caps.

### 9.4 Page state

Per page, for all 604:

`status` (untouched · learning · consolidating · maintained · lapsed),
`first_memorized_at`, `last_reviewed_at`, `stability`, `difficulty`, `lapse_count`.

Roll totals up by juz and by surah. Users think in juz.

### 9.5 Weak-spot capture

Grading is per page, but slips happen on single ayahs. After grading, the user may
tap the ayah they stumbled on. This builds a weak-spot heatmap inside the page and
feeds the drill features. It does not create FSRS cards.

## 10. Notifications

### 10.1 Platform limits

Android: Doze delays inexact alarms; Android 12+ restricts `SCHEDULE_EXACT_ALARM`;
some manufacturers (Xiaomi, Huawei, Oppo, Samsung) kill background work; Dart cannot
run in the background after the system kills the app.

iOS: maximum 64 pending local notifications per app — a hard platform limit, and the
binding constraint on how far ahead the scheduler can precompute.

### 10.2 Design

Compute notification text **when scheduling**, not when firing. Tomorrow's plan is
deterministic today.

1. On each app launch, cancel all pending notifications.
2. Schedule the next 7–14 days with text already filled in.
3. Use `AndroidScheduleMode.exactAllowWhileIdle`.
4. Re-arm after device boot.

This removes any need for background execution. The scheduler tracks its own budget
against a configurable cap of 64, which is the real iOS ceiling. At three reminders
per day that is 21 days of runway, not the comfortable margin the 7–14 day window
suggests — the scheduler must know its own budget rather than assume headroom.

### 10.3 Reliability screen

A diagnostic screen that detects battery restriction and guides the user to allow the
app, with instructions specific to their device brand.

### 10.4 Timing

Anchor to prayer times, not clock times — e.g. "20 minutes after Fajr". `adhan`
computes these offline.

## 11. Audio

Stream recitations; do not bundle them (one reciter is 200 MB–1 GB). Optional
per-surah download for offline use.

Sources: everyayah.com, Islamic Network CDN, Quran Foundation CDN.

**Before v1 release, contact these hosts.** Users will consume donated bandwidth.

Build repeat logic in your own state machine above the player, driving a
`ConcatenatingAudioSource`. Do not express it in player flags.

Repeat modes: single ayah × N, ayah range, range with silent pause between.

## 12. Screens

1. **Home** — today's plan. The default screen. Never opens to a surah list.
2. **Mushaf reader** — page rendering, ayah highlight, audio controls.
3. **Progress** — 604-page or 30-juz heatmap.
4. **Review session** — show a page, hide it, grade it.
5. **Settings** — reciter, reminders, downloads, backup, theme.

Home screen example:

> Memorize 15:1–5 (sabaq)
> Review pages 210–216 (sabqi)
> Review Juz 3 (manzil)

Interface rules:

- Material 3 for all chrome.
- Never restyle the mushaf page itself.
- Dark mode and a warm sepia reading mode.
- One accent colour.
- Generous white space.

## 13. Build order

Each step de-risks the next. Steps 1 and 2 take longer than expected.

1. Mushaf reader — prove the highlight overlay and hit-testing first.
2. Audio — three reciters, streamed, ayah highlight.
3. Memorization engine — data model, FSRS, plan generator.
4. Home and progress screens.
5. Notifications — prayer anchors, precompute strategy.
6. Drills, downloads, settings, translations, polish.

Mapped to twelve phases in `docs/phases/`.

**Estimate:** 5–7 months part-time to `v1.0.0` on Android, plus 4–6 weeks to `v1.1.0`
on iOS (Phase 11).

## 14. Platform testing rule

Build for both platforms from Phase 0. **Iterate day-to-day on Android** — the build is
faster and Android is the priority. Run the iOS target in CI on every PR, using free
GitHub Actions macOS runners (free because this repository is public).

**CI catches compilation drift, not behaviour.** Behavioural verification on a physical
iPhone happens at exactly two checkpoints before Phase 11 — end of Phase 3 (audio
sessions) and end of Phase 7 (notification limits) — because a defect in either forces
architectural rework rather than an ordinary fix. Everything else waits for Phase 11.

Simulators give wrong answers for audio sessions, notifications, and file storage,
which is precisely why those checkpoints use a real device. Installation is via
TestFlight from CI; no Mac is involved. See ADR `0007`.

Put downloaded assets in `Application Support` or `Caches` on iOS, with the
do-not-backup flag set. Files in `Documents` sync to iCloud, and 200 MB of page images
must not.

## 15. Costs

- Google Play: 25 USD, one time.
- Apple Developer Program: 99 USD/year, needed at the first iOS checkpoint — end of
  Phase 3 if taken, otherwise Phase 11. TestFlight requires it, not just App Store
  submission. Waived for registered nonprofits — see
  `developer.apple.com/support/fee-waiver`, worth pursuing given the sadaqah framing.
- Mac hardware: **probably nothing.** An iPhone is already available and CI builds are
  free. Buy only on hitting a wall that logs cannot diagnose. See ADR `0007`.
- CI and release pipeline: **free**, on GitHub Actions, because the repository is
  public. This includes the macOS runners that build the iOS target.

**Minimum realistic outlay to be live on both stores: 124 USD in year one.**

Everything else — hosting, artifact storage, the privacy policy page, audio bandwidth —
is free. Audio bandwidth is donated by volunteers rather than free in principle, which
is why Batch 10.4 requires contacting them before release.

## 16. Resolved questions

| Question | Answer | Date |
|---|---|---|
| Platform scope? | Both. Android at `v1.0.0`, iOS at `v1.1.0` | 2026-08-14 |
| Framework, given both platforms? | Flutter — CMP and native ×2 both rejected | 2026-08-14 |
| State management package? | Riverpod | 2026-08-14 |
| Mushaf rendering approach? | Abstraction; images default, QPC spike | 2026-08-14 |
| CI on every push? | No — PR fast check + phase-end full pipeline | 2026-08-14 |

Still open:

1. **iOS verification route** — TestFlight plus a tester, device farm, hosted macOS, or
   owned hardware. Needed before Phase 3, not now. Do not buy hardware pre-emptively.
2. **Publishing identity** — personal, masjid, or registered nonprofit. Now matters
   more than it did: nonprofit status waives the Apple fee permanently. Needed by
   Phase 10.
