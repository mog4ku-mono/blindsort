# Proposal

## The problem, in one sentence

Blind and visually impaired Android users who rely on screen readers often
struggle to identify, understand, and locate downloaded files because
traditional file managers provide limited spoken context beyond filenames.

## Who it is for

**Primary users.** Blind and visually impaired college students who use
Android smartphones with TalkBack to download, manage, and access lecture
notes, assignments, presentations, PDFs, and other academic files.

**Secondary users.** Individuals with low vision or users who prefer
voice-assisted file management.

**What they currently do instead.** Users typically rely on Android's default
file manager together with TalkBack to navigate folders and listen to
filenames one by one. Because filenames often provide little meaningful
context, locating the correct document can be slow and frustrating, especially
when many downloaded files have similar names. BlindSort focuses on this
specific situation rather than expanding into a general-purpose file
management application.

## Core features

The MVP is a four-screen accessibility-first application:

1. **Accessible File Browsing.** Browse files and folders with TalkBack. Every
   row is wrapped in a `Semantics` node so the screen reader reads the file
   name, type, size, and modified date as one unit.
2. **File Insights.** Open any file to see a summary and preview of what it
   contains, so a filename alone is not the only context available. The first
   implementation uses controlled sample data; a live AI integration remains a
   stretch goal.
3. **Smart File Categorization.** Files are grouped by type into Documents,
   Images, Videos, Audio, Apps, Archives, Favorites, and Downloads. Filters
   and sorting apply across the four screens.
4. **Voice Search and Voice Navigation.** The user speaks a command and the
   app routes: open the File Browser, open Settings, go Home, search for a
   file, or open a specific file's details. Speech recognition runs through
   the device's built-in speech engine, so no API key is needed.

The original plan estimated roughly 19 hours of first-implementation time
across these four features. That estimate covered the first demonstrable
version of each, not a production-ready file manager.

**Scope clarification for File Insights.** File Insights stays in the MVP
because it is the feature that most directly differentiates BlindSort from a
conventional file browser. The first implementation uses controlled insight
results when necessary, so the complete feature flow is demonstrable even if
a live AI service is unavailable. A Gemini-powered implementation is an
enhancement.

**Scope clarification for Voice Search.** Voice directly supports the
accessibility goal of BlindSort. The search flow was planned first as a
searchable dataset with a text field and filtering logic, with speech-to-text
integration attempted after the search flow was stable. Both parts shipped:
search works, and speech-to-text runs through the browser's Web Speech API.

## Out of scope, and why

The following are deliberately outside the minimum implementation. They are
stretch goals and only begin after the core application is stable:

- **Gemini/Gemma-powered File Insights.** Connect supported file information
  to a Gemini model to generate live summaries instead of relying only on
  controlled insight results.
- **Supabase Cloud Persistence.** Explore moving selected application data to
  Supabase for future synchronization, scalable storage, or multi-device
  functionality.
- **OCR and Image Understanding.** Extract and summarize text from images or
  scanned documents.
- **Smart Duplicate Cleanup.** Detect duplicate files and recommend files that
  may be safe to remove.
- **Storage Insights.** Analyze storage usage and identify unusually large or
  potentially unnecessary files.
- **Expanded Android File-System Integration.** Improve support for scanning
  and managing a larger range of real device files and storage locations.

The stretch-goal list is intentionally allowed to remain unfinished. The core
four-screen application must be completed before these features can affect
the project's definition of done. Cutting scope was a deliberate decision: a
smaller finished project is better than an unfinished ambitious one.

## Data the app remembers, and where it is saved

**Does the app need to remember anything?** Yes. BlindSort preserves user
preferences, favorites, cached file information, and generated or controlled
file insights between sessions.

**How many records?** The first version targets fewer than 100 persisted file
records in a realistic controlled dataset at a time. This includes cached
file metadata, saved file state, and generated or controlled file insights.
The small dataset means the MVP does not require a full remote database.

**Persistence choice.** The MVP uses `shared_preferences` for local
persistence. This fits the current scope because BlindSort is a single-user
application with a relatively small amount of data that needs to survive
restarts. It also avoids introducing authentication, networking, security
rules, and backend configuration before those capabilities are actually
required.

The main tradeoff is that `shared_preferences` is not a full database and is
not intended for large or highly relational datasets. If the application
later grows to hundreds or thousands of records or requires more complex
querying, the persistence layer will be reconsidered. Supabase is reserved as
a future direction for cloud persistence and future multi-device sync, but is
not an MVP dependency.

