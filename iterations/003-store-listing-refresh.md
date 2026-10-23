# Iteration 003: Store listing refresh

- **Date:** 2026-10-23 to 2026-10-23
- **Status:** Completed, awaiting owner's Play Console baseline, 1.2.1 upload and listing update
- **Area:** growth (plus an engineering fix found during the work)
- **PR / release:** PR_PLACEHOLDER; app version 1.2.1+6

## Context
GhostMark 1.2.0+5 has been live on Google Play since 2026-10-16. Tests (28) pass and the analyzer is clean. The store page hasn't kept up with the app:

- The screenshots in `Design/Store/Screenshots` date from May 2025. They predate Open/Save (1.1.0), the app bar actions and the formatting toolbar (1.2.0).
- The Play full description in `INFO.md` lists only Markdown support, mobile-first design, autosave and a simple UI. It doesn't mention Open/Save or the toolbar.
- `README.md` promises "direct publishing to WordPress", which doesn't exist, and calls the project "Modera".
- No Play Console data (store listing visitors, conversion, installs) has been available to any iteration. The review dates for 001 (2026-11-09) and 002 (2026-11-20) both depend on a baseline nobody has pulled.

## Options considered
1. **Store listing refresh with a baseline snapshot and an optional Play store listing experiment (chosen).** Two releases of product work are invisible on the page every new user sees. It's cheap, carries no code risk, and its effect can be measured.
2. Play Console baseline and review mining.
3. Interactive preview: tick checklist boxes and open links in View.
4. Undo snackbar after Clear / Open-replace.
5. Multiple documents (too large for one iteration).

## Plan
- **Objective:** make the Play listing accurately show what GhostMark does today, and record a conversion baseline so the change can be measured.
- **Hypothesis:** visitors who see the one-tap toolbar, preview and Open/Save in the screenshots and copy install at a higher rate than visitors who see the 2025 listing.
- **Deliverables:**
  1. A new screenshot set (1080×1920, same black-caption style), captured from the current app on an Android emulator.
  2. A rewritten short and full description for Play, within Play's limits (80 / 4000 chars).
  3. A corrected `README.md` (drop the WordPress claim and "Modera", describe real features, link to Play).
  4. An owner handoff: record the baseline numbers, upload the assets, and optionally start a store listing experiment (screenshots + short description) with the settings to use.
- **Non-goals:** app code changes, feature graphic or icon redesign, localisation, a new app version, paid promotion.
- **Success measure:** store listing conversion rate (store listing acquisitions ÷ store listing visitors, Play Console → Grow users → Store performance) for the 28 days after the update vs the 28 days before. If an experiment runs, Play's reported lift and confidence interval.
- **Guardrails:** install-to-uninstall ratio and rating don't get worse; the copy makes no claim the app doesn't meet; every screenshot matches the shipped 1.2.0 UI.
- **Validation:** check the copy against Play's character limits and policy (no rank or "best" claims, no keyword stuffing); review each image at full size for dimensions, legibility and accuracy against the running app; check README links.
- **Release:** the PR merges the assets and copy into the repo. The owner records the baseline, then uploads to Play Console (or starts the experiment). The listing counts as released only once the owner confirms it's live.
- **Definition of done:** assets and copy in the repo through a merged PR; handoff written; baseline numbers recorded or explicitly marked unavailable; status set to match what is actually live.

**Scope change (approved by the owner on 2026-10-23):** capturing the Save screenshot showed that Android's save dialog suggests the name `null.plain`. Files saved under that name are greyed out in GhostMark's Open, which only lists `.md`. The owner chose to fix it in this iteration as 1.2.1+6 instead of deferring it.

## What was done
- Completed: new screenshot set, `Design/Store/Screenshots/1.2.1/` (1-editor, 2-toolbar, 3-preview, 4-open-save). 1080×1920 in the same black-caption style as the 2025 set, captured from the 1.2.1 profile build on a Pixel 10 emulator at 1080×1920 with a demo-mode status bar. The 2025 set is kept unchanged.
- Completed: `Design/Store/Tools/compose_screenshots.py` (Pillow, Montserrat Bold) and `sample-document.md`, so the set can be regenerated after future UI changes.
- Completed: new short description, full description and a screenshot list in `INFO.md`, plus 1.2.1 release notes.
- Completed: `README.md` describes the real features and links to Play; removed the WordPress claim and "Modera".
- Completed (scope change): Save suggests a timestamped name, `ghostmark-YYYY-MM-DD-HHMMSS.md` (`defaultSaveFileName` in `markdown_codec.dart`). A fixed name like `document.md` was tried first and rejected: on a second save Android named the file `document.md (1)`, losing the extension, because the plugin sends a Markdown MIME type Android doesn't map to `.md`. Added 1 unit test and 1 widget test. Version 1.2.1+6.
- Completed: signed release bundle built (see Validation).
- Cancelled: running a Play store listing experiment by default. The old screenshots show a UI that no longer exists (no app bar actions, no toolbar), so keeping them as the control would show half of visitors an inaccurate listing for weeks, and traffic is unknown. Plan instead: publish directly and compare 28 days before and after. The experiment stays optional (see Release).
- Blocked on owner: recording the baseline, uploading 1.2.1, and updating the listing.

