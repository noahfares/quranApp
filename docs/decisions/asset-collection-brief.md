# Task: Collect Quran mushaf assets and their licences from QUL

## Context

We're building Hifz, a free, open-source (Apache-2.0) Quran memorization app with no
ads, no analytics, and no in-app purchases. We need to bundle Quran mushaf assets, and
before bundling anything we must have the exact licence text and confirm redistribution
in a free app-store app is permitted. Do not download or use anything whose licence is
unclear — flag it instead of guessing.

## What to collect

### 1. Mushaf layout — KFGQPC V2 (1421H print)

URL: https://qul.tarteel.ai/resources/mushaf-layout/10

From this page, get:
- The exact resource name and version/date as shown on the page.
- The full licence/terms-of-use text shown on the page (copy verbatim, do not
  paraphrase or summarize it).
- Any required attribution wording.
- Whether the page states redistribution in a closed app-store listing is permitted.
- Download the layout data (the "Download sqlite" file, or "Download docx" if sqlite
  isn't available).

### 2. Matching font — QPC V2 Font

Find this via the "related resources" link on the mushaf-layout/10 page, or under
https://qul.tarteel.ai/resources/font

From this page, get the same five things as above (name/version, verbatim licence
text, attribution wording, redistribution permission, and the font file download).

### 3. If either page's licence is unclear or absent

Do not download the asset. Instead:
- Note exactly what's unclear.
- Look for a contact/support link (QUL has a Discord and likely a contact form) and
  report back what you found, so we can reach out directly.

## How to report back

For each of the two resources, reply with:

```
## <Resource name>
- Source URL:
- Version/date:
- Licence text (verbatim):
  """
  <paste here>
  """
- Required attribution wording:
- Redistribution in a free app-store app permitted? yes / no / unclear
- Downloaded file(s): <filename(s), or "not downloaded — see note">
- Notes: <anything unclear or worth flagging>
```

Attach or provide the downloaded files (sqlite/docx layout file, font file) alongside
your reply.

## What NOT to do

- Don't modify, re-encode, or "clean up" any downloaded file — bundle it byte-for-byte
  as downloaded.
- Don't paraphrase licence text — copy it exactly.
- Don't guess at permissions that aren't stated on the page — mark them "unclear" and
  report back instead.
