# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.

## 1. How I used AI

### 2026-09-23 - Repository setup, theme, and first widgets

- **Tool:** ChatGPT and Claude
- **What I asked for:** I asked for help setting up the Flutter project structure - the Material 3 theme with a `ColorScheme.fromSeed` based on the `#1565C0` color from my midterm design system, the 8px spacing constants, the `FileItem` model, and the first reusable widgets.
- **What it gave back:** It generated `lib/theme.dart`, `lib/constants/app_spacing.dart`, `lib/models/file_item.dart`, and the initial `lib/widgets/app_header.dart`, `section_card.dart`, and `file_list_item.dart`.
- **What I kept, what I changed, and why:** I kept the overall structure because it matched the design system I had already written at midterms. I checked that the constructor parameters of every reusable widget matched what the design system documented. The theme seed color and the three text role sizes came from my own document, not the AI.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/d44724c

### 2026-09-23 - First slice of the Home Dashboard

- **Tool:** ChatGPT and Claude
- **What I asked for:** The Home Dashboard with the sections I had mocked up: Recent Files and Favorites, laid out with the `SectionCard` and `FileListItem` widgets I had just created.
- **What it gave back:** A `lib/screens/home_screen.dart` with a `StatefulWidget` that filters the sample file list into recent and favorite subsets.
- **What I kept, what I changed, and why:** I kept the section structure and the `ListView` layout. I later had to rework the category row and the voice search hero because the first version only had two sections, not the four the mockup showed.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/d0ff555

### 2026-09-25 - File Browser screen

- **Tool:** ChatGPT and Claude
- **What I asked for:** The File Browser with a Categories/Folders tab switch, a breadcrumb, a file list, and a sort menu.
- **What it gave back:** A `lib/screens/file_browser_screen.dart` with all four sections as private helper methods. It also generated the `FolderItem` model and the sample folder dataset so the browser had something to display.
- **What I kept, what I changed, and why:** I kept the general layout but reordered the sections to match the mockup — folders above files, not below. I also had to change how tab switching worked. The first version used an `AnimatedSwitcher` with a fixed key, which kept the old file list on screen when a folder was tapped. I replaced it with a direct rebuild so the filter update actually shows.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/f1bcefa

### 2026-09-26 - File Details screen

- **Tool:** ChatGPT and Claude
- **What I asked for:** The File Details screen with a hero card, an AI summary section, a swipeable preview carousel with chevrons, a metadata table, and the three action buttons (Open, Share, Locate).
- **What it gave back:** A `file_details_screen.dart` with all sections and a `PageView` for the preview. It also added `lib/data/file_insights.dart` with per-file summaries so the summary block had content to show.
- **What I kept, what I changed, and why:** I kept the structure but rewrote the preview section. The first version put the navigation chevrons as `Positioned` overlays on top of the content, which covered the bullets. I moved them into the header row so the preview card itself stays clean. I also added a per-file insight map so each file has its own summary rather than one generic one.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/7653a22

### 2026-09-26 - Settings screen and dark mode

- **Tool:** ChatGPT and Claude
- **What I asked for:** A Settings screen with six tappable cards (Accessibility, Speech, Appearance, Haptic Feedback, General, Reset to Defaults) and a working dark mode that flips the whole app.
- **What it gave back:** A `settings_screen.dart` and a `ValueNotifier<ThemeMode>` pattern in `app_state.dart` so the theme can change without a state management package. It also added `darkAppTheme` to `theme.dart` and rewired `main.dart` to listen for theme changes.
- **What I kept, what I changed, and why:** I kept the `ValueNotifier` approach because it matches the setState pattern used everywhere else in the app. I did not use a state management package because the app is small enough not to need one. The sheet layout went through two revisions — the first used bottom sheets with `SwitchListTile` and the second used inline rows with a teal highlight when a value is on, which is what the current version is.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/3c1dd5f

### 2026-09-26 - App Drawer with Recently Deleted and About

- **Tool:** ChatGPT and Claude
- **What I asked for:** A hamburger drawer on the Home screen with quick navigation, a Recently Deleted section that actually restores files, a Storage overview, and an About dialog.
- **What it gave back:** A `lib/widgets/app_drawer.dart` with all four sections, plus a `restoreFile` method in `AppState` that removes a file from the deleted set.
- **What I kept, what I changed, and why:** I kept the structure. I had to fix the About dialog's "Got it" button because the first version used the drawer's context to pop the dialog, so the button did nothing. I changed it to use the dialog's own builder context.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/2173114

### 2026-09-27 - Wiring search, voice, and the overflow menu into the File Browser