| Thing | Fields | Where it is saved |
| --- | --- | --- |
| File Metadata | fileId, fileName, filePath, fileType, modifiedDate | `shared_preferences` → JSON-encoded `file_metadata` list |
| File Insights | fileId, summary, category, insightSource, generatedDate | `shared_preferences` → JSON-encoded `file_insights` list |
| User Preferences | accessibility preferences, speech settings, appearance preferences, haptic feedback preference | Individual `shared_preferences` keys |
| Saved File State | fileId, isFavorite, lastOpenedDate | `shared_preferences` → JSON-encoded `saved_file_state` list |

All MVP data is local to the individual installation. BlindSort does not
require account synchronization or shared cloud data for the MVP.

## Risks

**Android file access and accessibility integration.** This remains the
primary implementation risk. The original proposal identified Android's
modern file-access system and compatibility with TalkBack as the major
technical risk. After completing Modules 1–5, confidence in implementing the
Flutter interface, navigation, lists, state, and reusable widgets increased;
the remaining uncertainty is concentrated in Android-specific file access and
device-dependent behavior.

First step to reduce the risk: build the File Browser using controlled/sample
file data first, verify the complete navigation flow, file list, categories,
and File Details transition, and only then attempt deeper Android file-system
integration. If native Android file access cannot be completed within the
planned scope, the controlled dataset remains the browser demonstration
fallback.

**AI and optional cloud features may consume time needed to finish the core
application.** Gemini integration introduces API-key security, service
availability, model integration, and browser deployment concerns. Supabase
introduces backend configuration, database design, security policies, and
networking work. Both technologies are useful extensions, but neither is
necessary for the core BlindSort user flow.

First step to reduce the risk: finish the core four-screen application and
local persistence before attempting Gemini or Supabase. If either experiment
begins consuming time needed for the core application, it is stopped and
moved to future work.

## Changes since the last version

The proposal above was submitted at midterms. This section records what
actually happened during the finals build so a reader can see what stayed the
same and what changed.

**2026-09-23 through 2026-09-27 — Core build.** All four screens shipped and
are reachable in the deployed web build: Home Dashboard, File Browser, File
Details, and Settings. The App Drawer was added as a fifth navigation surface
with Recently Deleted, Storage overview, and an About dialog. The drawer was
not in the original screen list but was added because the hamburger icon in
the mockup needed a purpose beyond duplicating navigation.

**Voice Search shipped as Voice Navigation.** The proposal scoped Voice
Search as a search flow first, with speech-to-text attempted only after the
search flow was stable. Both parts are now in the app. The `speech_to_text`
package drives the microphone through the browser's Web Speech API, and a
small parser turns a spoken phrase into one of five commands: open File
Browser (optionally filtered by category), open Settings, go Home, search for
a term, or open a specific file's details. No API key is needed because the
recognition runs through the device's built-in speech engine.

**File Insights still uses controlled sample data.** The proposal named this
as the guaranteed implementation, with live Gemini as a stretch enhancement.
That is what shipped. Each sample file has its own summary and preview pages
in `lib/data/file_insights.dart`. A live Gemini integration was not attempted
because a billable API key cannot be safely deployed inside a public web
build without a server-side proxy, and the controlled fallback demonstrates
the intended experience.

**Persistence uses in-memory session state, not `shared_preferences` yet.**
The proposal named `shared_preferences` as the MVP persistence layer. The
current build uses a shared `AppState` class that holds favorites, custom
folders, deleted items, settings toggles, and theme mode for the duration of
a session. Reloading the page resets these values. The `shared_preferences`
spike is the next task after the presentation is submitted.

**Dark mode was added.** The design system v2 explicitly scoped the capstone
to light mode only. The final build ships a working dark theme that flips
the whole app from the Appearance sheet in Settings. This was an addition,
not a scope change — the widgets already read through `Theme.of(context)`,
so a dark `ColorScheme` was a small amount of extra work.

**Delete, restore, and custom folder management were added.** The proposal
did not call these out as named features, but they are the natural
completion of "Smart File Categorization." Long-pressing any file opens a
sheet with favorite, add-to-folder, remove-from-folder, and delete. Deleted
files land in the App Drawer's Recently Deleted section and can be restored.
Custom folders can be created, renamed, deleted, and populated with any
sample file.

**Testing and deployment are live.** The GitHub Actions workflow deploys the
web build to GitHub Pages on every push to `main`. The `flutter analyze`
pass is clean. The widget test that fails on CI is a known issue listed in
the repository README.