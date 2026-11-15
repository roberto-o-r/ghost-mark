# Iteration 006: First-launch starter document

- **Date:** 2026-11-14 to 2026-11-14
- **Status:** Completed
- **Area:** product
- **Version:** 1.4.0+9
- **PR:** [PR #11](https://github.com/roberto-o-r/ghost-mark/pull/11)

## Context
GhostMark 1.3.0+8 is live on Google Play and its 43 tests pass with a clean analyzer. The last 28 days show 47 device impressions, 9 device acquisitions, 1 first open, and 5 monthly active devices. These small counts do not prove an onboarding problem, but a code review found that a new installation opens to a completely blank editor despite the app now having formatting, preview, link, file, and autosave features. The overdue review of iteration 001 found no new file-integrity complaints; traffic remains too low for causal attribution.

## Options considered
1. **First-launch starter document (chosen):** give new users an editable example without touching saved or intentionally cleared work; smallest learning-oriented activation improvement.
2. Improve editor readability: directly supported by a five-star review, but less likely to improve initial feature discovery.
3. Mathematical notation: directly requested in a five-star review, but has greater renderer and regression risk.
4. Android presentation and efficiency pass: useful maintenance, but requires native validation and has modest immediate user impact.

## Plan
- **Objective:** help a brand-new user understand GhostMark's core workflow immediately without adding onboarding screens or accounts.
- **Hypothesis:** a short editable Markdown document will make formatting, preview, checklists, links, code, autosave, and file controls discoverable, reducing the friction of the current blank first launch.
- **Scope:** seed concise starter Markdown only when no document preference exists; preserve existing and intentionally empty documents; add focused persistence and UI tests; validate the first-run and returning-user paths in the browser; prepare version 1.4.0+9, documentation, and release notes.
- **Non-goals:** analytics or telemetry, multi-document storage, walkthrough overlays, account/cloud features, store-listing changes, review replies, typography changes, math rendering, or public release.
- **Execution steps:** add the starter content and persistence guardrail; test first launch, saved content, and saved empty content; update version/docs/release notes; run analyzer, tests, builds, and browser checks; prepare the work for the repository's PR workflow.
- **Success / guardrails:** a fresh profile shows the starter document; existing content and saved empty content remain unchanged; edits still autosave; preview renders the sample correctly; all existing tests and analysis pass; no user document can be overwritten by the new behavior.
- **Validation approach:** automated provider/widget regression tests, full Flutter test and analysis suites, release web build, and hands-on integrated-browser testing. Native testing is not planned because this behavior is platform-independent.
- **Release approach:** prepare a branch and release artifacts. Commit, push, PR, merge, tag, and Google Play publication require separate authorization.
- **Definition of done:** implementation and tests pass; browser validation covers fresh, edited, and returning states; version, release notes, README, and iteration records are current; work is ready for the repository's PR process.

## What was done
- Completed: selected the first-launch starter document opportunity and created this record.
- Completed: added a concise starter document that demonstrates headings, bold text, preview, checklists, internal links, inline code, autosave, and file controls only when no saved document preference exists.
- Completed: preserved existing documents and intentionally empty documents, including a cleared starter document, through the existing local preference boundary.
- Completed: added four widget tests covering fresh launch, rendered preview, saved content, saved empty content, and clearing/persisting the starter.
- Completed: updated README, Version 9 release notes, and version 1.4.0+9.
- Completed: reconciled iteration 005 with its merged PR and 2026-11-07 Google Play release.
- Completed: built the web release, Android debug APK, and signed Android release bundle.
- Completed: validated the release web build hands-on in the integrated browser.
- Completed: added the requested Modera-style feedback-system PBI to `BACKLOG.md` without expanding this iteration's implementation scope.
- Completed: committed the validated work, pushed `improvement/first-launch-starter`, and opened PR #11.
- Completed: squash-merged PR #11 into `main` as `f77716e` on 2026-11-14.
- Completed: uploaded the signed 1.4.0+9 app bundle to Google Play Production with the Version 9 notes and a 100% rollout to all targeted countries.
- Completed: submitted the production change to Google for review on 2026-11-14. Play showed `Changes in review` while its quick checks were still running; managed publishing is off, so rollout starts automatically after approval.

## Validation
- Baseline before changes: `flutter analyze --no-pub` was clean and `flutter test --no-pub` passed 43/43 tests.
- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: 47/47 pass (43 baseline + 4 first-launch tests).
- `flutter build web --release --no-pub`: succeeds.
- `flutter build apk --debug --no-pub`: succeeds, producing `build/app/outputs/flutter-apk/app-debug.apk`.
- `flutter build appbundle --release --no-pub`: succeeds, producing a signed 52.6 MB `build/app/outputs/bundle/release/app-release.aab`.
- Bundle SHA-256: `1f5d4415f144892f9449f3e5fbdf013c3559bd420bfa9578e134571deeeff0f1`.
- Bundle certificate SHA-1: `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0`, matching GhostMark's established Play upload key.
- Integrated-browser release-build validation: confirmed the starter appears on a fresh profile, renders correctly in View, remains editable, autosaves an edited document, and restores that edit after a browser reload.
- The temporary signing-config link used by the isolated worktree was removed after the build.
- Deviation: the isolated worktree could not resolve packages through the restricted network, so it reused the existing project's resolved package metadata. The lockfile and dependency declarations were unchanged.
- Release verification: Play accepted app bundle 9 (1.4.0), reported no newly unsupported devices, showed a 9.17 MB new-install download and 456 KB update, and accepted the full-rollout submission for review.
- Deviation: public release was an explicit follow-on authorization after the initially selected implementation scope; Play review is external and was still pending at closeout, so the version was submitted but not yet live.

## Results
- Fact: option 1 was selected on 2026-11-14.
- Fact: a fresh profile now receives the editable starter document, while an existing or intentionally empty document remains unchanged.
- Fact: all 47 tests pass, the analyzer is clean, and web/Android release artifacts build successfully.
- Fact: browser validation confirmed fresh-launch rendering and returning-user persistence.
- Fact: the requested feedback-system PBI is recorded in `BACKLOG.md` with its privacy, form, persistence, rating, testing, and mobile-handoff requirements.
- Fact: PR #11 was merged into `main` as `f77716e`.
- Fact: Google Play accepted 1.4.0+9 for Production at 100% rollout and showed the change under `Changes in review` on 2026-11-14.
- Fact: 1.4.0+9 was not yet live at closeout because Play's quick checks and review were pending.
- Hypothesis to test: an editable sample improves early feature discovery and activation.

## Follow-up
- **Metrics to monitor:** device first opens, monthly active devices, and new reviews mentioning usability or onboarding; counts must accompany rates because traffic is low.
- **Review date:** 2026-12-12; if Play approval materially delays publication, interpret this as the first review and schedule another 28 days after the actual live date.
- **Risks and limitations:** Play review and live availability were pending at closeout; Play traffic is too low for reliable attribution; a starter document can feel like clutter despite being concise; browser validation cannot measure long-term retention; Flutter reports that `file_picker` and `shared_preferences_android` still apply the Kotlin Gradle Plugin and will eventually need dependency upgrades for a future Flutter toolchain.
- **Ideas for future iterations:** Modera-style feedback system (specified in `BACKLOG.md`); typography improvements; mathematical notation; Android edge-to-edge and image optimization; ASO/search-discovery work after the listing review period.
