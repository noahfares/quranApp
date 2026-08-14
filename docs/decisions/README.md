# Architecture Decision Records

One file per decision that would be expensive to reverse. Numbered, immutable.

**To change a decision:** do not edit the original ADR. Write a new one that states
what it supersedes, and mark the old one `Superseded by NNNN`. The reasoning behind a
reversed decision is often more valuable than the decision itself.

Naming: `NNNN-short-slug.md`

| # | Decision | Status |
|---|---|---|
| [0001](0001-mushaf-renderer-abstraction.md) | Mushaf renderer abstraction; image default, glyph spike | Accepted |
| [0002](0002-riverpod-state-management.md) | Riverpod for state management | Accepted |
| [0003](0003-fsrs-departures.md) | FSRS with interval cap, contiguity batching, cyclical alternative | Accepted |
| [0004](0004-defer-ios.md) | Defer iOS to post-v1 | **Superseded by 0007** |
| [0005](0005-ci-policy.md) | CI on PRs and version tags only | Accepted |
| [0006](0006-apache-licence.md) | Apache-2.0 licence | Accepted |
| [0007](0007-ios-in-scope.md) | iOS in scope; Android releases first | Accepted |
| `0008` | QPC glyph spike outcome — reserved, written in Batch 1.6 | Pending |

## Template

```markdown
# NNNN — Title

**Status:** Proposed | Accepted | Superseded by NNNN
**Date:** YYYY-MM-DD

## Context
What forced a decision. The constraints in play.

## Decision
What we chose, stated plainly.

## Consequences
What this makes easy. What this makes hard. What we accept.

## Alternatives considered
What else was on the table and why it lost.
```
