# 0007 — iOS is in scope; Android releases first

**Status:** Accepted
**Date:** 2026-08-14
**Supersedes:** [0004 — Defer iOS to post-v1](0004-defer-ios.md)

## Context

ADR `0004` deferred iOS because no Mac was available, on the reasoning that writing
iOS code which is never compiled or tested is speculation rather than support.

That reasoning was sound about *testing*. It was wrong about *market*.

Android is roughly 85–95% of the market in Indonesia, Pakistan, Bangladesh, Egypt, and
Nigeria, which made iOS look like a rounding error. But this is an English-language
hifz app with Western-standard polish, and its most likely audience is Muslims in the
US, UK, Canada, and Australia — markets where iOS is roughly half or more of devices,
and where it skews further toward exactly the demographic that installs a serious
memorization app.

Android-only would not have cost a slice of the addressable audience. It would have
cost most of the audience the app is actually built for.

The Mac problem is real but it is a **logistics** problem, and logistics problems have
purchasable solutions. It should not have been allowed to determine product scope.

## Decision

**Both platforms are in scope from Phase 0.** Flutter, one codebase, as the original
brief specified.

**Android releases first.** `v1.0.0` is the Android Play Store release (Phase 10).
iOS follows as `v1.1.0` (Phase 11) after App Store review and iOS-specific work.

Shipping them simultaneously would be worse: App Store review is slow and
unpredictable, and iOS-specific defects — audio session categories, notification
authorisation, background audio, file storage — are far cheaper to diagnose once the
Android app is proven and the shared logic is known-good.

### iOS verification strategy

**The developer owns an iPhone but no Mac, and Android is the stated priority.** Those
two facts together set the strategy: iOS verification is cheap and self-served when
performed, so it does not need to be frequent to be adequate.

**Throughout — free, continuous, zero effort.** GitHub Actions macOS runners build the
iOS target on every PR. **The repository is public, so macOS runner minutes are free.**
This catches compilation drift and dependency breakage, which is the failure mode ADR
`0004` was actually worried about. It proves nothing behavioural and is not claimed to.

**Deliberately minimal behavioural checkpoints.** Android is the focus; iOS passes
happen only where a defect could force *architectural* rework rather than ordinary
bug-fixing. That is two places:

| Checkpoint | Why it cannot wait for Phase 11 |
|---|---|
| End of Phase 3 | `AVAudioSession` configuration and background audio. If `just_audio` cannot deliver gapless playback or reliable interruption handling on iOS, the AVPlayer escape hatch is a 2–3 week structural change, not a fix. |
| End of Phase 7 | The 64-pending notification limit and authorisation flow. If the budget accounting is wrong, the scheduler changes shape. |

Everything else — interface conventions, VoiceOver, device classes, storage flags —
waits for Phase 11. Those are polish-class problems that do not propagate backwards.

**Install path:** CI builds and signs, uploads to TestFlight, the developer installs on
their own iPhone. No Mac at any point. Iteration is roughly 20–40 minutes per cycle
(build ~10–15 min, TestFlight processing ~5–20 min), which is fine for a verification
pass and unusable for tight debugging — another reason to keep the checkpoints few.

**Diagnostics available without Xcode:**

- `idevicesyslog` from libimobiledevice — live iOS device console over USB, runs on
  Windows, free. Covers most of what Xcode's console is used for.
- TestFlight collects crash logs and surfaces them in App Store Connect.
- The app's own diagnostic log, exportable via the share sheet. Needed anyway for the
  Phase 7 reliability screen, so not extra work.

What remains genuinely unavailable: a debugger attached to native code, and Instruments
for memory and energy profiling.

**Hardware escalation — likely never.** A used M1/M2 Mac mini (~$400–600) or hosted
macOS (~$25–80/month) buys a real debugger and fast iteration. Buy only on hitting a
concrete wall: an audio-session or notification-delivery bug that resists diagnosis
from logs alone. Do not buy pre-emptively.

**Apple Developer Program**, 99 USD/year. Required for TestFlight, so it is needed at
the **first behavioural checkpoint** — end of Phase 3 under the plan above, or Phase 11
if that checkpoint is skipped. Skipping it defers 99 USD by several months and accepts
that an iOS audio problem surfaces at Phase 11 instead, when it is more expensive to
absorb. Recommended: pay at Phase 3.

Waived for registered nonprofits (`developer.apple.com/support/fee-waiver`). Settle
`PROGRESS.md` decision #2 before enrolling — changing the account identity afterwards
is painful.

## Consequences

**Easy:** the whole English-speaking audience is reachable. Flutter makes the shared
domain layer and the great majority of UI free across both platforms, so the marginal
cost of iOS is concentrated in a handful of known places rather than spread everywhere.

**Hard:** the four genuinely divergent areas each need real device testing —
audio session categories and background audio entitlements, notification authorisation
and the 64-pending limit under real conditions, file storage with the do-not-backup
flag on downloaded assets, and App Store review, which is stricter than Play Store
about religious content metadata.

**Accepted:** roughly 4–6 weeks added to the timeline, putting v1.1.0 at about 6–8
months part-time, plus 99 USD/year. Hardware cost is deliberately left open — it may
turn out to be zero.

**Already handled, requiring no rework:** the notification scheduler was built against
a 64-item budget, and `data/platform/paths.dart` already abstracts storage locations.
ADR `0004` mandated both as insurance, and that insurance now pays out.

**Constraint retained:** platform channels now imply a Swift counterpart. Write Dart by
default; add a channel only after measuring a real plugin failure, per the brief's
escape hatch (§7.2).

## Alternatives considered

**Android-only, staying on Flutter.** Considered and rejected on the market argument
above.

**Android-only, switching to Kotlin + Compose.** Genuinely the best achievable Android
app — better platform integration, leaner, and Material 3 that leads rather than trails
the platform. Rejected because it forecloses iOS entirely, and iOS is where the target
audience is.

**Ship both simultaneously at v1.0.0.** Rejected. Couples the Android release to App
Store review timing for no benefit.

**Compose Multiplatform.** Now stable on iOS and a real option, but its iOS ecosystem
is thinner than Flutter's and the developer already knows Flutter. No compensating
benefit for this app.
