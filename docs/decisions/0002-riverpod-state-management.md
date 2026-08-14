# 0002 — Riverpod for state management

**Status:** Accepted
**Date:** 2026-08-14

## Context

The brief specified matching the developer's existing fitness app for consistency.
That app uses Riverpod.

Independently, the requirement that the UI be redesigned later without disturbing
logic demands a state solution that cleanly separates a screen's state and behaviour
from its rendering, and that is testable without a widget tree.

## Decision

Riverpod, with `riverpod_generator`, using `Notifier` and `AsyncNotifier`.

Every screen is exactly two files — a controller (all state and logic, no `ui/`
imports) and a view (rendering only). Controllers are tested through
`ProviderContainer` with no widgets involved.

Feature controllers depend on abstract `domain/` repository interfaces, never on
concrete `data/` implementations, so tests substitute fakes by overriding one provider.

## Consequences

**Easy:** deleting and rewriting an entire screen's view without touching its logic or
its tests. Substituting fakes in tests. Compile-time safety on provider dependencies.

**Hard:** code generation adds a build step and `build_runner` watch to the dev loop.
Riverpod's learning curve is real, but the developer already has it.

**Accepted:** provider boilerplate in exchange for the redesign-safety the project
requires.

## Alternatives considered

**BLoC** — more boilerplate, no advantage here, and inconsistent with the developer's
other app.

**Provider** — lighter, but weaker testing ergonomics and no compile-time dependency
safety.

**setState / no library** — untenable given the amount of cross-screen state (playback,
plan, page states, download progress).
