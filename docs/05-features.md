# Feature Catalogue

Every feature has a stable ID. Phase files reference these IDs rather than restating
behaviour, so a feature's definition lives in exactly one place.

Status: **v1** (ships in 1.0.0) · **cond** (conditional, see note) · **post** (post-v1)

---

## Mushaf reader — `MUS`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `MUS-01` | Render any of the 604 pages faithfully | v1 | 1 |
| `MUS-02` | Tap an ayah to select it | v1 | 1 |
| `MUS-03` | Highlight the selected ayah | v1 | 1 |
| `MUS-04` | Swipe between pages, both directions, RTL-correct | v1 | 1 |
| `MUS-05` | Pinch to zoom and pan within a page | v1 | 2 |
| `MUS-06` | Dark mode and sepia mode applied to the page | v1 | 2 |
| `MUS-07` | Long-press an ayah for a context menu (play, copy, bookmark, mark weak) | v1 | 2 |
| `MUS-08` | Two-page landscape spread | v1 | 2 |
| `MUS-09` | Keep-screen-awake while reading | v1 | 2 |
| `MUS-10` | Glyph renderer with font-size control | cond | 1 spike |
| `MUS-11` | Word-level highlighting | cond | — |
| `MUS-12` | Copy ayah text to clipboard | cond | 2 |

`cond` = depends on the QPC glyph spike (Batch 1.6). `MUS-11` and `MUS-12` are
impossible under the image renderer and nearly free under the glyph renderer.

## Navigation — `NAV`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `NAV-01` | Jump to page number | v1 | 2 |
| `NAV-02` | Surah index with Arabic and transliterated names | v1 | 2 |
| `NAV-03` | Juz and hizb index | v1 | 2 |
| `NAV-04` | Jump to a specific ayah reference | v1 | 2 |
| `NAV-05` | Bookmarks, named and unlimited | v1 | 2 |
| `NAV-06` | Last-read position restored on launch | v1 | 2 |
| `NAV-07` | Search Arabic text | post | — |
| `NAV-08` | Search translations | post | — |

## Audio — `AUD`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `AUD-01` | Stream per-ayah recitation | v1 | 3 |
| `AUD-02` | At least three reciters | v1 | 3 |
| `AUD-03` | Auto-highlight and auto-scroll to the playing ayah | v1 | 3 |
| `AUD-04` | Background playback with lock-screen controls | v1 | 3 |
| `AUD-05` | Repeat one ayah N times | v1 | 3 |
| `AUD-06` | Repeat an ayah range | v1 | 3 |
| `AUD-07` | Silent pause between repeats, configurable length | v1 | 3 |
| `AUD-08` | Playback speed 0.5×–2× | v1 | 3 |
| `AUD-09` | Download a surah or juz for offline playback | v1 | 9 |
| `AUD-10` | Resume from interruption (call, headphone unplug) | v1 | 3 |
| `AUD-11` | Sleep timer | v1 | 9 |
| `AUD-12` | Word-level audio sync | post | — |

## Memorization engine — `HFZ`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `HFZ-01` | Page state for all 604 pages | v1 | 4 |
| `HFZ-02` | FSRS scheduler for manzil | v1 | 4 |
| `HFZ-03` | Maximum interval cap, configurable | v1 | 4 |
| `HFZ-04` | Contiguity batching — group adjacent due pages into one block | v1 | 4 |
| `HFZ-05` | Cyclical manzil mode as an alternative to FSRS | v1 | 4 |
| `HFZ-06` | Sabaq track — daily new-memorization target | v1 | 5 |
| `HFZ-07` | Sabqi track — rolling recent-pages window | v1 | 5 |
| `HFZ-08` | Daily plan generator combining all three tracks | v1 | 5 |
| `HFZ-09` | Review session: show, hide, grade | v1 | 5 |
| `HFZ-10` | Four grades — Again, Hard, Good, Easy | v1 | 5 |
| `HFZ-11` | Weak-spot capture — tag the ayah you slipped on | v1 | 5 |
| `HFZ-12` | Set a start point (already-memorized juz) during onboarding | v1 | 5 |
| `HFZ-13` | Pause and resume hifz (travel, illness, menses) without penalty | v1 | 5 |
| `HFZ-14` | Adjust daily load — pages per day, rest days | v1 | 5 |
| `HFZ-15` | Personal FSRS parameter training | post | — |

