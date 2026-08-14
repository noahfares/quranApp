# 0001 — Mushaf renderer abstraction; image renderer default, glyph spike

**Status:** Accepted
**Date:** 2026-08-14

## Context

Flutter's text engine has known defects rendering stacked Arabic diacritics. Rendering
Quranic Arabic through it will not match the printed mushaf, and for this audience an
imperfect mushaf is disqualifying.

Two approaches avoid the engine entirely:

**Page images plus a coordinate database.** Display the scanned mushaf page, read ayah
and word boxes from the `ayahinfo` DB, paint highlights with a `CustomPainter`,
hit-test the same boxes. Proven — this is what `quran_android` has always done.

**QPC glyph fonts.** Per-page fonts where each PUA codepoint maps to one pre-shaped
word glyph from the printed plates. No Arabic shaping happens at render time, so the
Flutter defect does not apply. This is what Quran.com and Tarteel use today.

| | Images | Glyph fonts |
|---|---|---|
| Fidelity | Perfect | Perfect (same plates) |
| Bundle size | 150–250 MB | ~25–45 MB |
| Font resizing | Impossible | Free |
| Dark/sepia mode | Blend filter over a bitmap; compromised | Free — it is text colour |
| Word-level highlight | Approximate, needs word-box DB | Free, per glyph |
| Text selection and copy | Impossible | Free |
| Accessibility | None | Possible |
| Proven in Flutter | Yes | Less so |
| Main risk | Size; no theming | Line justification |

The glyph approach is better on nearly every axis, but its hard problem —
justifying each line to the exact page width, which requires line-by-line rendering
with controlled stretching rather than paragraph layout — is unproven for this
codebase and could consume a phase if it fails.

## Decision

Define a `MushafRenderer` interface in Phase 1 with two implementations.

1. Build and ship `ImageMushafRenderer` first. It is the proven path and it satisfies
   every v1 requirement.
2. Run a **timeboxed spike** on `GlyphMushafRenderer` in the same phase (Batch 1.6,
   5 working days, hard stop).
3. If the spike proves justification works, the glyph renderer becomes the default in
   Phase 9 and the image renderer remains as a fallback and as a low-end-device option.
   If it fails, the spike is recorded and abandoned at no further cost.

All highlight, mask, fade, and hit-test logic lives **above** the interface, driven by
`boxes()`. Neither implementation owns it.

## Consequences

**Easy:** changing the rendering strategy later, without touching drills, highlighting,
audio sync, or any screen. Every drill feature (`DRL-01` to `DRL-06`) works under both
renderers for free because they all consume `boxes()`.

**Hard:** the interface must be designed for the harder implementation from day one.
Getting it wrong means the glyph renderer does not fit and the abstraction was wasted.

**Accepted:** roughly one extra week in Phase 1. This buys the option to change the
single most consequential rendering decision in the app without a rewrite, which is
worth considerably more than a week.

**Conditional scope:** `MUS-10`, `MUS-11`, `MUS-12` and `SET-09` are gated on the
spike outcome. Word-level highlighting is a v1 non-goal under the image renderer and is
reconsidered only if the spike succeeds.

## Alternatives considered

**Images only, as originally briefed.** Lowest risk, but permanently forecloses font
sizing, good dark mode, text selection, and word-level highlight — and locks in a
150–250 MB install that will be a real adoption cost in the markets that matter most
for this app.

**Glyph fonts only.** Best outcome if it works, but a mid-phase failure with no
fallback would cost weeks and there is no proven Flutter reference implementation to
fall back on.

**Flutter text with a Uthmani font.** Rejected outright. This is the failure mode the
whole decision exists to avoid.
