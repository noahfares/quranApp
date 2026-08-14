# Workflow — Batches, Phases, Versions, Tags, CI

The rhythm of this project. Follow it exactly.

---

## 1. The two units of work

| Unit | Size | Produces | Triggers CI | Bumps version | Creates tag |
|---|---|---|---|---|---|
| **Batch** | Hours to a few days | A PR into `main` | Fast check only | No | No |
| **Phase** | 2–4 weeks part-time | A tagged release | Full pipeline | Yes | Yes |

A phase contains 4–8 batches. `docs/phases/phase-<N>-*.md` lists them.

## 2. Batch loop

```bash
git checkout main && git pull
```

```bash
git checkout -b phase-1/batch-1.3-highlight-overlay
```

1. Read the batch's section in the phase file. Scope is exactly what is written there.
2. Implement. Write tests alongside, not after.
3. Verify locally:

```bash
flutter analyze && flutter test && dart format --set-exit-if-changed .
```

4. Update `PROGRESS.md` — add a batch log row, advance current position.
5. Commit, push, open a PR titled `Batch <N.M> — <name>`.
6. The **PR fast check** runs: format, analyze, layering, unit tests. ~90 seconds.
7. Squash merge once green.

If a batch turns out to be larger than its description, **stop and say so** rather than
letting it sprawl. Split it and record the split in the phase file.

## 3. Phase completion

Only when every batch is merged and every item in the phase's Definition of Done is
satisfied.

```bash
git checkout main && git pull
```

**Step 1 — verify the phase is actually done.** Walk the phase file's DoD checklist
item by item. Do not tick anything you have not observed working. A phase closed on an
unverified DoD poisons every phase after it.

**Step 2 — bump the version** in `pubspec.yaml`:

```yaml
version: 0.2.0+2
```

The build number (`+N`) increments monotonically and never resets — Play Store requires
this. It equals the phase number plus one.

**Step 3 — write the changelog.** Add a `CHANGELOG.md` section for the version, in
Keep a Changelog format, describing user-visible change. "Refactored the scheduler" is
not a changelog entry; "Manzil reviews now group adjacent pages into one session" is.

**Step 4 — commit and push.**

```bash
git commit -am "chore(release): v0.2.0 — Mushaf Reader Core" && git push
```

**Step 5 — tag and push the tag.** This is what fires the release pipeline.

```bash
git tag -a v0.2.0 -m "Phase 1 — Mushaf Reader Core" && git push origin v0.2.0
```

**Step 6 — the release workflow runs automatically.** It verifies the tag matches
`pubspec.yaml`, runs the full test suite, builds a release APK and AAB, and publishes a
GitHub Release with the changelog section as the body and the APK attached.

**Step 7 — update `PROGRESS.md`**: mark the phase Complete, set the next phase to
Not started, update current version.

**Step 8 — manual smoke test** the attached APK on a real device before starting the
next phase. CI proves it builds; only a device proves it works.

### The version guard

`tool/verify_version.dart` asserts that the git tag equals the `pubspec.yaml` version.
The release workflow runs it first and fails immediately on mismatch. Version and tag
can never drift.

## 4. Version scheme

Pre-1.0, each completed phase is a minor bump.

| Phase | Version | Build |
|---|---|---|
| 0 | `v0.1.0` | `+1` |
| 1 | `v0.2.0` | `+2` |
| 2 | `v0.3.0` | `+3` |
| 3 | `v0.4.0` | `+4` |
| 4 | `v0.5.0` | `+5` |
| 5 | `v0.6.0` | `+6` |
| 6 | `v0.7.0` | `+7` |
| 7 | `v0.8.0` | `+8` |
| 8 | `v0.9.0` | `+9` |
| 9 | `v0.10.0` | `+10` |
| 10 | `v1.0.0` | `+11` |
| 11 | `v1.1.0` | `+12` |

`v1.0.0` is the Android Play Store release. `v1.1.0` adds iOS (ADR `0007`); it is a
minor bump rather than a major one because nothing changes for existing users.

After v1.0.0, standard semver: patch for fixes, minor for features, major for breaking
changes to user data or a full redesign.

A hotfix between phases gets a patch bump (`v0.4.1`), its own tag, and its own release.
It follows the same steps 2–7.

## 5. CI policy

**Two workflows, and no others.**

### `pr-check.yml` — fast, on every PR

Triggers: `pull_request` against `main`.

Runs: `dart format --set-exit-if-changed`, `flutter analyze`,
`dart run tool/verify_layering.dart`, `flutter test`.

Target: under 2 minutes. This exists so a broken `main` is caught in minutes rather
than surviving a dozen batches until the next phase-end pipeline.

### `release.yml` — full, on version tags and on demand

Triggers: `push` of a tag matching `v*`, and `workflow_dispatch` (the manual button on
the Actions tab).

Runs: version guard, checksum verification, format, analyze, layering, full test suite
including golden tests, `flutter build apk --release`,
`flutter build appbundle --release`, then creates the GitHub Release.

**There is no push-triggered CI on `main` and no scheduled CI.** This is deliberate:
CI runs at phase ends, when manually requested, and on PRs. Nowhere else.

### Requesting a CI run mid-phase

Use the manual trigger:

```bash
gh workflow run release.yml --ref main
```

A `workflow_dispatch` run on an untagged ref builds and tests but does not create a
release or a tag. Use it before a long manual test session or when you want a build
artifact without closing a phase.

## 6. Branch protection on `main`

Configure once, in Batch 0.6:

- Require a pull request before merging.
- Require `pr-check` to pass.
- No force pushes, no deletion.
- Linear history (squash merges only).

## 7. Issues and project tracking

GitHub Issues are optional for a solo developer, and the phase files already carry the
scope. Use issues only for:

- Bugs found during manual testing that are not fixed immediately.
- Ideas that arrive mid-phase and must not derail the current one. Label `post-v1` and
  move on.

Label set: `phase-0`…`phase-10`, `post-v1`, `bug`, `blocked`, `assets`, `legal`.

## 8. When something goes wrong

| Situation | Action |
|---|---|
| Tagged the wrong commit | Delete the tag locally and remotely, retag correctly. Only safe if no release was published. |
| Release published with a bad build | Do not delete it. Ship `v0.N.1` with the fix. |
| A batch is blocked | Mark it `Blocked` in `PROGRESS.md` with the reason, move to the next independent batch. Never leave a blocker undocumented. |
| A phase's DoD cannot be met | Do not close the phase. Either descope it explicitly in the phase file with a written reason, or extend it. Never tag a phase whose DoD is unmet. |
