# Privacy answers for the stores

These follow what the app really does: `lib/api/`, the drShine myShine API, and `ios/Runner/PrivacyInfo.xcprivacy`. If the app starts collecting anything new, update this file first.

## App Store: App Privacy ("nutrition label")

**Tracking:** No. The app does not track people across apps or websites. There are no ads, no analytics and no third-party SDKs that collect data.

**Data linked to the user.** All of it is used only for **App Functionality**:

| Apple data type | What it is in myShine |
|---|---|
| Contact Info → Name | The first name the clinic entered. It comes from the clinic and is shown to the patient. |
| Health & Fitness → Health | Check-ins: aligner changes, fit, comfort, on time or late. Also the treatment schedule. |
| User Content → Photos or Videos | Photos the patient chooses to send with a message (up to 3) or a check-in (up to 5 intraoral views). |
| User Content → Other User Content | Messages to and from the clinic. |
| Identifiers → User ID | The sign-in token tying the phone to the patient's record at the clinic. |

**Data not collected:**
- location, contacts, browsing history, search history;
- purchases, financial info;
- diagnostics and crash data (no crash reporter);
- usage data.

The smile preview was removed, so no face photo is ever taken.

## Google Play: Data safety

- **Does the app collect or share user data?** It collects data. It does not share it with third parties; the data goes only to the patient's own clinic, through SmileLabs as the clinic's processor.
- **Encrypted in transit:** yes (HTTPS only).
- **Can users ask for their data to be deleted:** yes, through their clinic, which keeps the medical record. Disconnect in Profile removes the sign-in from the phone.
  - Play also asks for a web link for deletion requests. Before submission, add a "Delete my data" section to `/help` that explains the clinic path. That work is in phase 2.

**Data types**, all collected for app functionality, none shared, none optional except where noted:

| Play data type | What it is in myShine | Optional? |
|---|---|---|
| Personal info → Name | From the clinic | no |
| Health and fitness → Health info | Check-ins, the schedule | — |
| Photos and videos → Photos | Only when the patient adds them | **yes** |
| Messages → Other in-app messages | Messages with the clinic | — |
| App info and performance | Not collected | — |

## The permissions the app asks for

- **Camera (iOS `NSCameraUsageDescription`, Android `CAMERA`):** "myShine uses the camera only for photos you choose to send to your clinic with a check-in or a message." The camera is optional; the app installs on devices without one.
- **Notifications:** local reminders on the day of an aligner change. They are planned on the phone and need no server.