`HFZ-13` matters more than it looks. Every hifz app punishes a break with an
avalanche of overdue reviews, and users abandon the app rather than face it. An
explicit pause that freezes scheduling, plus a graduated catch-up on resume, is a
retention feature.

## Drills — `DRL`

The features that differentiate this app. All operate on `MushafRenderer.boxes()` and
therefore work under both renderers.

| ID | Feature | Status | Phase |
|---|---|---|---|
| `DRL-01` | Peek/reveal — hide the page, show only each ayah's first word, tap to reveal | v1 | 8 |
| `DRL-02` | Progressive fade — slider from full text to blank | v1 | 8 |
| `DRL-03` | Audio gap mode — reciter recites, falls silent for your ayah, resumes | v1 | 8 |
| `DRL-04` | Page-transition drill — last ayah of page N into first of N+1 | v1 | 8 |
| `DRL-05` | Weak-spot drill — review only ayahs tagged weak | v1 | 8 |
| `DRL-06` | First-ayah-of-page recall drill | v1 | 8 |
| `DRL-07` | Mutashabihat warnings — flag near-identical ayahs | post | — |

`DRL-03` is the highest-value item in this table. It is the only way to practise alone
at recitation speed, and no free app does it well.

## Progress — `PRG`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `PRG-01` | 604-page heatmap by status | v1 | 6 |
| `PRG-02` | 30-juz summary view | v1 | 6 |
| `PRG-03` | Surah-level breakdown | v1 | 6 |
| `PRG-04` | Overall percentage memorized | v1 | 6 |
| `PRG-05` | Review history calendar | v1 | 6 |
| `PRG-06` | Personal streak, private | v1 | 6 |
| `PRG-07` | Projected completion date from current pace | v1 | 6 |
| `PRG-08` | Khatm counter — completed revision cycles | v1 | 6 |
| `PRG-09` | Halaqah report — exportable PDF progress summary for a teacher | v1 | 9 |

## Notifications — `NTF`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `NTF-01` | Prayer-anchored reminders, e.g. "20 min after Fajr" | v1 | 7 |
| `NTF-02` | Precomputed text, scheduled 7–14 days ahead | v1 | 7 |
| `NTF-03` | Re-arm after device boot | v1 | 7 |
| `NTF-04` | Reliability diagnostic screen with per-brand guidance | v1 | 7 |
| `NTF-05` | Per-track reminder configuration | v1 | 7 |
| `NTF-06` | Quiet hours | v1 | 7 |
| `NTF-07` | Location for prayer times, manual or GPS, offline after first set | v1 | 7 |
| `NTF-08` | Calculation method and madhhab selection | v1 | 7 |

## Data & settings — `SET`

| ID | Feature | Status | Phase |
|---|---|---|---|
| `SET-01` | Backup to a user-chosen file | v1 | 9 |
| `SET-02` | Restore from a backup file | v1 | 9 |
| `SET-03` | Backup reminder if the last one is over 30 days old | v1 | 9 |
| `SET-04` | Theme selection — light, dark, sepia, system | v1 | 9 |
| `SET-05` | Reciter selection | v1 | 3 |
| `SET-06` | Asset download manager with progress and cancellation | v1 | 9 |
| `SET-07` | Translation selection, downloaded on demand | v1 | 9 |
| `SET-08` | About screen with full attribution | v1 | 0 |
| `SET-09` | Renderer selection, if the glyph spike succeeded | cond | 9 |
| `SET-10` | Day-boundary setting, default Fajr | v1 | 9 |
| `SET-11` | Full data wipe with confirmation | v1 | 9 |
| `SET-12` | Cloud sync | post | — |

`SET-01` through `SET-03` are v1 blockers, not polish. With no cloud sync, a lost
phone destroys years of hifz records. That is a genuine harm to a user, not an
inconvenience, and it ships in Phase 9 without negotiation.
