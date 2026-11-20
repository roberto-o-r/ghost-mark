# Iteration 008: Private feedback, Android submission and iOS preparation

- **Date:** 2026-11-19 to 2026-11-19
- **Status:** In progress: Android submitted; signed iOS build uploaded; final Apple listing and submission underway
- **Area:** product / research / engineering / distribution
- **Version:** Android 1.5.0+12 submitted; iOS 1.5.0 (12) uploaded
- **PR:** App PR authorized; being prepared. Privacy PR106: https://eunoiaorg.visualstudio.com/Eunoia/_git/Eunoia/pullrequest/106 (completed).

## Context
GhostMark is a local-only Flutter Markdown editor. Discovery verified Android1.4.1 active after its startup hotfix; latest28-day counts were9 device acquisitions,1 first open and6 monthly active devices. Five written reviews predated the recent releases. No open GitHub issues/PRs. The existing iOS runner had an example identity. The public GhostMark privacy link incorrectly redirected to Animalia.

## Options considered
1. Automated Android release smoke check — deferred as a standalone iteration.
2. Readability — deferred.
3. Private feedback — owner selected.
4. Math preview — deferred.
Owner added first iOS preparation/release and explicitly authorized both store submissions. Owner temporarily deferred Apple after its download stalled, then confirmed Apple sign-in and resumed iOS submission.

## Plan
Objective: permanent voluntary feedback, a one-time invitation after14 calendar days, and validated mobile release preparation. Hypothesis: private feedback produces actionable qualitative input and iOS expands access; neither outcome is measured. Scope: menu/persistence/privacy, iOS parity/branding/signing/store preparation, Android submission. Non-goals: accounts, cloud, analytics SDKs, paid services, automation and unrelated editor features.
Success/guardrails: only app name is prefilled; documents are never attached; failed handoffs remain retryable; optional prompt stays dismissed and hides while writing; enlarged-text/narrow layouts work; existing documents/tests survive; required native plugins are registered. Validate analysis, unit/widget suites, browser handoffs, native persistence/startup, builds, signing and package alignment. Owner approved privacy-page publication and Apple access/profile/distribution choices. Owner approved app-source commit/push/PR, leaving the app PR unmerged. Definition of done: validated store submissions and durable source record in an open PR.