## Validation
- `flutter test`: 30/30 pass (28 existing + 2 new). The new widget test failed before the fix.
- `flutter analyze`: no issues.
- Emulator (Pixel 10 image, 1080×1920 override, profile build), Save before the fix: the default name was `null.plain`, and Open showed it greyed out. Typing `notes.md` by hand worked.
- Emulator, after the fix: two saves in a row produced `ghostmark-2026-10-23-110340.md` and `ghostmark-2026-10-23-110349.md`. A saved file reopened through Open and the Replace dialog, and its content (including emoji and a toolbar edit) matched.
- Screenshots: each reviewed at full size against the running app; all 1080×1920 (inside Play's 320–3840 px limits and its 2:1 maximum aspect ratio). The committed compose script reproduces all four pixel for pixel.
- Copy: short description 77/80 chars, full description 1,098/4,000, release notes 327/500. No ranking, "best" or price claims. Each feature claim was checked against the code: no account or network code, no ads SDK, local SharedPreferences storage, and the toolbar's 7 actions. The live Play page (fetched 2026-10-23) still shows the old description and the 1.2.0 notes.
- Bundle: `flutter build appbundle --release` succeeded (52.4 MB). Certificate SHA-1 `39:5D:0B:7D:B8:6C:91:52:7C:1C:4B:4D:85:67:9A:3E:66:CC:E1:A0` (the upload key); manifest shows version 1.2.1 and `com.eunoia.ghost_mark`.
- Not done: a test on the owner's A059P (no device was connected). The 1.2.0 → 1.2.1 code change is one call argument, and the emulator covered the real system save dialog.
- Observation, not explained: the profile APK grew from 72.6 MB to 89.5 MB between two builds in this session. The code change can't account for that, and the release bundle is what ships. If Play Console shows a download-size jump for 1.2.1, look at it then.

## Release
Not yet released. Owner steps, in order:
1. **Baseline (before changing anything):** in Play Console → Grow users → Store performance → Store analysis, last 28 days, note store listing visitors, store listing acquisitions and conversion rate. From Statistics, note average rating and daily installs/uninstalls. Paste them into the Results section below (or tell Claude).
2. Optional: device-test 1.2.1 on the A059P with `flutter run -d <device>` (debug variant, keeps data). Tap Save twice and check both files end in `.md`.
3. Merge the PR.
4. Upload `ghost_mark/build/app/outputs/bundle/release/app-release.aab` (1.2.1+6) with the Version 6 notes from `INFO.md`.
5. Store presence → Main store listing: replace the short description, full description and phone screenshots with the ones from `INFO.md` and `Design/Store/Screenshots/1.2.1/`, in order. Leave the title, icon and feature graphic as they are.
6. Optional experiment, only if Play's experiment setup estimates a result within about 6 weeks: Store listing experiments → default graphics, variant = new screenshots, metric = retained first-time installers. Otherwise skip it.
7. Once both are live, tell Claude: tag `v1.2.1` and mark this record released.

## Results
- Fact: the save bug is fixed and verified on an emulator. On the emulator, 1.2.0's Save suggested `null.plain`, which GhostMark can't reopen. Inference: every version since Save shipped (1.1.0) behaves the same on other Android devices, because the app never passed a file name. How many users this affected is unknown.
- Fact: the listing assets and copy now match the app as of 1.2.1.
- Baseline: not yet recorded (owner, step 1).
- Unknown: the effect on conversion. It can't be measured until the new listing has been live for 28 days.

## Follow-up
- **Metrics to monitor:** store listing conversion rate, 28 days after the new listing goes live vs the step 1 baseline; store listing visitors (to see whether traffic can support experiments); rating; uninstall rate; reviews mentioning saving or files.
- **Review date:** 2026-11-23 (about 28 days after the expected listing update; update it if the listing goes live later). Iteration 001's review (2026-11-09) and 002's (2026-11-20) can use the same baseline.
- **Risks and limitations:** before/after comparisons are noisy at low traffic, and seasonality or the 1.2.1 rollout can confound them. Users who already saved `null.plain` files can't open them in GhostMark; renaming the file to `.md` works. A second save within the same second would still hit Android's `(1)` renaming. The new screenshots will go stale with the next UI change; regenerate them with the script. Feature graphic and icon weren't reviewed.
- **Ideas for future iterations:** let Open accept `text/plain` / any text file so existing `null.plain` files can be recovered; suggest a file name from the document's first heading; interactive preview (tick checkboxes, tappable links); undo for Clear/Open-replace; Play Console review mining once the baseline exists; localised listing (Spanish) if store analysis shows demand.
