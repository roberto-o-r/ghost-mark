# Iteration 002: Markdown formatting toolbar

- **Date:** 2026-10-16 to 2026-10-16
- **Status:** Completed, awaiting owner device test, PR merge and Play upload of 1.2.0+5
- **Area:** product
- **PR / release:** [PR #5](https://github.com/roberto-o-r/ghost-mark/pull/5); app version 1.2.0+5

## Context
GhostMark 1.1.1+4: one autosaved document, Edit/View tabs, Open/Save/Clear. 8 tests pass, analyzer clean. The editor is a bare `TextField`, so every `#`, `*`, `[`, `` ` `` means switching to the symbol keyboard. The store listing sells "Mobile-First Design" and "Markdown Support". No analytics, crash reporting or Play Console data available to this iteration. Iteration 001's Play upload of 1.1.1+4 is still unconfirmed (no `v1.1.1` tag).

## Options considered
1. **Markdown formatting toolbar (chosen).** Most visible improvement aligned with the app's mobile-first promise; small and testable. Hypothesis-based (no usage data).
2. Play Console baseline and review mining (needs owner's console access).
3. Preview polish: tappable links (currently inert, confirmed in code), selectable text, dark mode.
4. Undo snackbar after Clear / Open-replace.
5. Store listing and README refresh (README claims WordPress publishing that doesn't exist).

## Plan
- **Objective:** let users apply common Markdown syntax with one tap instead of typing symbols.
- **Hypothesis:** typing Markdown syntax on a phone keyboard is the main friction in the editor; a toolbar makes writing faster and makes the app feel purpose-built.
- **Scope:** a scrollable toolbar row under the editor (sits directly above the keyboard while typing) with Heading, Bold, Italic, Bulleted list, Checklist, Link and Code. Inline actions wrap the selection (or insert a pair with the cursor between); line actions toggle a prefix on every selected line. Edits are autosaved like typing. Pure text-transform functions with unit tests, plus widget tests. Bump to 1.2.0+5 with release notes.
- **Non-goals:** heading levels, numbered lists, quotes, undo/redo, toolbar customization, View tab changes, listing/screenshot updates.
- **Success / guardrails:** each action produces the expected text and selection in tests; toolbar edits persist after reload; existing tests still pass; analyzer clean; Android build succeeds. After release: Play rating/reviews and retention compared with the pre-release period (no baseline yet).
- **Release:** PR to `main`; owner device-tests, merges and uploads the signed bundle.
- **Definition of done:** the above validated, PR open with this record, release handoff written.

## What was done
- Completed: `lib/features/editor/data/markdown_formatting.dart`: pure `TextEditingValue` transforms. `toggleWrap` (wrap or unwrap the selection; empty pair with the cursor inside), `insertLink` (`[sel](url)` with `url` selected, or cursor inside `[]`), `toggleLinePrefix` (toggle a prefix on every selected line; heading and list markers replace their own family instead of stacking, e.g. `- ` ↔ `- [ ] `, `### ` → `# `).
- Completed: `lib/features/editor/presentation/formatting_toolbar.dart`: horizontally scrollable row of 7 icon buttons (Heading, Bold, Italic, Bulleted list, Checklist, Link, Code) wrapped in `TextFieldTapRegion` so taps keep the editor focused.
- Completed: `EditorScreen` shows the toolbar under the text field, applies the transform, refocuses the field and autosaves the result (the controller change doesn't fire `onChanged`).
- Completed: 14 unit tests and 4 widget tests (bold + autosave, focus kept with the cursor in place, formatting an unfocused empty editor, toolbar hidden on View).
- Completed: version 1.2.0+5 and release notes in `INFO.md`.
- Cancelled: none. Not done (non-goals): heading levels, numbered lists, quotes, undo/redo.

## Validation
- `flutter test`: 28/28 pass (8 existing + 20 new).
- `flutter analyze`: no issues.
- `flutter build apk --debug`: succeeds.
- iOS simulator (iPhone 17 Pro, debug, software keyboard): with the editor focused, the toolbar sits directly above the keyboard and all 7 buttons fit without scrolling. Taps on the buttons weren't driven on the simulator; that behaviour is covered by the widget tests only.
- Not yet done: a real Android device test (planned for the owner, as in iteration 001). Use the `.debug` variant, and note that `flutter install` uninstalls the previous `.debug` app and its document.

## Release
Not released. Remaining, all for the owner:
1. Device-test the PR build on Android: each button with and without a selection, the keyboard staying open after a tap, and the text persisting after restarting the app.
2. Merge the PR.
3. Build the signed `flutter build appbundle --release` (1.2.0+5) and upload it to Google Play with the `INFO.md` notes. If 1.1.1+4 (iteration 001) never shipped, 1.2.0+5 supersedes it and includes its fixes; use both sets of notes.
4. Once it's live, tag `v1.2.0` (and `v1.1.1` if that shipped) and mark this record Completed and released.

## Results
- Fact: every Markdown construct the toolbar covers can now be entered with one tap, and the transforms are verified by tests.
- Unknown: whether this changes ratings, retention or reviews. There's no analytics and no Play Console baseline yet.

## Follow-up
- **Metrics to monitor:** Play Console average rating and new reviews (mentions of formatting, toolbar or keyboard), 1-day/7-day retention and uninstall rate, compared before and after the 1.2.0 rollout; crash/ANR rate.
- **Review date:** 2026-11-20
- **Risks and limitations:** no baseline, so the impact can't be attributed cleanly. Link can't be toggled off. The toolbar takes about 48 px from the editor on small screens. System text undo after a toolbar edit was not tested.
- **Ideas for future iterations:** Play Console baseline and review mining (option 2, needed for measuring this one); preview polish (tappable links, selectable text, dark mode); undo snackbar for Clear/Open; README/listing refresh including a screenshot of the toolbar; numbered lists and quotes if reviews ask for them.
