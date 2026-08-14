# Phase 3 — Audio Engine

| | |
|---|---|
| **Version on completion** | `v0.4.0` (`+4`) |
| **Depends on** | Phase 1 (boxes, highlight), Phase 2 (context menu) |
| **Estimate** | 3–4 weeks part-time |
| **Status** | Not started |

## Objective

Stream recitation with accurate ayah highlighting, background playback, and a repeat
engine driven by our own state machine. Together with Phase 1, this is the other place
the schedule will slip — audio has more platform-specific failure modes than anything
else in the app.

## In scope

`AUD-01` through `AUD-08`, `AUD-10`, `SET-05`.

## Out of scope

Offline download (`AUD-09`) and sleep timer (`AUD-11`) — Phase 9. Audio gap drill
(`DRL-03`) — Phase 8, though the state machine built here must be capable of it.
Word-level sync (`AUD-12`) — post-v1.

Full iOS polish — Phase 11. **But not iOS audio behaviour**, which is checked here.
See Batch 3.7.

---

## Batches

### Batch 3.1 — Playback plan: the pure state machine

**Goal:** all repeat logic as pure domain code, before any player is involved.

Building this first, in `domain/audio/`, is what keeps repeat behaviour testable and
correct. **Do not express repeat logic in player flags** — `just_audio` loop modes
cannot represent "repeat ayahs 5–8 three times with a two-second gap, then continue",
and trying to make them will produce a tangle.

Tasks:
- `PlaybackPlan`: given a range, repeat counts, and gap settings, emit an ordered
  sequence of playback items (ayah refs and silences).
- Support: single ayah × N, range repeat, gap between repeats, whole-page playback,
  continue-to-next-page.
- Track current position and expose the currently sounding ayah.
- **Pure Dart. No Flutter, no plugin, no I/O.**

**Done when:** unit tests cover every repeat mode and combination, including
zero-repeat, single-ayah-range, and cross-page continuation. No player exists yet.

### Batch 3.2 — Audio source and reciters

**Goal:** `AUD-01` `AUD-02` `SET-05`.

Tasks:
- Reciter catalogue: id, name (Arabic and Latin), URL pattern, available bitrates.
- At least three reciters, chosen for wide appeal and clear recitation.
- URL construction for any ayah, per the host's scheme.
- Reciter selection persisted.
- **Network failure handling that does not lose the user's place** — retry with
  backoff, and a clear message rather than silent stalling.

**Done when:** any ayah of any surah plays from each reciter; airplane mode produces a
clear error, not a hang; switching reciter mid-playback resumes at the same ayah.

### Batch 3.3 — Player integration

**Goal:** drive `just_audio` from the plan.

Tasks:
- Feed `ConcatenatingAudioSource` from `PlaybackPlan` output.
- Buffer ahead so ayah transitions have no audible gap — a stutter between ayahs is
  very noticeable in recitation.
- Play, pause, stop, next, previous, seek to ayah.
- Playback speed 0.5×–2× (`AUD-08`) without pitch distortion.
- Translate plugin exceptions into domain errors at the boundary.

**Done when:** continuous playback across a full juz has no audible gaps; speed change
does not interrupt playback; all controls behave correctly mid-repeat.

### Batch 3.4 — Highlight sync and auto-scroll

**Goal:** `AUD-03`.

Tasks:
- Map the currently playing ayah to its boxes and highlight it, reusing the Phase 1
  overlay unchanged.
- Auto-advance the page when playback crosses a page boundary.
- Auto-scroll to keep the playing ayah visible when zoomed.
- Distinguish the *playing* highlight from the *selected* highlight — different tokens
  in `MushafTheme`.
- Setting to disable auto-advance for users who want to follow manually.

**Done when:** highlight tracks audio accurately through a full page including page
transitions; the user tapping a different ayah mid-playback does the obvious thing
(jump there, or select without jumping — decide, document, and be consistent).

### Batch 3.5 — Background playback and interruptions

**Goal:** `AUD-04` `AUD-10`.

Tasks:
- `audio_service` integration: notification controls, lock screen metadata showing
  surah and ayah.
