# 0004 — Defer iOS to post-v1

**Status:** Superseded by [0007](0007-ios-in-scope.md)
**Date:** 2026-08-14
**Superseded:** 2026-08-14

> **This decision was reversed the same day it was made.** The reasoning below about
> *testing* was sound and its two insurance measures were kept — the 64-item
> notification budget and the abstracted storage paths, both of which survive into the
> current plan. The reasoning about *market* was wrong: it treated iOS as a rounding
> error based on Android's dominance in Muslim-majority countries, and missed that an
> English-language hifz app's core audience is Western diaspora, where iOS is roughly
> half the market. See [0007](0007-ios-in-scope.md).
>
> Retained because the failure mode is worth remembering: a logistics constraint (no
> Mac) was allowed to silently determine product scope.

## Context

The brief specified building Android and iOS together from week 1, testing on the iOS
simulator continuously and on a real device after milestones 1, 2, and 5.

iOS builds require macOS. The developer has no Mac access.

Without a Mac, "supporting iOS" would mean writing iOS code that is never compiled,
never run, and never tested. That is not support — it is speculation that accumulates
silently until someone finally builds it, at which point every accumulated assumption
fails at once.

## Decision

**v1.0.0 ships on Android only.** iOS is a post-v1 phase, undertaken when Mac access
exists.

Meanwhile, the codebase stays iOS-*safe* without being iOS-*tested*:

- No Android-only APIs in `domain/` or in any repository interface.
- `data/platform/paths.dart` abstracts storage locations now, with the iOS branch
  written and documented but unexercised.
- The notification scheduler tracks its pending count against a configurable budget
  (default 64, the iOS limit) so no redesign is needed later.
- Plugin choices remain ones with working iOS support.
- No platform channels without an explicit note on what iOS would require.

What is dropped: iOS simulator testing from phase acceptance criteria, real-device
checkpoints, App Store submission work, and the 99 USD/year developer fee from the v1
budget.

## Consequences

**Easy:** every phase gets simpler. Audio session handling, notification permissions,
background modes, and file storage — the four areas where iOS diverges most and where
simulators give misleading results anyway — are single-platform problems for v1.

**Hard:** the eventual iOS port is a real project, estimated 4–6 weeks. Audio session
categories, notification authorisation flow, background audio entitlements, the 64
notification cap under real conditions, and the do-not-backup flag on downloaded assets
all need genuine device testing that cannot be front-run.

**Accepted:** iOS users wait. Given that this is a free solo-developer project and
Android has the larger share in the regions where this app is most needed, that is the
right order regardless of the Mac constraint.

**Timeline:** the brief's 5–7 month estimate included iOS. Android-only v1.0.0 is
estimated 4–6 months part-time.

## Reversal condition

If Mac access is obtained before Phase 8, reconsider. Reintroducing iOS before the UI
phases is far cheaper than after — the notification and audio work in Phases 3 and 7 is
where platform divergence actually bites. After Phase 8, finish v1 on Android and treat
iOS as its own project.

## Alternatives considered

**Cloud macOS CI for build verification only.** Confirms it compiles. Does not confirm
audio sessions, notification delivery, or file storage behave — the only things that
actually matter. Not worth the setup cost for a build-only signal, though the release
workflow can add a macOS build job cheaply once a port begins.

**Buy a used Mac mini.** Reasonable at some point, but this is a zero-revenue sadaqah
project and that decision is the developer's, not the plan's.
