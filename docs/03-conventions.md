# Conventions

Consistency beats cleverness. Match the surrounding code.

---

## 1. Style

- `flutter_lints` plus the additional rules in `analysis_options.yaml`.
- `dart format` with default 80-column width. CI checks formatting.
- **Zero analyzer warnings.** Not "few". Zero. A warning that is acceptable is a
  warning that will be ignored forever.

## 2. Naming

| Thing | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `plan_generator.dart` |
| Types | `PascalCase` | `PageState` |
| Riverpod providers | `<noun>Provider` | `hifzRepositoryProvider` |
| Controllers | `<Feature>Controller` | `ReviewController` |
| Abstract interfaces | no `I` prefix | `MushafRenderer` not `IMushafRenderer` |
| Booleans | positive, question-shaped | `isReady`, `hasLapsed` — never `notReady` |
| Test files | `<subject>_test.dart` | `fsrs_test.dart` |

Domain vocabulary is Arabic where the concept is Arabic — `sabaq`, `sabqi`, `manzil`,
`juz`, `hizb`, `ayah`, `surah`, `mushaf`, `khatm`. Do not translate these to "lesson",
"recent", "old". The domain terms are precise and the audience knows them.

Use `ayah` not `verse`, `surah` not `chapter`, throughout code and UI.

## 3. Models

- Immutable. `freezed` for anything with more than two fields or any copy semantics.
- Value objects over primitives for domain identifiers: `PageRef(int)`, `AyahRef(surah,
  ayah)`, `JuzRef(int)`. A bare `int` page number passed to a function expecting a surah
  number is a bug the type system should have caught.
- Validate at construction. A `PageRef(0)` or `PageRef(605)` must not be constructible.

## 4. Async

- `Future` for one-shot, `Stream` for continuous.
- No `async` in a `build()` method.
- Every `await` in domain code returns `Result<T, E>`; exceptions are for programmer
  error only.

## 5. Comments

Write comments that explain **why**, never **what**.

```dart
// BAD — restates the code
// Cap the interval at 30 days
if (interval > maxInterval) interval = maxInterval;

// GOOD — explains the reasoning
// Quran memory decays faster than vocabulary; a stock FSRS interval of
// several months leaves a page unreviewable in practice. See ADR 0003.
if (interval > maxInterval) interval = maxInterval;
```

Every non-obvious domain rule cites its ADR or its source in traditional practice.
Six months from now, the reason a number is 7 and not 10 will not be self-evident.

Use `// ponytail:` style markers sparingly and only for deliberate, tracked shortcuts.

## 6. Git

**Branches**

```
phase-<N>/batch-<N.M>-<short-slug>
```

e.g. `phase-1/batch-1.3-highlight-overlay`

Fixes outside a batch: `fix/<slug>`. Docs only: `docs/<slug>`.

**Commits** — Conventional Commits, imperative mood.

```
feat(hifz): add contiguity batching to manzil scheduler
fix(reader): scale ayah boxes to rendered image width
docs(phases): clarify Phase 4 definition of done
chore(ci): pin flutter version in release workflow
test(fsrs): cover lapse recovery path
```

Scopes: `mushaf`, `reader`, `audio`, `hifz`, `plan`, `review`, `home`, `progress`,
`notif`, `backup`, `settings`, `ui`, `data`, `ci`, `docs`.

End every commit body with:

```
Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```

**Never commit directly to `main`.** Every change arrives by PR.

## 7. Pull requests

One PR per batch. Title: `Batch <N.M> — <name>`.

The body states what the batch delivers, which definition-of-done items it satisfies,
and anything deliberately left undone. Link the phase file.

Merge with squash. The squashed commit message is the PR title plus body.

## 8. Definition of done — every batch

A batch is not done until all of these hold:

1. `flutter analyze` reports zero issues.
2. `flutter test` passes.
3. New domain logic has unit tests. New UI has at least a controller test.
4. `dart format` is clean.
5. Layering checks pass (`tool/verify_layering.dart`).
6. The batch's own "Done when" list in the phase file is fully satisfied.
7. `PROGRESS.md` is updated — batch log row added, current position advanced.
8. No new `TODO` without an owner and a phase reference.

## 9. Dependencies

- **Pin exact versions** for `just_audio`, `audio_service`,
  `flutter_local_notifications`, and `drift`. These four break in minor releases and
  their failures are platform-specific and slow to diagnose.
- Every new dependency needs a one-line justification in the PR body.
- Prefer the Dart SDK, then a well-maintained package, then your own code. Do not add a
  package for something the SDK does.
- Check the licence of every dependency. No GPL, ever — it is incompatible with app
  store distribution.

## 10. Accessibility

Not polish, not deferred:

- Every interactive element has a semantic label.
- Minimum 48×48 dp touch targets.
- Text scales with system font size — **except** the mushaf page, which is fixed by
  design under the image renderer.
- Contrast meets WCAG AA in all three themes.
- The app is usable one-handed. Primary actions sit in the lower half of the screen.

## 11. Strings

All user-facing strings go through the localisation layer from Phase 0, even while
English is the only locale. Arabic and Urdu are near-certain additions and retrofitting
localisation across forty screens is miserable work.

Never concatenate translated fragments — plural and gender rules differ by language.
Use ICU message format.
