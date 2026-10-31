# Iteration 004: Open text-file recovery

- **Date:** 2026-10-31 to 2026-10-31
- **Status:** In progress
- **Area:** engineering
- **Version:** 1.2.2+7
- **PR:** None

## Context
GhostMark 1.2.1+6 has one autosaved document and can open UTF-8 Markdown through Android's file picker. Versions 1.1.0 through 1.2.0 could suggest `null.plain` when saving, but the current Open action filters for `.md`, so affected files are disabled in the picker. Strict UTF-8 decoding, replacement confirmation, and error messages already exist. The repository is clean, has no open issues or pull requests, and the most recent recorded validation is 30 passing tests with a clean analyzer.

## Options considered
1. Open any UTF-8 text file and recover `.plain` files (chosen): confirmed residual harm, small scope, high confidence and low risk.
2. Math-capable, selectable preview: supported by a public user request, but larger and dependency-sensitive.
3. Undo for Clear and Open/Replace: valuable data-loss protection, but does not recover already stranded files.
4. First-run guided document: plausible activation improvement, but weakly measurable at current traffic.
5. Spanish localization: possible growth opportunity, but locale demand is not yet known.

## Plan
- **Objective:** let users open valid UTF-8 text regardless of file extension, including files previously saved as `null.plain`.
- **Hypothesis:** using the unrestricted system picker while retaining strict UTF-8 validation recovers affected documents and improves interoperability without weakening data safety.
- **Scope:** accept any selected file; preserve invalid-text/read errors and replace confirmation; add focused widget tests for `.plain`, `.txt`, extensionless, and invalid data; update the app to 1.2.2+7 with release notes; run tests, analysis, and Android builds.
- **Non-goals:** document library, encoding conversion or detection, binary-file support, Android share/open-with intents, UI redesign, analytics, or public release.
- **Definition of done:** recovery cases pass, invalid files remain rejected, existing tests pass, analyzer is clean, Android debug and release-bundle builds succeed, and the iteration record contains the evidence and release handoff.

## What was done
- Completed: Open now uses the unrestricted system picker, so `.md`, `.txt`, `.plain`, extensionless, and other selectable files reach the existing strict UTF-8 decoder.
- Completed: existing invalid-text/read errors and the replace confirmation remain unchanged.
- Completed: the fake picker records its requested type, and three widget tests prove UTF-8 recovery from `null.plain`, `notes.txt`, and an extensionless `README` file. The existing invalid UTF-8 test remains in the suite.
- Completed: README wording, 1.2.2+7 version, and Version 7 Play release notes.
- Completed: debug APK and signed release bundle builds.
- Not done: native Android file-picker test on a phone or emulator.
- Awaiting authorization: commit, push, pull request, merge, and Google Play publication.

## Validation
- `flutter test`: 33/33 pass (30 existing + 3 recovery tests).
- `flutter analyze`: no issues.
- `flutter build apk --debug`: succeeds.
- `flutter build appbundle --release`: succeeds; output is 52.4 MB.
- Release manifest: package `com.eunoia.ghost_mark`, version name 1.2.2, version code 7.
- Bundle certificate SHA-1: `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0`, matching the established Play upload key.
- The temporary signing-config link used in the worktree was removed after the build.
- Deviation: native picker behavior was not exercised because no device/emulator test was run.

## Results
- Fact: widget tests load identical non-ASCII content from `.plain`, `.txt`, and extensionless files through the Open flow.
- Fact: the test suite still rejects invalid UTF-8 and leaves the editor empty instead of replacing it.
- Fact: the signed 1.2.2+7 Android bundle is ready for a device test and release review.
- Unknown: how many users have stranded `null.plain` files or will use non-`.md` inputs.

## Follow-up
- **Metrics to monitor:** reviews or support reports mentioning files that cannot be opened; crash/ANR rate for file opening; install/uninstall direction after release.
- **Review date:** 2026-11-28
- **Risks and limitations:** an unrestricted picker allows users to select non-text files, which must fail clearly; only UTF-8 is supported; cloud providers that do not provide a local path remain outside scope.
- **Ideas for future iterations:** math-capable preview, undo for destructive actions, first-run guidance, Spanish localization, and a multi-document workspace.
