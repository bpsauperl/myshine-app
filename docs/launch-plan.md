# myShine: purpose and roadmap

Last updated 19 November 2026.

## Purpose

**myShine is the patient's companion during Shine aligner treatment. The clinic gives it to the patient.**

It shows the plan and the schedule the doctor made. It reminds the patient to change aligners. When the doctor uses check-ins, it lets the patient report each change. It also lets the patient write to the clinic.

What myShine is not:
- **Not a shop.**
- **Not a diagnosis.** It never changes treatment; the doctor decides every step.
- **Not a smile simulation.** The made-on-the-phone preview was removed on 19.11.2026.

Who is responsible:
- The clinic is responsible for the patient's data (the controller).
- SmileLabs d.o.o. runs myShine for the clinic (the processor).
- SmileLabs never contacts patients (DPA art. 12).

## The purpose map

| The patient wants to… | Where in myShine |
|---|---|
| know which aligner they wear and when to change | **Today** |
| tell the doctor they changed: fit, note, optional photos (only if the doctor turned check-ins on) | **Today → Check in** |
| see what the treatment will do (when the doctor shared the plan) | **Plan** (3D link) |
| see every change date | **Schedule** |
| ask the clinic something, or send a photo | **Messages** |
| sign and keep their papers | **Profile → Documents** |
| reach the clinic: doctor, phone, email | **Profile → Your clinic**, and the last row on Today |
| be reminded to change (phones only) | **Profile → Reminders** |
| understand myShine and their data | **Profile → About myShine**, `/help`, `/privacy` |

Without a code, the welcome screen says what myShine is and "Ask your Shine clinic for your code".

## Rules that never change

- Access only through the clinic: a one-time code, valid 14 days. The clinic can disconnect a phone.
- **Check-in is the aligner change.** The doctor opts in per patient when therapy starts, and nothing is preselected. The doctor always stays in control of the schedule.
- Photos are taken only with the in-app camera, attached to a message (up to 3) or to a check-in (5 optional intraoral views). There is no free gallery.
- Not in the app: ads, tracking or analytics.
- Not in the app: real patient data in tests, previews or screenshots.
- The myShine API (`/api/myshine/v1`) only grows; existing fields never change.

## Design

- Real photography on the welcome screen only.
- Inside the app there are no drawings. The patient's own data is the hero: "Aligner 04/22", the next change, how far they are, the last check-in and the clinic.
- White and #f5f5f7 tiles, ink text, myShine teal as the only accent.
- Inter type. Light and dark both follow the phone.

## What v1.0 web does (19.11.2026)

- **Welcome:** a real photo, "What is myShine?", "I have a code", Privacy and Help.
- **Today:** the aligner, the next change, progress, days left, last aligner, start date, the check-in, the last check-in and the clinic.
- **Plan:** the 3D plan link once it is shared.
- **Schedule:** every aligner with its dates and its check-in.
- **Messages:** messages with the clinic, with photos.
- **Profile:** the clinic, reminders (phones only), documents to sign and open, About, and Disconnect.
- **Pages** at `myshine.smilelabs.app/help` and `/privacy`, in en, sl, de and sr. The translations are drafts for native review; the privacy text is a draft for legal review.
- **drShine Treatment center:** "Give a myShine code", then "Print for {name}": a one-page card with the code, the address and three steps.
- **Languages:** en, sl, de, sr. The translations are drafts for native review (`docs/translations-review.md`).

## Roadmap

| Phase | When | What | Who |
|---|---|---|---|
| 1. Web launch | 19.11.2026 | Redesign, Help and Privacy, printed code card, store pack. Clinics start giving codes. | done |
| 2. Store-ready builds | December 2026 | Apple Developer Program for **SmileLabs d.o.o.** (as an organisation: it needs a D-U-N-S number, about €99 a year) and a Google Play Console account. Signing, TestFlight and Play internal testing with a few clinics' patients. A demo clinic on production with a made-up patient for the reviewers. Native review of sl, de and sr. Screenshots. A "Delete my data" path for Google Play. | you: the accounts and the demo OK · me: the rest |
| 3. Push | January 2027 | Push notifications (a message from the clinic, a check-in due). This needs a new package and your OK. The last check-in's photos on Today (one new field in `/me`). "Find a Shine clinic". | me, after your OK |
| 4. Store launch | Q1 2027 | Submit to the App Store and Google Play, answer review, release. The web app stays as the fallback. | me, you approve |
| Later | n/a | The patient's own scan in 3D. A smile simulation only if a real service is behind it. | n/a |

## App Store / Google Play checklist

- [ ] **You:** enrol SmileLabs d.o.o. in the Apple Developer Program as an organisation. A health app must come from a company, not a person (guideline 5.1.1(ix)).
- [ ] **You:** create a Google Play Console account for SmileLabs d.o.o.
- [ ] **You:** confirm we own the rights to the welcome photo (`assets/images/welcome.webp`, from SmileStore).
- [x] iPhone only for 1.0 (`TARGETED_DEVICE_FAMILY = 1`, set 27.11.2026 so no iPad screenshots are needed; say if iPad should come back).
- [ ] **You:** say OK to a demo clinic on production for the reviewers, with a made-up patient and a code that keeps working.
- [ ] **A lawyer:** review the privacy text (`drshine/lang/*/myshine.php`, the page `myshine.smilelabs.app/privacy`).
- [ ] **Native speakers:** review sl, de and sr in the app and on the pages.
- [x] Bundle id `si.smilelabs.myshine`, the icon, the launch screen, the privacy manifest, `ITSAppUsesNonExemptEncryption = false`.
- [x] Phone builds talk to `https://myshine.smilelabs.app` (drShine production).
- [x] The privacy URL and the support URL exist (`/privacy`, `/help`).
- [x] Store texts, privacy-label answers, review notes and the screenshot list are in `docs/store/`.
- [x] The release build compiles without signing, and the English screenshots are in `docs/store/screenshots/en/` (27.11.2026). The steps from an active developer account to TestFlight: `docs/store/app-store-steps.md`.
- [ ] Signing: the iOS team in Xcode, and the Android upload key in `android/key.properties` (never in git).
- [ ] TestFlight and Play internal testing, then submission.