- **Tool:** ChatGPT and Claude
- **What I asked for:** The three icons on the File Browser app bar had empty `onPressed` callbacks from an earlier version. I asked for the search icon to open a text field that filters the list, the mic icon to open the voice search overlay, and the three-dot icon to become a real menu.
- **What it gave back:** A working `_openSearch`, `_openVoiceSearch`, and `_handleMoreMenu` method on the browser screen state, plus a search chip that appears in the active filters row so the user knows a search is running.
- **What I kept, what I changed, and why:** I kept the approach but added the search chip so clearing the search is one tap. I checked that clearing the search returns the full list, and that the search respects any active category or folder filter.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/2dbba0f

### 2026-09-28 - Wiring speech-to-text into the voice search overlay

- **Tool:** ChatGPT and Claude
- **What I asked for:** The voice search overlay was a visual tease that auto-dismissed after a few seconds. I asked for help wiring it to the actual device microphone using the `speech_to_text` package, and for a small parser that turns the recognized phrase into an intent the app can route.
- **What it gave back:** A `lib/services/voice_service.dart` that wraps the `speech_to_text` package, a `lib/utils/voice_command_parser.dart` that turns phrases into an enum, and a rewrite of the voice search overlay so it starts listening when it opens and returns an intent when it finishes.
- **What I kept, what I changed, and why:** I kept the overall structure but chose the specific phrases the parser matches. I also changed the listen durations — the default `listenFor` of 8 seconds was too short for someone who needs to speak clearly, so I set it to 12 seconds with a 2-second silence timeout. The overlay now returns a `VoiceIntent` back to the Home screen, which decides where to route.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/5a121f9

### 2026-09-29 - Expanding voice commands to categories, files, and search

- **Tool:** ChatGPT and Claude
- **What I asked for:** The first version of the voice feature only handled "open browser", "open settings", and "go home". I asked how to add commands for opening a category ("show documents"), opening a specific file ("open lecture 3"), and running a search ("search for database").
- **What it gave back:** A starting structure for `lib/utils/voice_command_parser.dart` that returns a `VoiceCommand` with a type and an optional value, plus the changes needed in `home_screen.dart` and `file_browser_screen.dart` to route the new command types.
- **What I kept, what I changed, and why:** I kept the substring-matching approach because it runs offline with no API key, and I decided which commands the parser should recognise. I chose the exact phrases each command matches, set how loose the file-name matching should be (score files by how many words from the phrase appear in the name, so "open lecture 3" works without needing the exact filename), and decided where each command routes in the app.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/0a56776

### 2026-09-29 - Adding Android platform and microphone permissions

- **Tool:** ChatGPT and Claude
- **What I asked for:** The project only had a web platform from the course template. I asked what was needed to run the app on a real Android phone, and how to make the voice feature work on device.
- **What it gave back:** The `flutter create . --platforms=android` command to add the Android folder, the exact permissions to add to `AndroidManifest.xml` (RECORD_AUDIO, INTERNET, BLUETOOTH, and a `<queries>` block so Android 11+ can find the speech recognizer), and a change to `main.dart` that only enables `device_preview` on web.
- **What I kept, what I changed, and why:** I kept the manifest permissions and the `kIsWeb` gate in `main.dart`. I verified the phone showed no more fake phone frame after the change, and the web build still shows the frame. The voice feature on Android turned out not to work on my specific test phone — a Huawei device without Google services — but the permissions are correct for any Android phone that has them.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/5587eab

## 2. Where the AI got it wrong

### Case 1 - Fast-forward merges hid the branch history

- **What it gave me:** Instructions to create feature branches, commit on them, and merge them to `main` from the terminal.
- **What was wrong with it:** Every merge fast-forwarded. That meant `main` looked like it had been committed to directly — no merge commit, no visible branch, no evidence I had been using branches at all. If someone looked at the commit graph, it looked like I was committing straight to `main` like a beginner.
- **What I did instead:** I ran `git config --global merge.ff false` so future merges always produce a merge commit, and I switched to a pull-request workflow starting with `feat/app-drawer`. Every merge from that point appears on the repository as a merged PR — PR #2 through PR #7.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/ec45dd4

### Case 2 - The settings sheet stayed light in dark mode

