# Iteration 002: Markdown formatting toolbar

- **Date:** 2026-10-16 to 2026-10-16
- **Status:** Completed and released
- **Area:** product
- **PR / release:** [PR #5](https://github.com/roberto-o-r/ghost-mark/pull/5); app version 1.2.0+5, tag `v1.2.0`

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
- Device test on the A059P phone (Android 16), 2026-10-16, `.debug` variant installed with `flutter run`. That upgraded the app in place and kept its saved document, unlike `flutter install`. The Play-installed app was not touched. Owner reported everything passing: each button with and without a selection, the keyboard staying open, list markers replacing each other, the text persisting after a restart, and the View tab rendering without the toolbar.

## Release
Released: 1.2.0+5 live on Google Play 2026-10-16 (owner confirmed). Tagged `v1.2.0`. Steps taken:
1. Done: device test passed (see Validation).
2. Done: PR #5 merged.
3. Done: built the signed release bundle (`flutter build appbundle --release`, 1.2.0+5). Certificate SHA-1 `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0` (the Play upload key), version name 1.2.0. Owner uploaded it with the `INFO.md` notes.
4. Done: tagged `v1.2.0`.

## Results
- Fact: every Markdown construct the toolbar covers can now be entered with one tap, and the transforms are verified by tests.
- Unknown: whether this changes ratings, retention or reviews. There's no analytics and no Play Console baseline yet.

## Follow-up
- **Metrics to monitor:** Play Console average rating and new reviews (mentions of formatting, toolbar or keyboard), 1-day/7-day retention and uninstall rate, compared before and after the 1.2.0 rollout; crash/ANR rate.
- **Review date:** 2026-11-20
- **Risks and limitations:** no baseline, so the impact can't be attributed cleanly. Link can't be toggled off. The toolbar takes about 48 px from the editor on small screens. System text undo after a toolbar edit was not tested.
- **Ideas for future iterations:** Play Console baseline and review mining (option 2, needed for measuring this one); preview polish (tappable links, selectable text, dark mode); undo snackbar for Clear/Open; README/listing refresh including a screenshot of the toolbar; numbered lists and quotes if reviews ask for them.
