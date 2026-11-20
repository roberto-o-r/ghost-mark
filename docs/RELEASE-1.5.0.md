# GhostMark 1.5.0 release status

Iteration completed, awaiting merge: [PR14](https://github.com/roberto-o-r/ghost-mark/pull/14), open and unmerged. No tag.

Android1.5.0+12 and the corrected privacy URL were submitted at100% rollout across the existing178 target countries. Google Play shows Changes in review. Managed publishing is off. Approval and public availability of12 are not verified.

Apple1.5.0(13) was submitted on2026-11-19 at20:17 local. App Review shows Waiting for Review, submission4192b913-4816-4ccd-8e37-66530ed447fa. Apple public release is manual after approval. Free pricing,147 territories excludingEU/mainland China, iPhone/iPad, no Mac/VisionPro, Productivity,4+, owner-selected No third-party content, no-login notes, approved existing review contact and six screenshots are saved. Privacy responses are published after owner approval: optional email for support; feedback for support/app improvement; linked when email supplied; no tracking.

Apple rejected the first uploaded iOS12 package during processing for unused media API purpose strings. Corrected13 excludes file-picker media/audio through CocoaPods; strict signature valid, DKImagePicker/DKPhotoGallery and photo/camera/location API references absent.13 completed Apple processing successfully and is the submitted build. Android12 unchanged. Use the13IPA; the12IPA and Android11 files are historical.

Feedback/rating/privacy menu, local14-day invitation and durable dismissal implemented. Only GhostMark is prefilled; documents/device/version data are never attached. Opening privacy does not dismiss the invitation.

Validation: clean analysis,53 unit/widget tests, native iPhone/iPad persistence/preview/invitation checks, corrected iOS13 iPhone regression, browser feedback/privacy handoffs, signed Android installation/upgrade/startup, established upload key and16KB ZIP alignment. Native file import/export and external-app handoffs were not newly exercised. See android-build12-artifacts.json and ios-build13-artifacts.json for fingerprints.

Privacy policy published and verified: https://eunoialab.io/privacy/ghostmark . Privacy PR106 completed; Eunoia pipeline78 succeeded.

Manual status review:2026-11-26. Measure qualitative feedback and absolute rating counts28days after actual final public release; no automation created. Source merge remains for owner review. Future engineering follow-up: restore SwiftPM when document-only file-picker dependencies are supported.