## What was done
- **Completed:** isolated checkout and opportunity/plan record; preserved existing repositories and device data.
- **Completed:** permanent Share feedback / Rate GhostMark menu on both tabs;14-calendar-day optional invitation with local first-use/dismissal state; hidden with keyboard; failed launches retry; bounded scrollable invitation at large text sizes.
- **Completed:** shared Eunoia form GhostMark option in alphabetical order; public prefill and actual browser handoff verified. No response submitted. No document/device/version/account data attached.
- **Completed:** Privacy policy menu and separate non-dismissing handoff. Published app-specific policy at https://eunoialab.io/privacy/ghostmark through approved privacy PR106, commitd1b09174b21f5f475537e21ba03cddfae1bda242; Eunoia pipeline78 succeeded. Public page and app-menu handoff verified. Play privacy URL updated.
- **Completed:** Android release process refreshes generated plugin registration for release mode and rejects test-only integration registration. First candidate build failed compilation due to a leftover debug test plugin; corrected generated initialization and rejected the failed artifacts.
- **Completed:** signed Android1.5.0+12 AAB/APK, upload-key and16KB ZIP alignment checks, fresh/upgrade emulator startup checks. Existing differently signed Pixel installation was preserved; separate GhostMark emulator used.
- **Completed:** Google Play accepted final build12, no newly unsupported devices observed;100% rollout across existing178 target countries configured. Submitted build12 and corrected privacy URL. Publishing overview visibly shows Changes in review with quick checks still running. Managed publishing off means rollout follows approval. Public availability of12 is not verified.
- **Observed:** production dashboard showed earlier build11 active during continuation. Its intervening submission/release action was not performed or observed by this agent; final12 supersedes it. No assumption that build11 remained a draft.
- **Completed:** iOS identity io.eunoialab.ghostmark/minimum15, GhostMark display name and opaque icon sizes from existing artwork; unsigned release build and eight privacy manifests inspected.
- **Completed:** native iPhone/iPad starter, edit/autosave, preview, reload and feedback dismissal checks; actual candidate screenshots captured/visually reviewed at1206×2622 and2064×2752. Final iPhone/iPad checks and screenshots were refreshed with the privacy menu and real Apple rating ID. Both screenshot sets were accepted by Apple.
- **Completed:** owner-approved Apple Full Access app record6836976147; Apple1.5.0 listing/keywords/support/copyright/no-login notes/manual release saved. Existing-certificate GhostMarkAppStore profile generated, expires2027-11-05. No new key/certificate.
- **Completed:** refreshed profile downloaded, verified and installed; signed IPA exported and strict signature verification passed. Real Apple rating ID6836976147 embedded. Xcode reports GhostMark1.5.0(12) uploaded.
- **Completed:** subtitle, Productivity category,4+ age rating and owner-selected No third-party content saved. Free pricing and147 territories excludingEU/mainland China saved; Mac/VisionPro disabled. Reviewer contact reuse approved.
- **In progress:** final reviewer-contact persistence, build processing/attachment, privacy publication and App Review submission. Owner approved email/feedback collection disclosure for support/improvement, linked when email supplied, no tracking. Final Apple publication agreement pending. Native file/external handoffs remain unverified; manual public release follows approval.
- **Approved, in progress:** commit/push/open app GitHub PR. Leave app PR unmerged; no tag.
- **Completed:** final artifact fingerprints and iOS handoff saved; temporary Android signing config removed after builds. Task-started emulator/server cleanup performed when no longer needed.

## Validation
- Clean analysis and53 unit/widget tests pass, including calendar threshold, restart/dismissal, failed/successful handoff, both-tab menu,320px width,2x text, keyboard hiding and privacy link preserving invitation.
- Native iPhone/iPad integration passes for persistence/preview/invitation. Native iOS file import/export and external-app handoffs remain unverified.
- Browser release builds; feedback opens preselected form, privacy menu opens actual live GhostMark policy. Visual menu/policy review passed.
- Android AAB/APK signing uses established SHA1 39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0. APK signature and16KB ZIP alignment pass. Actual signed APK installs/upgrades isolated emulator and starts without Flutter/AndroidRuntime errors in checked logs.
- Final AAB SHA256:9c037d1d9a26dfd4d6bef7dc789321723c6b9816f8e0fdbc03f7f094575ed23d;53,176,617bytes. APK SHA256:60e4a22fa53bc8bb747a2873a5d12a0a8b463354fc9a2264b09513bc33a9a117;53,608,920bytes.
- Play submission proof: chat outputs/android-submitted-build12.jpg. Build12 review and quick checks remain external; submission is verified, approval/live rollout is not.

## Results
Fact: feedback, rating and policy access are implemented and validated; policy is live; final Android build12 is submitted. Fact: signed Apple build12 uploaded and listing preparation resumed. Fact: app-source publication is approved and underway. No claim of feedback responses, retention gains, Apple submission or final Android public availability.

## Follow-up
- **Metrics to monitor:** final Play review/rollout, startup/file/link complaints, absolute feedback and rating counts; monthly active devices. No tracking SDK or recurring monitor added.
- **Review date:**2026-11-26 for submission status; set feedback review28days after actual build12 public release. Earlier listing reviewNov23 and onboarding reviewDec12 remain relevant.
- **Risks and limitations:** low traffic prevents causal attribution; no in-app telemetry; physical native file/browser/store handoffs not newly exercised; Kotlin plugin migration warning upstream; Apple review submission still in progress; source merge remains unauthorized.
- **Ideas for future iterations:** automated Android artifact smoke tests, readability, math and search discovery.
