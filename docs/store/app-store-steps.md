# App Store: from an active developer account to TestFlight

What is ready in this repository, and the steps that need the Apple account. Written 27.11.2026.

## Ready

- **The app:** bundle id `si.smilelabs.myshine`, name myShine, version 1.0.0 (build 1), iOS 15 or later, iPhone only.
- **Icon and launch screen:** the Shine arch and star on teal; the official myShine logo on the launch screen.
- **Release build:** `flutter build ios --release --no-codesign` builds (checked 27.11.2026). It talks to `https://myshine.smilelabs.app`.
- **Permissions:** camera only, with its sentence in `Info.plist`. Reminders ask when the patient turns them on.
- **Export compliance:** `ITSAppUsesNonExemptEncryption = false` (only standard HTTPS), so App Store Connect does not ask.
- **Privacy manifest:** `ios/Runner/PrivacyInfo.xcprivacy` (no tracking; name and user id for app functionality).
- **Texts:** `listing.md` (en, sl, de), `privacy-answers.md` (the App Privacy questions), `review-notes.md`.
- **Screenshots:** `screenshots/en/` at 1320 × 2868 (iPhone 6.9″), made from example data.
- **Pages:** support `https://myshine.smilelabs.app/help`, privacy `https://myshine.smilelabs.app/privacy`.

## Steps with the Apple account

1. **Team in Xcode.** Sign in to Xcode with the Apple ID of the developer account (Xcode → Settings → Accounts). Open `ios/Runner.xcworkspace`, target Runner → Signing & Capabilities, tick "Automatically manage signing" and choose the SmileLabs d.o.o. team. Xcode registers `si.smilelabs.myshine` by itself. Tell me the Team ID (10 characters) and I put it into the project, so builds from the command line sign too.
2. **App record.** In App Store Connect → Apps → "+" → New App: iOS, name myShine, primary language English, bundle id `si.smilelabs.myshine`, SKU `myshine`.
3. **Upload a build.** `flutter build ipa --release`, then upload `build/ios/ipa/myshine.ipa` with Transporter or from Xcode's Organizer. It shows under TestFlight after Apple's processing (about 15 minutes).
4. **TestFlight.** Add yourself as an internal tester and install it with the TestFlight app. Test with a real code from drShine.
5. **Store page.** Paste the texts from `listing.md`, upload the screenshots, answer App Privacy from `privacy-answers.md`, age rating 4+, category Medical.
6. **Review information.** Paste `review-notes.md` with the demo code and your contact. The reviewers need a code that works: a made-up patient in a demo clinic on production (needs your OK; I set it up).
7. **Submit for review.**

## Still open before submitting

- **Demo clinic for the reviewers** on production (your OK).
- **Rights to the welcome film and photo** (your own clips; confirm).
- **Privacy text** reviewed by a lawyer; sl, de and sr read by native speakers.
- **A company account.** A health app must come from a company (guideline 5.1.1(ix)): the developer account has to be SmileLabs d.o.o. as an organisation, not a personal one.
- **Sign in with SmileID** comes later; today the code connects the app, so Apple's rule on third-party sign-in (4.8) does not apply.
