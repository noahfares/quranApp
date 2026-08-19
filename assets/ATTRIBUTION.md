# Attribution

This screen lists every third-party source Hifz uses or intends to use, and the
verification status of each. Per docs/02-data-sources.md, nothing is bundled until its
row reads verified — see the status column below.

**No Quran text, page image, font, or coordinate database is bundled in this build yet.**
Research so far (Batch 0.4) is recorded per-source below. See `PROGRESS.md` for the
full writeup and open blockers.

| Source | Used for | Status |
|---|---|---|
| Tanzil.net | Arabic Quran text (Uthmani) | **Licence verified** — text file not yet bundled, see note |
| King Fahd Glorious Qur'an Printing Complex (KFGQPC) | Mushaf page fonts/images | Researched, not verified — see note |
| `quran/quran.com-images` (GitHub) | Page image generation | Not a data source — it is a build toolchain, not a downloadable image set (see note) |
| `quran/ayah-detection` (GitHub) | Ayah coordinate detection | Not a data source — it is a build toolchain, not a downloadable database (see note) |
| Quranic Universal Library (QUL) / quran.foundation | Fonts, translations, timing data | Not yet researched |
| everyayah.com / Islamic Network CDN | Streamed per-ayah audio | Not yet contacted — required before v1.0.0, not before development |
| `adhan` (Dart package) | Prayer time calculation | MIT — verified, code dependency only |

## Notes

**Tanzil.net Arabic text — verified.** The licence text (Creative Commons Attribution
3.0) was fetched from tanzil.net/docs/text_license by the project owner and copied
verbatim into `assets/licences/tanzil-text.txt`. Terms: verbatim copying permitted,
modification is not, and use requires attribution to Tanzil Project with a link back to
tanzil.net; the copyright notice must be reproduced in derived files. The actual text
file (e.g. `quran-uthmani.txt` from tanzil.net/download) still needs to be downloaded
and added to `assets/quran/` before it's bundled and checksummed — see
`PROGRESS.md` blocker #5.

**KFGQPC fonts and mushaf page imagery.** Publicly documented (via secondary sources)
as free to use, copy, and distribute, with no modification, reverse engineering, or
resale permitted, copyright retained by KFGQPC. A prior session could not reach
qul.tarteel.ai directly (blocked by that environment's network egress policy). A later
session (2026-08-18) reached it via a browser tool and checked the two QUL resource
pages docs/02-data-sources.md points at — KFGQPC V2 layout
(`qul.tarteel.ai/resources/mushaf-layout/10`) and QPC V2 Font
(`qul.tarteel.ai/resources/font/249`) — plus Credits, Terms of Use, FAQ, and linked docs
pages. Neither resource page (nor anything linked from it) states a licence,
redistribution terms, or attribution wording, so nothing was downloaded. Filed
[TarteelAI/quranic-universal-library#729](https://github.com/TarteelAI/quranic-universal-library/issues/729)
asking QUL to clarify; still unverified pending a response.

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