- **What it gave me:** A `showModalBottomSheet` with `showDragHandle: true` and a `ValueListenableBuilder<ThemeMode>` wrapper around the sheet's children.
- **What was wrong with it:** The wrapper updated the children when the theme changed, but the sheet's outer chrome — the drag handle strip at the top — was drawn by the framework using the theme captured at the moment the sheet opened. Turning dark mode on from inside the sheet updated everything except that strip, so the settings sheet had a white bar at the top while the rest of the app went dark.
- **What I did instead:** I turned off `showDragHandle` and drew the handle myself inside a `Container` that reads the current theme's surface color. This way, every part of the sheet re-reads the theme when it changes, including the drag handle.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/3921de3

### Case 3 - Category tiles were uneven

- **What it gave me:** A row of `CategoryNavigationItem` widgets laid out with `MainAxisAlignment.spaceBetween`.
- **What was wrong with it:** The "Documents" label wraps to two lines because it is longer than the others, which made its tile taller than the rest. On the File Browser, where there are five tiles, the effect was worse — the first tile looked bigger and each subsequent one smaller, because each was sized by its own content with no equal-width constraint. The tiles also touched each other with no gap, so the row looked smudged.
- **What I did instead:** I wrapped every tile in `Expanded` so they all get equal width, added a small `SizedBox` gap between them, and gave the label a fixed height so a two-line name does not stretch the tile. I also had to remove the `const` keyword from the row's children because Dart could not evaluate the color fields of a const object inside a const list.
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/efc175d

## 3. Who wrote what

### Written by @mog4ku-mono - planning documents

- **File:** `docs/01-proposal.md`, `docs/02-mockup.md`, `docs/03-design-system.md`
- **Commit:** Submitted at midterms in August 2026. These documents predate the code repository.
- **What they do and why they are built this way:** I wrote the proposal v2, the high-fidelity mockup, and the design system v2 for BlindSort during the midterm period, before any of the current implementation existed. The proposal covers the problem; blind and low-vision Android users struggle to find files by name alone; thus, the four-screen scope, the `shared_preferences` persistence choice, and the stretch goals. The mockup was made in Figma with high-fidelity screens for all four screens. The design system v2 lists the `#1565C0` seed color, the three text roles, the 8px spacing scale, and the eight reusable widgets by file path and constructor parameters. Every screen in the app was built against these documents.

### Written by @mog4ku-mono - voice command decisions and routing

- **File:** `lib/utils/voice_command_parser.dart`, `lib/services/voice_service.dart`, `lib/widgets/voice_search_overlay.dart`
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/5a121f9
- **What they do and why they are built this way:** These three files make voice navigation work. The file structure was scaffolded with AI assistance, but the decisions that shape the feature are mine:

  - **The five commands.** I decided which phrases the app should understand: opening the File Browser (with or without a category), opening Settings, going Home, running a search, and opening a specific file. Nothing else routes.
  - **The phrase list.** I chose the exact words each command matches — "browser" and "files" for the File Browser, "document"/"pdf" for the Documents category, "image"/"photo"/"picture" for Images, and so on.
  - **The file-name matching.** I chose to score files by how many words from the spoken phrase appear in the file name, so "open lecture 3" matches `Lecture_3_Database.pdf` without requiring the user to say the whole filename.
  - **The listen timings.** I set `listenFor` to 12 seconds and `pauseFor` to 2 seconds instead of the plugin defaults, because a blind user may need longer to speak clearly and a short silence should end the command.
  - **The routing.** Every `VoiceCommandType` has an explicit destination in `home_screen.dart` and `file_browser_screen.dart`. I decided which command opens which screen.

### Written by @mog4ku-mono - design decisions across the four screens

- **File:** Layout and behavior decisions across `lib/screens/`
- **Commit:** Multiple commits between September 25 and September 27.
- **What they do and why they are built this way:** I made the design decisions for each screen; which sections to include, how to order them, what each button should do based on the mockup I had already created at midterms. I also made the layout calls to match the mockup, including the darker teal section labels on File Details, the fixed action button widths, the category tile spacing, and the search chip in the File Browser. When an AI-generated screen did not match the mockup, I described the gap and gave specific direction for the fix.

### The AI-written part I understand best

- **File:** `lib/state/app_state.dart`
- **Commit:** https://github.com/mog4ku-mono/blindsort/commit/a08c519
- **What it does and why we kept it:** This file holds the shared session state. It is a static class with a `ValueNotifier<ThemeMode>` for theme mode and static fields for favorites, custom folders, folder contents, deleted files, and every settings toggle. It is a single class instead of per-screen state because four screens all need to know the same things; is this file favorited? Does this folder exist? Is dark mode on? If each screen owned its own copy, navigating between screens would reset what the user had done; this was a real bug I hit before this file existed. I kept the pattern because it uses only `setState` and `ValueNotifier` and does not pull in a state management package for a project this size.