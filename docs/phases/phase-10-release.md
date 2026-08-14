# Phase 10 — Hardening & Play Store Release

| | |
|---|---|
| **Version on completion** | `v1.0.0` (`+11`) |
| **Depends on** | All prior phases |
| **Estimate** | 3–4 weeks part-time |
| **Status** | Not started |

## Objective

Take a feature-complete app and make it a shippable one. No new features. This phase is
about correctness, performance, polish, and the obligations that come with publishing.

**If you find yourself adding a feature in this phase, stop.** Log it as post-v1 and
move on. Scope creep at the release phase is how projects fail to ship at all.

## In scope

Bug fixing, performance, accessibility, legal obligations, store listing, release.

## Out of scope

Every feature not already shipped. All of them.

---

## Batches

### Batch 10.1 — Full manual test pass

**Goal:** find what the tests did not.

Tasks:
- Write a test script covering every user flow, and execute it in full.
- Test on at least three physical devices: a low-end device, a mid-range device, and a
  large-screen or tablet device. **The low-end device is the one that matters** —
  memory pressure, slow storage, and aggressive battery management all surface there.
- Test every state: fresh install, mid-hifz, complete hifz, paused, no network, no
  storage, permissions refused.
- Test upgrade paths: install `v0.9.0`, use it, upgrade to `v1.0.0`, confirm data
  survives.
- Log every issue found. Fix them, or explicitly defer with a reason.

**Done when:** the full script passes on all three devices; the upgrade path preserves
data; every logged issue is fixed or consciously deferred.

### Batch 10.2 — Performance

**Goal:** it must feel smooth, because a Quran app that stutters feels disrespectful.

Tasks:
- Profile: app startup, page swiping, heatmap scrolling, session transitions, audio
  start latency.
- Startup under 2 seconds on a mid-range device, cold.
- No dropped frames while swiping the mushaf.
- Memory bounded across 100+ page navigations and long audio sessions.
- Check battery drain across an hour of audio playback.
- Reduce APK/AAB size — Play Asset Delivery for page images if it helps materially.

**Done when:** all targets met on a mid-range device and the app remains usable on the
low-end one.

### Batch 10.3 — Accessibility and localisation readiness

**Goal:** meet the bar set in `docs/03-conventions.md` §10.

Tasks:
- Screen reader pass over every screen; every interactive element labelled.
- Touch targets at least 48×48 dp throughout.
- Contrast verified at WCAG AA in all three themes.
- Text scaling verified at maximum system font size, mushaf page excepted.
- Confirm every user-facing string is in the ARB file with no literals remaining.
- Verify RTL layout correctness throughout, not only in the mushaf — this app will
  have Arabic and Urdu speakers using an RTL device locale.

**Done when:** the app is fully navigable with a screen reader; no contrast or touch
target failures; no hardcoded strings remain.

### Batch 10.4 — Legal and attribution

**Goal:** every obligation met before publishing.

Tasks:
- Re-verify every asset licence and confirm the bundled versions match what was
  approved in Batch 0.4.
- Confirm `assets/ATTRIBUTION.md` is complete and the About screen renders it fully.
- Verify `LICENSE` and `NOTICE` are correct and present.
- Audit dependency licences. **No GPL.**
- **Contact every audio CDN in use** (`docs/02-data-sources.md` §7) and record the
  responses. Do not release before doing this — it is a courtesy to volunteers donating
  bandwidth, and it protects against being blocked after launch.
- Write a privacy policy. It is short and unusually pleasant to write: the app collects
  nothing, transmits nothing, and has no accounts. Play Store requires one regardless.
- Complete the Play Store Data Safety declaration accurately.

**Done when:** every licence verified, all CDN responses recorded, privacy policy
published, Data Safety form complete and accurate.

### Batch 10.5 — Store listing and release preparation

**Goal:** everything Play Store requires.

Tasks:
- App name, short description, full description. Lead with what it is — a free,
  offline hifz companion — not with a feature list.
- Screenshots on real devices in all three themes. Feature graphic. Icon at all
  required densities.
- Content rating questionnaire.
- Choose the publishing identity — personal, masjid, or nonprofit (`PROGRESS.md`
  decision #2). **Resolve this before creating the listing**; changing a developer
  account later is painful.
- Set up a closed testing track first. Ship to a handful of real users, including at
  least one active hafiz, and act on their feedback before public release.
- Prepare release notes.

**Done when:** the listing is complete, closed testing has run for at least two weeks
with real users, and their feedback is addressed or logged.

### Batch 10.6 — Release

**Goal:** v1.0.0, publicly available.

Tasks:
- Final full regression pass.
- Follow `docs/04-workflow.md` §3 for version, changelog, tag, and release.
- Upload the AAB to Play Store production.
- Tag the repository release as `v1.0.0` with complete notes.
- Update `README.md` with the store link, screenshots, and build instructions.
- Confirm the release APK from CI matches what was uploaded.
- **Verify the keystore is backed up in at least two places.** Losing it means never
  being able to update the app again.

**Done when:** the app is live on Play Store, the GitHub release is published, and the
repository is presentable to a stranger who might want to contribute.

---

## Phase Definition of Done

- [ ] Full manual test script passes on three physical devices including a low-end one
- [ ] Upgrade from `v0.9.0` preserves all user data
- [ ] Startup under 2 seconds; no dropped frames while swiping
- [ ] Memory bounded across extended sessions
- [ ] Screen reader navigable; WCAG AA contrast; 48dp touch targets
- [ ] RTL layout correct throughout
- [ ] Every asset licence re-verified; attribution complete in-app
- [ ] Every audio CDN contacted and responses recorded
- [ ] Privacy policy published; Data Safety declaration accurate
- [ ] No GPL dependencies
- [ ] Closed testing run for two weeks with real users, including a hafiz
- [ ] Store listing complete
- [ ] Keystore backed up in at least two places
- [ ] Live on Play Store
- [ ] `README.md` presentable to a potential contributor
- [ ] `PROGRESS.md` updated; all phases marked Complete

## Risks

| Risk | Mitigation |
|---|---|
| Scope creep delays release indefinitely | No features in this phase. Log to post-v1 and move on. |
| Play Store rejection | Data Safety and privacy policy done early in the phase, not at the end |
| Low-end device performance unacceptable | Test on one from Batch 10.1, not at the end |
| A CDN objects after launch | Contact them in Batch 10.4, before |
| Keystore lost | Backed up in Batch 0.6, re-verified here |

## Release

Version `1.0.0+11`, tag `v1.0.0`, message `v1.0.0 — Initial public release`.

May Allah accept it.
