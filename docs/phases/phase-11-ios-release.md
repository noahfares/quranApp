# Phase 11 — iOS Release

| | |
|---|---|
| **Version on completion** | `v1.1.0` (`+12`) |
| **Depends on** | Phase 10 (Android live on Play Store) |
| **Estimate** | 4–6 weeks part-time |
| **Status** | Not started |
| **Requires** | Apple Developer Program (99 USD/year), an iOS device verification route (ADR `0007`) |

## Objective

Ship the iOS build to the App Store. The shared Flutter codebase means this is a port,
not a rewrite — but the four areas where iOS genuinely diverges each need real device
testing that cannot be front-run.

**No new features.** Anything that would be new on iOS is either already on Android or
belongs in post-v1.

## Why this phase exists separately

iOS has been building in CI since Phase 0, so the app compiles and its widget tests
pass. That proves nothing about behaviour. Audio sessions, notification delivery,
background audio, and file storage all behave differently on device than on simulator,
and all four are load-bearing for this app.

Releasing Android first (Phase 10) means the shared logic is proven in real use before
iOS-specific defects have to be untangled from ordinary bugs.

---

## Batches

### Batch 11.1 — Toolchain and signing

**Goal:** a signed iOS build on a real device.

Tasks:
- Apple Developer Program should already be enrolled — it was needed from Phase 3 for
  TestFlight. If it somehow was not, enrol now and **check nonprofit fee waiver
  eligibility first**: the waiver is permanent, and `PROGRESS.md` decision #2 should be
  settled before enrolling, because changing the account identity later is painful.
- Bundle identifier, App ID, capabilities: background audio, push (local only).
- Signing certificates and provisioning profiles. Store secrets in GitHub for CI.
- Extend `release.yml` with an iOS archive and TestFlight upload via fastlane.
- Confirm the minimum iOS deployment target and every plugin's support for it.

**Done when:** a signed build installs on a physical iPhone and reaches TestFlight from
CI.

### Batch 11.2 — Audio on iOS

**Goal:** parity with Android for everything in Phase 3.

The highest-risk batch. `AVAudioSession` category and mode selection determines whether
audio plays when the device is silenced, whether it ducks other apps, whether it
survives backgrounding, and whether it resumes after interruption. Simulators report
all of this incorrectly.

Tasks:
- Configure the audio session category for background playback and mixing behaviour.
- Verify the background audio entitlement works in a release build, not just debug.
- Interruption handling: incoming call, Siri, another app taking the session, AirPods
  connect and disconnect, Control Center.
- Lock screen and Control Center metadata via `audio_service`.
- Confirm gapless playback quality matches Android — if `just_audio` falls short here,
  this is where the AVPlayer escape hatch gets measured, not assumed.
- Verify audio gap mode (`DRL-03`) timing accuracy on device.

**Done when:** every interruption scenario is verified on a physical device; background
playback survives a locked screen for 10 minutes; gap-mode timing matches Android.

### Batch 11.3 — Notifications on iOS

**Goal:** parity with Phase 7 within iOS's constraints.

Tasks:
- Notification authorisation flow, requested at a moment the user understands why —
  not on first launch.
- **Verify the 64-pending limit under real conditions.** The scheduler was built
  against this budget from Phase 7; this batch confirms the accounting is correct
  rather than merely intended.
- Confirm precomputed text and prayer-anchored timing fire accurately over a 7-day
  device test.
- Handle authorisation being refused or later revoked in Settings.
- Deep links from notification into the correct session.
- iOS has no boot receiver and needs none — confirm that reschedule-on-launch covers
  every case, including the app being force-quit.

**Done when:** notifications arrive correctly over a 7-day real-device test; the
pending count never exceeds 64; refusing authorisation degrades gracefully.

### Batch 11.4 — Storage and file handling

**Goal:** assets in the right places, with the right flags.

Tasks:
- Downloaded page images and audio go to `Application Support` or `Caches`, **never**
  `Documents`.
- Set the do-not-backup flag on every downloaded asset. 200 MB syncing to iCloud is an
  App Store rejection and a user complaint.
- Backup export (`SET-01`) uses the iOS document picker; the backup file is one thing
  that *should* be user-visible and iCloud-syncable.
- Verify behaviour when the OS purges `Caches` under storage pressure — the app must
  fall back to streaming or bundled assets without error.
- Confirm `data/platform/paths.dart`'s iOS branch, written in Batch 0.5 and never
  exercised until now.

**Done when:** storage locations verified on device; do-not-backup flags confirmed;
cache purge is handled without data loss or crash.

### Batch 11.5 — iOS interface conventions

**Goal:** it should not feel like an Android app running on an iPhone.

Tasks:
- Safe area handling: notch, Dynamic Island, home indicator.
- Back-swipe gesture from the screen edge throughout.
- iOS share sheet for the halaqah report (`PRG-09`) and ayah sharing.
- Dynamic Type respected everywhere except the mushaf page.
- VoiceOver pass over every screen — the Android TalkBack pass does not transfer.
- Verify RTL layout on an Arabic-locale device.
- Test on the range that matters: a small phone (SE), a current phone, and an iPad.

**Done when:** navigation feels native; VoiceOver works throughout; layout is correct
on all three device classes.

### Batch 11.6 — App Store submission

**Goal:** live on the App Store.

Tasks:
- App Store Connect listing: name, subtitle, description, keywords, screenshots at
  every required size, privacy nutrition labels.
- **App Review is stricter than Play Store about religious content.** Be precise and
  neutral in metadata; state clearly that the Quran text is unmodified and sourced
  from a recognised publisher. Include the attribution in the review notes.
- Privacy: the app collects nothing and has no accounts, which makes the nutrition
  labels short and honest.
- TestFlight external testing with real users, including at least one hafiz on iOS.
- Submit, then handle rejection feedback. **Budget for at least one rejection round** —
  it is normal, not a failure.

**Done when:** the app is live on the App Store and the GitHub release is published.

---

## Phase Definition of Done

- [ ] Signed builds reach TestFlight from CI
- [ ] Every audio interruption scenario verified on a physical device
- [ ] Background audio works in a release build
- [ ] Gap-mode timing matches Android
- [ ] Notifications verified over a 7-day real-device test
- [ ] Pending notification count never exceeds 64
- [ ] Downloaded assets carry the do-not-backup flag and are outside `Documents`
- [ ] Cache purge handled without crash or data loss
- [ ] VoiceOver navigable throughout
- [ ] Correct on iPhone SE, current iPhone, and iPad
- [ ] RTL verified on an Arabic-locale device
- [ ] Live on the App Store
- [ ] `README.md` updated with both store links
- [ ] `PROGRESS.md` updated

## Risks

| Risk | Mitigation |
|---|---|
| `AVAudioSession` misconfigured — audio silent or not backgrounding | Batch 11.2 on a physical device; simulators actively mislead here |
| 64-notification limit exceeded in practice | Budget enforced since Phase 7; verified for real here |
| App Store rejection on religious content metadata | Precise neutral wording; attribution in review notes; expect one round |
| `just_audio` gapless quality worse on iOS | Measure before reaching for AVPlayer — the escape hatch is insurance, not a plan |
| iCloud sync of downloaded assets | Do-not-backup flags verified explicitly in Batch 11.4 |

## Release

Version `1.1.0+12`, tag `v1.1.0`, message `Phase 11 — iOS Release`.
