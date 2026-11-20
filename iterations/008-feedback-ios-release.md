# Iteration 008: Private feedback and Android/iOS submissions

- **Date:** 2026-11-19 to 2026-11-19
- **Status:** Iteration completed, awaiting merge — PR14
- **Area:** product / research / engineering / distribution
- **Version:** Android 1.5.0+12 submitted; iOS 1.5.0 (13) submitted
- **PR:** App PR14: https://github.com/roberto-o-r/ghost-mark/pull/14 (open, unmerged). Privacy PR106: https://eunoiaorg.visualstudio.com/Eunoia/_git/Eunoia/pullrequest/106 (completed).

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
- **Completed:** review contact copied with owner approval and corrected format; final privacy accuracy/compliance declaration approved and responses published. Optional email is disclosed for support; feedback for support and qualitative app improvement (Apple Analytics category), linked when email provided, no tracking.
- **Corrected:** Apple processing rejected iOS12 for missing photo/camera purpose strings from unused file-picker media dependencies. Switched this project to CocoaPods and disabled PICKER_MEDIA/PICKER_AUDIO, preserving PICKER_DOCUMENT. Signed iOS13 built, strict signature verified; DKImagePicker/DKPhotoGallery and photo/camera/location API references absent. Android12 unchanged. Xcode confirmed iOS13 uploaded; native iPhone regression passed after the dependency change.
- **Completed:** Apple processing for13 completed successfully; attached13 to1.5.0 and submitted. App Review visibly shows Waiting for Review, submission4192b913-4816-4ccd-8e37-66530ed447fa, submitted2026-11-19 at20:17 local. Apple public release remains manual after approval. Native file/external handoffs remain an explicitly unverified validation limitation.
- **Completed:** committed, rebased onto origin/main, pushed and opened app GitHub PR14. App PR left unmerged; no tag. Validated release correction included in the same PR.
- **Completed:** final artifact fingerprints and iOS handoff saved; temporary Android signing config removed after builds. Task-started emulator/server cleanup performed when no longer needed.

## Validation
- Clean analysis and53 unit/widget tests pass, including calendar threshold, restart/dismissal, failed/successful handoff, both-tab menu,320px width,2x text, keyboard hiding and privacy link preserving invitation.
- Native iPhone/iPad integration passes for persistence/preview/invitation. Native iOS file import/export and external-app handoffs remain unverified.
- Browser release builds; feedback opens preselected form, privacy menu opens actual live GhostMark policy. Visual menu/policy review passed.
- Android AAB/APK signing uses established SHA1 39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0. APK signature and16KB ZIP alignment pass. Actual signed APK installs/upgrades isolated emulator and starts without Flutter/AndroidRuntime errors in checked logs.
- Final AAB SHA256:9c037d1d9a26dfd4d6bef7dc789321723c6b9816f8e0fdbc03f7f094575ed23d;53,176,617bytes. APK SHA256:60e4a22fa53bc8bb747a2873a5d12a0a8b463354fc9a2264b09513bc33a9a117;53,608,920bytes.
- iOS13 IPA SHA256:346b3292b0822e450e0fbf7363d42e1ec80fbe80a4f565f0992d4332489c18f0;21,499,475bytes. Strict signature verification, real rating ID, document-only native dependency inspection and corrected-build iPhone regression pass. Apple submission proof: chat outputs/apple-submitted-build13.jpg.
- Play submission proof: chat outputs/android-submitted-build12.jpg. Build12 review and quick checks remain external; submission is verified, approval/live rollout is not.

## Results
Fact: feedback, rating and policy access are implemented and validated; policy is live; final Android build12 is submitted. Fact: Apple12 failed processing; corrected13 completed processing and was submitted, Waiting for Review. Privacy responses published. App source is in open, unmerged PR14. No claim of feedback responses, retention gains, store approval or final public availability.

## Follow-up
- **Metrics to monitor:** final Play review/rollout, startup/file/link complaints, absolute feedback and rating counts; monthly active devices. No tracking SDK or recurring monitor added.
- **Review date:**2026-11-26 for submission status; set feedback review28days after actual build12 public release. Earlier listing reviewNov23 and onboarding reviewDec12 remain relevant.
- **Risks and limitations:** low traffic prevents causal attribution; no in-app telemetry; physical native file/browser/store handoffs not newly exercised; Kotlin plugin migration warning upstream; store reviews/public availability remain external; source merge remains unauthorized; temporary CocoaPods fallback needs revisiting when file-picker SwiftPM supports excluding media.
- **Ideas for future iterations:** automated Android artifact smoke tests, readability, math and search discovery.

## Closeout checklist
- Completed: selected feedback opportunity; implementation, policy/form changes, analysis/tests/native smoke/build verification, signing, authorized Android/iOS submissions, source commit/push/open PR, release documentation.
- Deferred follow-up: store decisions and eventual Apple manual public release; qualitative outcome review28days after actual public availability. No automation activated.
- Validation limitation retained: native file import/export and external-app handoffs were not newly exercised; no claim those checks passed.
- Source merge: intentionally awaiting owner review; PR14 remains open, no tag.
