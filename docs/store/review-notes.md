# Notes for the app reviewers

Paste the text below into App Store Connect → App Review Information → Notes, and into the Google Play "App access" section. Fill in the demo code once the demo clinic exists (phase 2, needs the user's OK).

---

myShine is the patient app for Shine clear aligner treatment. It is made by SmileLabs d.o.o. (Slovenia), which runs it for dental clinics.

**Accounts.** Patients cannot create an account themselves. Their dental clinic gives them a one-time code in the clinic's own system (drShine), and the code connects the phone to the patient's record. To review the app, use this demo code: **[DEMO CODE]**. It belongs to a made-up demo clinic with a made-up patient in treatment, and it can be used more than once.

**What to look at after connecting:**
- **Today:** the current aligner and the next change. **Check in** reports an aligner change, with optional photos taken with the in-app camera.
- **Plan:** opens the treatment plan in 3D in a browser view.
- **Schedule:** every aligner with its dates.
- **Messages:** messages with the demo clinic. Photos are optional.
- **Profile:** the clinic's contact details, reminders, documents, **About myShine** (what the app is for, Help, Privacy), and **Disconnect**.

**Medical.** myShine does not diagnose, plan or change treatment. It shows the plan and schedule that the patient's own dentist made, and lets the patient talk to that dentist. Treatment is planned and supervised by the dentist.

**Data and deletion.** The clinic is the data controller, and the record is part of the patient's medical record, which the clinic must keep by law. **Disconnect** (Profile) removes the sign-in from the phone. Patients ask their clinic to delete or export their data. The privacy policy is at https://myshine.smilelabs.app/privacy. The app has no ads, tracking or analytics.

**Contact for review questions:** [SmileLabs contact name, phone, email]. The user fills this in.

---

Before submitting:
- [ ] The demo clinic and patient exist on production, and the demo code works (test it on a clean install).
- [ ] The demo patient has a shared plan, a few schedule rows, one message from the clinic and one document, so every tab has something to show.
- [ ] Check-ins are on for the demo patient, so the reviewer sees Check in.
