# Iteration 007: Android plugin registration hotfix

- **Date:** 2026-11-19 to in progress
- **Status:** In progress
- **Area:** engineering / reliability
- **Version:** 1.4.1+10
- **PR:** https://github.com/roberto-o-r/ghost-mark/pull/12

## Context
GhostMark 1.4.0+9 displayed a gray editor body on a physical Android phone even after app storage was cleared. A clean Android-emulator reproduction exposed `PlatformException(channel-error)` for `shared_preferences_android.SharedPreferencesApi.getAll`. The 1.4.0 Play bundle had been built from a worktree that reused generated dependency metadata and used `--no-pub`; its ignored Android `GeneratedPluginRegistrant.java` was absent, so Shared Preferences, File Picker and URL Launcher were not registered in the app. The source code and saved document were not the cause.

## Options considered
1. **Regenerate plugins and ship a hotfix (chosen):** fixes the broken production artifact with the smallest safe release.
2. Manually register plugins in `MainActivity`: rejected because it duplicates Flutter's generated registration and could drift or register plugins twice.
3. Add a Dart fallback when preferences fail: useful defense-in-depth, but it would hide a broken native build and would not repair Open, Save or link launching.

## Plan
- **Objective:** restore Android startup and all native plugin-backed features in a correctly generated 1.4.1+10 release.
- **Hypothesis:** running `flutter pub get` in the release worktree before building will regenerate the missing Android registrant and eliminate the startup channel error.
- **Scope:** clean dependency resolution; verify required plugin entries; add a repeatable guarded Android release script; bump 1.4.1+10 and prepare Play notes; run the full test/build suite; install and validate the actual release APK on a clean Android emulator.
- **Non-goals:** product changes, dependency upgrades, iOS work, feedback-system work, or unrelated refactoring.
- **Success / guardrails:** fresh Android launch renders the editor instead of an error surface; starter/autosave works; Open and Save reach the Android document picker; required plugins appear in the generated registrant; existing tests and analyzer pass; signed app bundle uses the established upload key.
- **Release approach:** prepare a hotfix branch and validated artifacts, then use the authorized expedited path through PR, merge and Play submission.
- **Definition of done:** the Android release is reproduced, fixed, validated on an emulator, documented, and ready for expedited Play publication.

## What was done
- Completed: reproduced the production symptom on Android and captured the Shared Preferences channel-registration exception.
- Completed: identified the incomplete release-worktree initialization as the root cause.
- Completed: added a guarded Android release script that regenerates plugin metadata, verifies the three required plugins, runs analysis and tests, and builds the app bundle.
- Completed: bumped the app to 1.4.1+10 and prepared Play release notes.
- Completed: built the signed release bundle and release APK from a cleanly initialized worktree.
- Completed: installed the corrected release on a clean Android emulator and validated startup, Open and Save.
- In progress: merge and expedited Play publication.

## Validation
- `flutter analyze --no-pub`: passed with no issues.
- `flutter test --no-pub`: 47/47 tests passed.
- Required generated registrations verified: File Picker, Shared Preferences and URL Launcher.
- Signed Android app bundle built successfully (53.0 MB).
- Bundle SHA-256: `783321f4539f6b34b32e353a5c21708335d99b41342a88329da5cd234f3d3a8d`.
- Upload certificate SHA-1: `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0` (established Play upload key).
- Fresh install of the signed 1.4.1 release APK rendered the starter editor and formatting toolbar instead of the gray/error surface.
- Android startup logs contained no Flutter or Android runtime errors.
- Open and Save each launched the Android document picker.

## Results
- Fact: clearing app storage does not resolve 1.4.0 because the failure is in the packaged native plugin registration.
- Fact: a clean `flutter pub get` regenerates registrations for File Picker, Shared Preferences and URL Launcher.
- Fact: the corrected 1.4.1 release restores the editor and native file actions on Android.
- Fact: the validated Play artifact is ready for expedited publication but has not yet been submitted.

## Follow-up
- **Metrics to monitor:** Play crash/ANR signals and new feedback mentioning startup, gray screens, Open, Save or links.
- **Review date:** 2026-11-26 if released.
- **Risks and limitations:** Play review timing is external; the issue is not represented as a standard Flutter crash because the app shell remains alive.
- **Ideas for future iterations:** automated artifact smoke test in CI; Modera-style feedback system; iOS release.
