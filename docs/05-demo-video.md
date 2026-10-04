# Demo video

**File:** Hosted on Google Drive (see link below)
**Length:** 4 minutes 57 seconds
**Recorded on:** Laptop with a Maono microphone for voice narration

**Presentation folder (video, slides, square image):**
https://drive.google.com/drive/folders/1S3Q1-ws4h56F4GA_0P4048nOKmTO4Jq6

Files inside the folder:

- `blindsort-demo-video_mog4ku-mono.mkv` — the walkthrough
- `blindsort-slides_mog4ku-mono.pdf` — the slide deck
- `blindsort_mog4ku-mono_[1080x1080].png` — the square image

## What it shows

A short list, in order, so a viewer can skip to what they need:

- 0:00 what the app is and who it is for
- 0:20 the problem BlindSort is solving
- 0:40 the four screens, one design choice from each
- 1:50 voice commands, with the parser explained
- 2:25 the tech stack and design system
- 2:43 the AI segment — how AI was used, what was written by hand, and
  three cases where the AI got it wrong and I caught it
- 4:06 challenges, what's next, and closing

The video walks the main user journey end to end. It also covers the voice
command flow, which is the app's core accessibility feature.

## One thing that only works on some devices

Voice commands run through the browser's Web Speech API on web, and Android's
`SpeechRecognizer` on device. On a native Android build, the speech service
depends on Google Mobile Services being present. My test phone is a Huawei
device that ships without Google services, so native voice does not run on
that specific phone even though the code and permissions are correct. Any
Android phone with Google services — a Pixel, a Samsung, most Xiaomi and
Realme devices — would run the same code without changes.

## Before recording

- Real data off the screen. No classmates' names, numbers, faces, or
  messages.
- Notifications off.
- Sensible sample data. The app already uses invented file names like
  `Lecture_3_Database.pdf`.
- One unbroken take per feature. Say what is happening while it happens.