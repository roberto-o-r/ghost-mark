# Product backlog

## PBI: Replicate Modera's privacy-preserving feedback system

- **Status:** Proposed
- **Area:** Product / feedback
- **Goal:** Give GhostMark users an easy, always-available way to share anonymous feedback or rate the app without adding tracking or sending document data.
- **Reference:** Adapt Modera's feedback channel from `iterations/004-feedback-channel.md`, including its shared Google Form, pre-filled app name, persistent dismissal, delayed prompt, and store-rating action.

### Proposed experience

- Add **Share feedback** and **Rate GhostMark** to an overflow menu in the app bar without disrupting Open, Save, and Clear.
- Open the existing shared Eunoia Google Form in the external browser with `GhostMark` pre-selected in the required **Which app is this about?** field.
- Keep the form anonymous by default: no Google sign-in, no automatically collected email, and an optional reply email field.
- Show a dismissible, one-time feedback prompt after 14 calendar days of use. Choose a placement that does not reduce the editor's usable space or interrupt writing.
- Persist first-use and dismissal state locally with SharedPreferences.
- Open GhostMark's Google Play listing when the user chooses **Rate GhostMark**.

### Acceptance criteria

- The feedback form opens externally with `GhostMark` pre-selected and does not send document text, device details, app version, or other app data.
- Share feedback and Rate GhostMark remain available from the app bar after the one-time prompt is dismissed.
- The prompt is not eligible before 14 calendar days, appears at most once, and stays dismissed across restarts after any action or dismissal.
- Existing Open, Save, Clear, Edit, and View interactions remain accessible at supported phone widths.
- URI construction, prompt eligibility, persistence, menu actions, and the prompt UI have automated coverage.
- Browser validation covers layout and persistence; Android validation covers the external browser and Play-listing handoffs because those are mobile-specific.

### Dependencies and preparation

- Add `GhostMark` as an exact dropdown option in the shared Google Form before release; reuse the existing form and entry IDs.
- Add a store-listing launcher dependency or an equivalent Play listing URI; GhostMark already includes `url_launcher` for the feedback form.
- Review the form copy and privacy disclosures to preserve GhostMark's no-account, no-cloud positioning.

### Non-goals

- No in-app form submission, analytics SDK, automatic diagnostics, document attachment, mandatory email address, or backend owned by GhostMark.

### Success signals

- At least one actionable GhostMark response without a new privacy complaint or document-data collection.
- Any change in written-review volume or rating should be reported with absolute counts because current traffic is low.
