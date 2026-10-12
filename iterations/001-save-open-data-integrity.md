# Iteration 001: Save/Open data integrity

- **Date:** 2026-10-12 to 2026-10-12
- **Status:** Completed, awaiting PR merge and store upload of 1.1.1+4
- **Area:** engineering
- **PR / release:** [PR #4](https://github.com/roberto-o-r/ghost-mark/pull/4); app version 1.1.1+4

## Context
GhostMark 1.1.0+3 is a ~360-line Flutter Markdown editor: one autosaved document in SharedPreferences, Edit/View tabs, and Open/Save/Clear actions. No tests, analytics or crash reporting; no store metrics available in the repo. Investigation found:

- Save encoded text with `Uint8List.fromList(text.codeUnits)`, truncating every UTF-16 unit to one byte. Reproduced: `"Café — naïve ✍️ 🚀"` saved as `Caf� na�ve =�`.
- Reopening such a file threw an uncaught `FormatException` from `readAsString()`, so Open silently did nothing.
- Open replaced the single autosaved document without confirmation (Clear does confirm).
- `flutter analyze` reported 2 `use_build_context_synchronously` warnings in Save/Clear.

## Options considered
1. **Fix Save/Open data integrity + first tests (chosen).** Confirmed bug that corrupts user writing in the only export path; small and fully verifiable.
2. Multiple documents. Hypothesis-driven, large, needs a storage migration.
3. Markdown formatting toolbar. Hypothesis-driven, medium.
4. Store listing / positioning refresh (README promises WordPress publishing that doesn't exist).
5. Privacy-friendly crash reporting and analytics.

## Plan
- **Objective:** text saved and opened by GhostMark round-trips exactly, and failures are reported instead of silent.
- **Hypothesis:** non-ASCII text (accents, dashes, emoji) is common in real notes, so this bug affects ordinary users.
- **Scope:** UTF-8 encode on Save; UTF-8 decode (BOM tolerated) on Open with an error message for unreadable files; confirm before Open replaces non-empty content; fix the 2 analyzer warnings; add unit and widget tests; bump to 1.1.1+4 with release notes.
- **Non-goals:** multiple documents, new file types, listing copy changes, dependency upgrades.
- **Definition of done:** tests prove a non-ASCII round trip, the invalid-file message and the replace confirmation; `flutter analyze` clean; Android release build succeeds; PR opened with this record.

## What was done
- Completed: `lib/features/editor/data/markdown_codec.dart` encodes Save output as UTF-8 and decodes Open input as UTF-8, stripping a leading BOM.
- Completed: Open shows "Could not open file: not UTF-8 text." or "Could not read file." instead of failing silently.
- Completed: Open asks "Replace Document" before replacing non-empty editor content (asked after a file is picked and read, so cancelling the picker never prompts).
- Completed: fixed both `use_build_context_synchronously` warnings (messenger captured before awaits; `context.mounted` checks).
- Completed: first test suite: 4 codec unit tests and 4 widget tests driving `MainApp` with a fake `FilePicker`.
- Completed: version bumped to 1.1.1+4; release notes added to `INFO.md`.

## Validation
- `flutter test`: 8/8 pass.
- Regression check: with the old `editor_screen.dart`, 3 of 4 widget tests fail (Save encoding, invalid-file message, replace confirmation), so the tests catch the original bugs.
- `flutter analyze`: no issues (was 2).
- `flutter build apk --debug` and `flutter build ios --release --no-codesign`: succeed.
- Signed `flutter build appbundle --release` (1.1.1+4) succeeded once the owner created the gitignored `android/key.properties`. Bundle certificate SHA-1 `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0`; owner confirmed it matches the Play Console upload key.
- Device test on an A059P phone (Android 16), 2026-10-12, using the `.debug` variant so the Play-installed 1.1.0 and its document stayed untouched. Owner reported all passing: non-ASCII Save→Open round trip, file readable in another app, replace confirmation (Cancel and Replace), and a file saved by Play 1.1.0 shows "Could not open file: not UTF-8 text."
- Note: `flutter install` uninstalls the previous `.debug` app first, which deletes its local document. Warn before reinstalling a debug build next time.

## Release
Not released. Remaining, all for the owner:
1. Done: PR #4 merged after the device test.
2. Owner: upload the signed `app-release.aab` (1.1.1+4) to Google Play with the `INFO.md` notes. Android only; the iOS project has never been set up for the App Store.
3. After it goes live: tag `v1.1.1` and mark this record Completed and released.

## Results
- Fact: save→open round trip of non-ASCII text is now exact in tests; previously it produced replacement characters and an uncaught exception.
- Unknown: how many users were affected. There is no analytics or crash reporting, and no store data was available.

## Follow-up
- **Metrics to monitor:** Play Console crash/ANR rate and ratings/reviews mentioning saving or garbled text after 1.1.1 rollout; confirmation that 1.1.1+4 shipped.
- **Review date:** 2026-11-09
- **Risks and limitations:** files saved by 1.1.0 with non-ASCII text are already corrupted on users' devices and can't be repaired (they will now show the "not UTF-8" message on Open). Files in other encodings (e.g. Latin-1) are rejected rather than converted. No real-device test of native pickers yet.
- **Ideas for future iterations:** fix listing/README positioning (WordPress publishing claim, "Version 3 1.1.0" label); privacy-friendly crash reporting/analytics; Markdown formatting toolbar; multiple documents; dependency upgrades (Riverpod 3, file_picker 13, flutter_lints 6); remove unused `gpt_markdown` dependency if confirmed unused.