- Audio focus: pause on phone call, on another app taking focus, on headphone
  disconnect. Resume behaviour per platform convention.
- Playback survives the app being backgrounded.
- State restored correctly when returning to the foreground mid-playback.

- Write the iOS `AVAudioSession` configuration alongside the Android audio focus code.
  It compiles in CI; it is verified in Phase 11.

**Done when:** verified on a real Android device — call interruption, headphone unplug,
other app playing audio, screen off for 10 minutes, and returning to the app after
each. **Test on a device, not an emulator.** Emulators misreport audio focus behaviour.
If a Mac is available, run the same script on a physical iPhone and record the result;
if not, Phase 11 owns it.

### Batch 3.6 — Repeat controls UI

**Goal:** `AUD-05` `AUD-06` `AUD-07` exposed usably.

Tasks:
- Playback sheet: reciter, speed, repeat mode, range, count, gap length.
- Range selection by tapping a start and end ayah on the page.
- Presets for the common hifz patterns — repeat current ayah 3×, repeat this page 3×,
  repeat selected range with a gap.
- Persist the last-used configuration.

**Done when:** every repeat mode is reachable in under three taps; presets work;
configuration survives restart.

### Batch 3.7 — iOS audio checkpoint

**Goal:** confirm the audio architecture survives iOS before building four more phases
on top of it.

This is one of only two iOS behavioural checkpoints before Phase 11 (ADR `0007`).
Android is the priority and this batch does not change that — but an `AVAudioSession`
or gapless-playback failure here is a **2–3 week structural change** (the AVPlayer
escape hatch), not a bug fix. Discovering it at Phase 11 means four phases of work
resting on an assumption that turned out false.

Everything else iOS — interface conventions, VoiceOver, storage flags — waits.

Tasks:
- Enrol in the Apple Developer Program if not already. This is where the 99 USD/year
  starts, because TestFlight requires it.
- Extend `release.yml` with iOS signing and a TestFlight upload.
- Install on the developer's own iPhone and verify: background playback with the screen
  locked, call interruption, AirPods connect and disconnect, silent-switch behaviour,
  and gapless playback quality across a full page.
- Confirm the audio session category and background audio entitlement work in a
  **release** build, not just debug.
- Set up `idevicesyslog` (libimobiledevice, runs on Windows) for device console access.

**Done when:** background audio works on a physical iPhone in a release build; every
interruption scenario behaves; gapless quality matches Android — **or** the gap is
measured and recorded, and the AVPlayer escape hatch is scheduled explicitly rather
than assumed away.

**If this batch is skipped** to keep Android momentum, record that in `PROGRESS.md` and
accept that Phase 11 may uncover structural audio work. That is a legitimate trade, but
it must be a decision rather than an oversight.

---

## Phase Definition of Done

- [ ] Three reciters stream reliably
- [ ] Highlight tracks audio accurately, including across page boundaries
- [ ] All repeat modes work and are unit-tested at the domain level
- [ ] Background playback with working lock-screen controls
- [ ] Interruption handling verified on a real device for all four scenarios
- [ ] Network failure produces a clear message and preserves position
- [ ] No audible gap between consecutive ayahs
- [ ] `PlaybackPlan` is pure Dart with no Flutter imports
- [ ] Playback state machine is capable of driving `DRL-03` in Phase 8
- [ ] iOS audio checkpoint passed on a physical iPhone, **or** explicitly skipped and recorded in `PROGRESS.md`
- [ ] All batch DoDs met; analyze, test, layering, format clean

## Risks

| Risk | Mitigation |
|---|---|
| Gapless playback is hard | Buffer ahead; if `just_audio` cannot deliver it, this is the trigger for the platform-channel escape hatch — measure first |
| Audio focus behaves differently per manufacturer | Test on more than one physical device |
| CDN rate-limits or blocks the app | Support multiple hosts with fallback; contact them before v1 (`docs/02-data-sources.md` §7) |
| Repeat logic leaks into player flags | The pure state machine is built first, in Batch 3.1, precisely to prevent this |

## Release

Version `0.4.0+4`, tag `v0.4.0`, message `Phase 3 — Audio Engine`.
