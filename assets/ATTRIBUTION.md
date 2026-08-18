# Attribution

This screen lists every third-party source Hifz uses or intends to use, and the
verification status of each. Per docs/02-data-sources.md, nothing is bundled until its
row reads verified — see the status column below.

**No Quran text, page image, font, or coordinate database is bundled in this build.**
Research so far (Batch 0.4) is recorded per-source below; verification is not yet
complete for any of them. See `PROGRESS.md` for the full writeup and open blockers.

| Source | Used for | Status |
|---|---|---|
| Tanzil.net | Arabic Quran text (Uthmani) | Researched, not verified — see note |
| King Fahd Glorious Qur'an Printing Complex (KFGQPC) | Mushaf page fonts/images | Researched, not verified — see note |
| `quran/quran.com-images` (GitHub) | Page image generation | Not a data source — it is a build toolchain, not a downloadable image set (see note) |
| `quran/ayah-detection` (GitHub) | Ayah coordinate detection | Not a data source — it is a build toolchain, not a downloadable database (see note) |
| Quranic Universal Library (QUL) / quran.foundation | Fonts, translations, timing data | Not yet researched |
| everyayah.com / Islamic Network CDN | Streamed per-ayah audio | Not yet contacted — required before v1.0.0, not before development |
| `adhan` (Dart package) | Prayer time calculation | MIT — verified, code dependency only |

## Notes

**Tanzil.net Arabic text.** Publicly documented (via secondary sources — see
`PROGRESS.md`) as distributed under a Tanzil-specific licence resembling
CC BY 3.0: verbatim copying is permitted, modification is not, and use requires
attribution to Tanzil.net with a link back to tanzil.net. This session could not reach
tanzil.net directly (blocked by this environment's network egress policy) to fetch and
verify the licence text verbatim, so it is not yet copied into `assets/licences/` and no
text file is bundled.

**KFGQPC fonts and mushaf page imagery.** Publicly documented (via secondary sources)
as free to use, copy, and distribute, with no modification, reverse engineering, or
resale permitted, copyright retained by KFGQPC. This session could not reach
qul.tarteel.ai directly (blocked by this environment's network egress policy) to fetch
and verify the licence text verbatim.

**`quran/quran.com-images` and `quran/ayah-detection`.** docs/02-data-sources.md lists
these as the bundled sources for page images and the ayah coordinate database. Both
were fetched and read in full during this batch: neither is a dataset. `quran.com-images`
is a Perl/MySQL pipeline that *generates* page images from KFGQPC's proprietary font and
data files (not included in the repo); `ayah-detection` is a Python pipeline that
*detects* ayah boundaries from already-generated images. Actually obtaining bundleable
page images or a coordinate database means either running one of these pipelines
end-to-end against the underlying KFGQPC assets, or finding a different, actual
pre-generated dataset — neither of which this session could do. This needs a decision
from the project owner; see `PROGRESS.md` blockers.

Where a licence cannot be verified, this app does not bundle the asset. See
docs/02-data-sources.md §3.
