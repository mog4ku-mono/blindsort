# Weekly reports

One entry per week, newest at the top.

---

## Week 3 (September 28 – October 4, 2026)

**Done this week**
- Wired speech-to-text into the voice search overlay using the
  `speech_to_text` package. Voice now works in the deployed web build through
  the browser's Web Speech API. The overlay listens, shows what it heard, and
  submits the phrase after a short pause.
- Expanded the voice command parser to cover five command types: open the
  File Browser (optionally filtered by category), open Settings, go Home,
  search for a term, and open a specific file's details by matching the
  spoken words against file names.
- Added Android platform scaffolding (`flutter create . --platforms=android`)
  so the app can be installed on a real device via `flutter run -d android`.
- Added microphone, internet, and bluetooth permissions to
  `android/app/src/main/AndroidManifest.xml` and a `<queries>` block so
  Android 11+ can discover the speech recognition service.
- Disabled `device_preview` on native builds so the fake phone frame no
  longer appears inside a real phone. The frame stays on in the web build.
- Filled in the public repository's `docs/` folder: proposal, mockup,
  design system, weekly reports, security and privacy.

**In progress**
- Recording the demo video and building the presentation slides and square
  image for the finals submission.

**Blocked or stuck on**
- Native Android voice does not work on the test phone (a Huawei device).
  Huawei phones do not ship with Google Mobile Services, and
  `speech_to_text` on Android depends on Google's Speech Recognition
  Service. The web build works everywhere because Chrome uses a different
  API. Any Android phone with Google services would work; this specific
  phone cannot. Documented in the README as a known limitation.

**Decisions made, and why**
- Kept the controlled `file_insights.dart` dataset instead of attempting a
  live Gemini integration. A billable Gemini key cannot be safely deployed
  inside a public web build without a server-side proxy, and the controlled
  data already demonstrates the intended user experience. This matches the
  fallback path named in the revised proposal.
- Deferred `shared_preferences` persistence. Session state is held in
  `AppState` in memory, which is enough to demonstrate navigation and
  interaction. Disk persistence is the next task after the presentation.

**Hours spent, roughly:** ~10 hours.

**Next week I will:**
- Record the 3–5 minute demo video.
- Build the slides and the 1080×1080 square image.
- Submit the final project, presentation, and AI usage badge.

---

## Week 2 (September 23 – 27, 2026)

**Done this week**
- Completed the Settings screen with six cards (Accessibility, Speech,
  Appearance, Haptic Feedback, General, Reset to Defaults) opening inline
  sheets with toggles and dropdowns.
- Added dark mode. Toggling it from the Appearance sheet flips the entire
  app through a `ValueNotifier<ThemeMode>` that `MaterialApp` listens to.
- Built File Details: hero card, AI summary, swipeable preview carousel,
  details table, and three action buttons that each do something.
- Added the App Drawer with Recently Deleted (with restore), Storage
  overview, and About.
- Expanded `AppState` into shared session state so favorites, custom
  folders, deleted files, and settings survive route changes.
- Added delete and restore for files and folders, plus a multi-select file
  picker for custom folder contents.
- Fixed category tiles to be equal width with small gaps and a fixed-height
  label.
- Fixed the File Details action buttons so "Share" and "Locate" no longer
  wrap.

**In progress**
- Voice search was a visual tease at the end of this week. Real
  speech-to-text was completed in week 3.

**Blocked or stuck on**
- The widget test still fails on CI. The cause is that the test builds
  `BlindSortApp` directly, outside the `DevicePreview` wrapper, so
  `DevicePreview.locale` and `DevicePreview.appBuilder` behave differently
  than in the running app. The build and deploy still succeed because
  `flutter test` is marked `continue-on-error`.

**Decisions made, and why**
- Used `ValueNotifier<ThemeMode>` for the theme rather than pulling in a
  state management package. It matches the setState pattern used elsewhere
  and keeps the dependency list small.
- Put all shared state in `AppState` after discovering that per-screen
  state reset whenever the user navigated away.

**Hours spent, roughly:** ~12 hours.

**Next week I will:**
- Wire speech-to-text into the voice overlay.
- Add Android platform scaffolding.
- Fill in the public repository docs.
- Record the demo video.

---

## Week 1 (September 16 – 23, 2026)

**Done this week**
- Set up the public repository from the course template.
- Wrote the BlindSort Material 3 theme (`lib/theme.dart`) and the 8px
  spacing constants (`lib/constants/app_spacing.dart`).
- Added the `FileItem` model and the controlled sample dataset.
- Built the first three reusable widgets: `AppHeader`, `SectionCard`, and
  `FileListItem`.
- Built the first slice of the Home Dashboard with Recent Files and
  Favorites.
- Enabled GitHub Pages so pushes to `main` deploy the web build.
- Wrote the Week 1 increment report, journal entry, and security checklist.

**In progress**
- The remaining three screens (File Browser, File Details, Settings).

**Blocked or stuck on**
- The first GitHub Actions deploy failed with a 404 because Pages had not
  been turned on. Fixed by selecting "GitHub Actions" as the source on the
  Pages settings.
- The widget test failed on CI from the start.

**Decisions made, and why**
- Built bottom-up: theme first, then data, then widgets, then the first
  screen. This matched the order in the revised proposal and avoided
  refactoring layout when the data model changed.
- Kept the `device_preview` wrapper enabled so the browser demo opens at
  phone size instead of stretching across a desktop window.

**Hours spent, roughly:** ~10 hours.

**Next week I will:**
- Build File Browser, File Details, and Settings.
- Add shared state so favorites and folders survive navigation.
- Add the App Drawer.