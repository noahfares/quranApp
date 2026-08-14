# Post-v1

Everything deliberately deferred past `v1.0.0`.

**Read this before adding a feature mid-phase.** If it is on this list, it is already
decided and the answer is "not yet". Log it and move on.

Ordering below is by expected value, not by ease.

---

> **The iOS port is no longer here.** It is now Phase 11, shipping as `v1.1.0` —
> see [phase-11-ios-release.md](phase-11-ios-release.md) and ADR `0007`.

## Tier 1 — the obvious next releases

### Mutashabihat warnings — `DRL-07`

The single most requested feature in hifz circles and almost no free app has it. Near-
identical ayahs across surahs are the primary source of hifz errors, and being warned
"this resembles 2:35 — the difference is one word" at the moment of review is
genuinely valuable.

Blocked on data sourcing: a reliable, licensed dataset of mutashabihat pairs with
difference annotations. Several exist in academic and community form; none has been
verified for licence or accuracy yet. **That verification is the actual work** — the
UI is trivial once the data exists.

Deferred from v1 for data reasons only, not product ones. It would otherwise be a
Phase 8 feature.

### Text search — `NAV-07` `NAV-08`

Arabic text search with diacritic-insensitive matching, plus translation search.
Requires a normalisation strategy that never mutates the stored text
(`docs/02-data-sources.md` §1) — search over a derived index, never over modified
source.

### Word-level highlighting — `MUS-11`

If the glyph renderer shipped in Phase 9, this is nearly free and should have landed
already. If the image renderer is still the only one, it requires the word coordinate
DB and remains approximate.

Depends on word-level audio timings (`AUD-12`), available for some reciters.

---

## Tier 2 — substantial additions

### Tafsir

Excluded from v1 by the brief. Tafsir is a large content problem, not a technical one:
selection, licensing, sizing, translation quality, and the responsibility of presenting
religious commentary correctly. Ibn Kathir and Ma'ariful Quran are the usual starting
points.

Approach it as a content project with scholarly review, not as a feature sprint.

### Multiple qira'at

Hafs only in v1. Warsh and Qalun require different page images or different glyph
fonts, different audio, and different ayah numbering in places. Substantial, and the
audience is regional — worth doing for North and West African users specifically.

### Cloud sync — `SET-12`

Deliberately excluded from v1 and it should stay excluded for as long as possible.

It breaks the offline-first, no-backend, no-account constraint that defines the app.
The problem it solves — data loss — is already addressed by backup and restore
(`SET-01`–`SET-03`).

If it is ever built, the right shape is user-owned storage: their Google Drive, their
Nextcloud, their file. Never a server operated by this project, which would create
running costs, a privacy surface, and an operational burden that a free sadaqah project
cannot sustain. An account system in particular would be a mistake.

### Voice-based memorization checking

Excluded from v1. Tarteel does this well and it is genuinely hard: Quranic Arabic ASR,
tajweed-aware scoring, and on-device inference if it is to stay offline.

The honest assessment is that doing this badly is worse than not doing it — telling
someone their recitation was wrong when it was right undermines the whole app. Attempt
only with a properly evaluated on-device model.

### Personal FSRS parameter training — `HFZ-15`

Excluded from v1 because a single user's review counts are too low to fit meaningfully.
Revisit once a user has 1000+ reviews. Must remain on-device — no review data ever
leaves the phone.

---

## Tier 3 — smaller improvements

- Widgets: today's plan on the home screen
- Wear OS companion for review streak and quick grading
- Android Auto for audio playback
- Multiple user profiles on one device — for families and for teachers
- Custom mushaf layouts: Indo-Pak, Warsh, 15-line
- Import and export of hifz plans between users
- Tajweed colour-coding on the mushaf page
- Additional reciters, including per-reciter download management
- Notes and reflections per ayah, private
- Dua and dhikr companion sections
- Hijri calendar integration for Ramadan-specific plans

---

## Permanently excluded

Not deferrals. These are what the product is defined against (`docs/00-brief.md` §6).

- Social features, friend lists, leaderboards, public profiles
- Advertising or monetisation of any kind
- Analytics, telemetry, or usage tracking
- Mandatory accounts or sign-in
- Anything that makes the app require a network connection to function

If a future feature requires any of the above, the feature is wrong, not the boundary.

---

## Adding to this file

When an idea arrives mid-phase: add it here with one line on what it is and one on why
it is not now. Do not expand the current phase. That discipline is the only reason a
solo part-time project ships at all.
