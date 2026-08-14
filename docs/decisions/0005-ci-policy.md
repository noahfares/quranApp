# 0005 — CI on pull requests and version tags only

**Status:** Accepted
**Date:** 2026-08-14

## Context

The requirement was that CI run at the end of each phase, when manual testing is
needed, or on explicit request — not on every push.

That is a defensible policy for a solo developer: it keeps CI minutes near zero and
avoids notification noise from a pipeline nobody is watching. But taken literally it
has a real failure mode. Batches merge to `main` over two to four weeks with nothing
verifying them, so a regression can survive a dozen merges before the phase-end
pipeline finds it — at which point bisecting it is far more expensive than catching it
at the PR.

## Decision

Two workflows.

**`pr-check.yml`** — triggers on `pull_request` against `main`. Two parallel jobs:

- **check** (Ubuntu) — format, `flutter analyze`, the layering verifier, unit tests.
  Under two minutes. No build, no golden tests, no artifacts.
- **ios-build** (macOS) — an unsigned iOS build, nothing more. Added under ADR `0007`
  so the iOS target cannot silently rot between Phase 0 and Phase 11. Takes 10–15
  minutes, but runs in parallel and does not gate the fast feedback from **check**.

**The iOS job depends on this repository staying public.** macOS runner minutes are
free for public repositories and billed at 10× for private ones. If the repository ever
goes private, drop that job rather than absorb the cost.

**`release.yml`** — triggers on a pushed tag matching `v*`, and on
`workflow_dispatch`. Runs the version guard, checksum verification, the full test suite
including goldens, then builds a release APK and AAB plus an unsigned iOS build, and
publishes a GitHub Release with the changelog section as its body. iOS signing and
TestFlight upload are added in Batch 11.1.

Nothing else. **No push trigger on `main`, and no scheduled runs.**

The manual trigger is the "when I request it" path:

```bash
gh workflow run release.yml --ref main
```

Dispatched on an untagged ref, it builds and tests but publishes nothing — useful for
producing an APK before a manual test session without closing a phase.

## Consequences

**Easy:** a broken `main` surfaces within minutes at the PR that caused it, while the
change is still in working memory. Phase-end releases stay a deliberate, heavyweight,
infrequent event.

**Hard:** nothing meaningful. The PR check is short enough not to interrupt flow.

**Accepted:** a small amount of CI usage per PR — roughly 90 seconds — against the
literal "phase ends only" reading. The tradeoff was raised and approved on 2026-08-14.

**Requires:** branch protection on `main` requiring `pr-check` to pass, and no direct
pushes. Configured in Batch 0.6. Without that, the PR check is advisory and the failure
mode returns.

## Alternatives considered

**Strictly phase-end and manual only, as first stated.** Zero incidental CI usage, but
reintroduces the multi-week detection gap. Presented to the developer; not chosen.

**CI on every push to every branch.** Noisy, wasteful, and produces failure
notifications for work-in-progress commits that nobody should act on.

**Local pre-commit hooks instead of CI.** Faster feedback, but silently skippable and
they do not verify in a clean environment. Useful as an addition, not a substitute.
