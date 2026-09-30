# Security and privacy

This repository is public. The information below reflects the current state of
the project and is checked as part of grading.

**Last checked:** 2026-09-30

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Favorites, custom folders, deleted items, settings toggles, theme mode | In memory in `AppState` for the current browser session only. Nothing is written to disk or sent to a server. | Only the person using the browser. |
| Sample files, folders, and insights | Controlled dataset committed in `lib/data/` and `lib/models/`. All values are synthetic. | Anyone reading the public repository. |
| Microphone input (voice search) | Captured in the browser session while the voice overlay is open. Audio is sent to the browser's built-in speech recognizer service (Google in Chrome) for transcription. Nothing is stored by the app. | Only the speech service the browser uses. |

No user data is stored on a server, written to disk, or shared between
sessions. Reloading the page resets everything.

## Secrets

- **Values my app needs at run time:** None. There are no API keys, tokens,
  or passwords in the deployed build. The voice feature uses the browser's
  Web Speech API, which does not require a key. File Insights uses a
  controlled dataset in `lib/data/file_insights.dart`.
- **Where they live locally:** `.env` and `.env.example` exist in the
  repository as template placeholders only. Both are unused.
- **Where the deploy workflow gets them:** The `.github/workflows/deploy-web.yml`
  workflow does not reference any repository secrets. It runs
  `flutter pub get`, `flutter analyze`, `flutter test`, and
  `flutter build web`, then uploads the resulting `build/web` folder to
  GitHub Pages.
- **Anything my deployed web build carries that a visitor could read:** Only
  Flutter's runtime assets and the compiled Dart bundle. No keys, tokens, or
  hidden config values. There is nothing sensitive in the deployed client.

## What protects the data on the service side

Nothing leaves the device. BlindSort has no backend, no Firebase project, no
Supabase project, and no server. Everything the app does happens in the
browser or on the phone. There is nothing to protect on a service side
because there is no service.

## Checklist

- [x] `.env` is in `.gitignore`, and `.env.example` is committed (both are
      template placeholders, unused)
- [x] `git log -p | grep -i "api_key\|secret\|password\|token"` finds
      nothing real — only the placeholder text from the course template's
      initial commit
- [x] No service account file, keystore, or `service_role` key anywhere in
      the repository
- [x] No security rules to write (no backend, no Firestore, no Supabase)
- [x] No real personal data in sample data, screenshots, or the video. All
      sample files are synthetic: `Lecture_3_Database.pdf`,
      `Group_Presentation.pptx`, and similar names invented for the mockup.
- [x] No course or university credentials anywhere in the repository
- [x] No third-party data. Every file name, folder name, and screenshot is
      either invented or captured from the running app.

## Anything found and fixed

The security pass surfaced two things during week 2 that are documented in
the workspace `project/SECURITY-CHECKLIST.md`. First, the git author email
in every commit is a personal one because `git config` uses it, which is
visible in the public commit history. It does not appear in any file or
commit message body. Second, the GitHub Actions workflow uses moving
version tags for its third-party actions rather than pinned commit SHAs.
The template ships this way and the actions are all first-party
GitHub-maintained, but it is a real gap worth noting.