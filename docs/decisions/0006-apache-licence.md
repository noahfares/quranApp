# 0006 — Apache-2.0 licence

**Status:** Accepted
**Date:** 2026-08-14

## Context

The brief specified MIT or Apache-2.0. Both are permissive, both are app-store
compatible, both suit a sadaqah jariyah project where the point is that others benefit
freely.

GPL was excluded upfront — it is why forking `quran_android` was rejected.

## Decision

**Apache-2.0** for the source code.

Bundled Quran assets — text, page images, fonts, coordinate databases — are **not**
covered by it. They carry their own upstream licences, reproduced in
`assets/licences/` and surfaced in the in-app About screen (`SET-08`).

`NOTICE` records third-party attributions. `LICENSE` carries the Apache text unmodified.

## Consequences

**Easy:** anyone may fork, adapt, or ship a derivative, including commercially. Given
the intent, that is the desired outcome — the more Quran apps that exist because of
this code, the better it has served its purpose.

**Hard:** nothing. Apache-2.0 is well understood and universally accepted.

**Accepted:** the explicit patent grant and the attribution requirements are slightly
heavier than MIT's, which is the reason to prefer it — the patent grant protects both
the developer and downstream users, and this project touches font and rendering
territory where that is not purely theoretical.

**Obligation:** the licence header requirement means the LICENSE and NOTICE files must
survive any repackaging, and asset attributions must remain visible in the app. This is
not optional and is verified before the v1.0.0 release in Phase 10.

## Alternatives considered

**MIT.** Shorter and marginally more permissive, but no patent grant. For a project
that will be forked by people with fewer legal resources than a company, the patent
grant is worth the extra length.

**GPL-3.0.** Would force derivatives to stay open, which has some appeal for a sadaqah
project. Rejected: it is incompatible with App Store distribution, which forecloses the
eventual iOS port and would prevent anyone else shipping a derivative to iOS either.
That is the opposite of the intent.
