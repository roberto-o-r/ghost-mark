# Iteration 005: Preview navigation and selection

- **Date:** 2026-11-06 to In progress
- **Status:** Implementation complete; awaiting repository authorization
- **Area:** product
- **Version:** 1.3.0+8 (planned)
- **PR:** None

## Context
GhostMark 1.2.2+7 is live on Google Play. The current preview renders Markdown but does not make text selectable and does not provide an `onTapLink` handler, so links look active but do nothing. A browser check reproduced the problem with an external link. The newest written review (4 stars, 2026-04-03) asks for anchor support. Baseline health is good: 33/33 tests pass, `flutter analyze` is clean, and the web release build succeeds. Play's latest 28-day overview shows 50 device impressions, 8 acquisitions, 2 first opens, 5 monthly active devices, and a 26.03% listing conversion rate; statistics show 8 acquisitions and 11 device losses. Traffic is too low to attribute product impact reliably.

## Options considered
1. **Preview navigation and selection (chosen):** directly addresses the newest review and a reproduced inert-link defect while preserving the current renderer.
2. Mathematical notation: supported by an older 5-star review, but changing renderers has greater regression risk.
3. First-run example document: plausible activation improvement, but evidence is weak and metrics are noisy.
4. Android 16 compatibility pass: valuable maintenance, but requires native validation and does not address a current user-facing request.
5. Acquisition diagnosis and ASO update: impressions are the funnel constraint, but the current listing review period is not complete until 2026-11-23.

## Plan
- **Objective:** make the rendered preview useful for navigating and reusing document content.
- **Hypothesis:** selectable text, functional web links, and internal heading anchors remove obvious preview friction for people using GhostMark for longer or reference-heavy documents.
- **Scope:** make preview text selectable; open only `http` and `https` links through an injectable launcher; resolve `#fragment` links to rendered headings; generate stable, normalized heading IDs with deterministic suffixes for duplicates; add focused unit and widget tests; validate hands-on in the browser; prepare 1.3.0+8 and release notes.
- **Non-goals:** math/LaTeX, renderer replacement, link editing, images, table-of-contents UI, editor scrolling synchronization, analytics, store-listing changes, or public release.
- **Success / guardrails:** browser validation proves selection and internal navigation; tests prove external-link routing, fragment resolution, duplicate heading IDs and unsupported-scheme rejection; existing Markdown/editor/file tests still pass; analyzer and web build are clean; no regression to current headings, lists, checklists, code or preview scrolling.
- **Release approach:** prepare a branch and release artifacts. Commit, push, PR, merge, tag and Google Play publication require separate authorization.
- **Definition of done:** implementation and tests pass, browser validation is recorded, version/release notes and both iteration records are current, and the work is ready for the repository's PR process.

## What was done
- Completed: replaced the inert preview with a selectable Markdown surface while retaining `flutter_markdown_plus` and its existing visual rendering.
- Completed: added safe external-link handling that accepts only absolute HTTP(S) URLs and delegates launching through an injectable boundary.
- Completed: added internal `#fragment` navigation using GitHub-style heading IDs, percent-decoded fragments, and deterministic `-2`, `-3` suffixes for duplicate headings.
- Completed: preserved inline formatting inside anchored headings by wrapping the renderer's native top-level heading blocks rather than rebuilding their text.
- Completed: added 10 unit/widget tests covering selection, heading formatting, safe and unsupported links, fragment normalization, internal scrolling, and duplicate heading IDs.
- Completed: updated README/INFO copy, set version 1.3.0+8, and prepared Version 8 Play notes.
- Completed: built the web release, Android debug APK, and signed Android release bundle.
- Completed: validated the release web build hands-on in the integrated browser.
- Completed: selected the opportunity and created this record.
- Completed: reconciled iteration 004's record with its 2026-10-31 Play release.
- Awaiting authorization: commit, push, pull request, merge, and Google Play publication.

## Validation
- Baseline before changes: `flutter test --no-pub` 33/33 passing; `flutter analyze --no-pub` clean; `flutter build web --release --no-pub` succeeded.
- Baseline browser check: Markdown rendered, but preview text was not selectable, an external link did not navigate, and LaTeX remained literal text (math is outside this iteration).
- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: 43/43 pass (33 baseline + 10 preview-navigation tests).
- `flutter build web --release --no-pub`: succeeds.
- `flutter build apk --debug --no-pub`: succeeds; verifies Android plugin registration and compilation.
- `flutter build appbundle --release --no-pub`: succeeds; signed 1.3.0+8 bundle is 53.0 MB at `ghost_mark/build/app/outputs/bundle/release/app-release.aab`.
- Bundle SHA-256: `c5f03eb829e021a59b06d917603c11a1d850c2f516380e45ecddae23e16327c1`.
- Bundle certificate SHA-1: `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0`, matching the established Play upload key.
- The temporary signing-config link used in the worktree was removed after the build.
- Integrated-browser release-build validation: selected rendered preview text; followed `#details`; followed duplicate `#details-2`; opened an HTTPS link in a new browser tab; visually confirmed headings, bullets, checklists, quotes, inline code and preview scrolling.
- Deviation: the Android external-app handoff was not exercised on a device/emulator because browser behavior and the injected launcher boundary covered the current risk; per the user's preference, native runtime testing is reserved for mobile-specific uncertainty.

## Results
- Fact: option 1 was selected on 2026-11-06.
- Fact: preview text is selectable in the browser release build.
- Fact: internal links navigate to both unique and duplicate headings, and an HTTPS link opens in a new browser tab.
- Fact: all 43 tests pass, the analyzer is clean, and web/Android release artifacts build successfully.
- Fact: no repository or production action has been taken; the changes remain uncommitted in `improvement/preview-navigation` pending explicit authorization.
- Assumption to test: preview navigation materially improves usefulness for long or reference-heavy documents.

## Follow-up
- **Metrics to monitor:** new reviews mentioning links, anchors or preview; rating; monthly active devices; device acquisitions and losses. Counts must be reported with rates because volume is low.
- **Review date:** 2026-12-04 if released
- **Risks and limitations:** Play traffic is too low for attribution; browser validation cannot prove the Android external-app handoff; Unicode-only heading IDs can normalize to an empty ID under the current GitHub-style algorithm; the selectable preview lays out the complete rendered document, so unusually large documents should be watched for scroll/rendering performance.
- **Ideas for future iterations:** mathematical notation; first-run example document; Android edge-to-edge and bitmap recommendations; ASO/search-discovery work after the 2026-11-23 listing review; typography improvements.
