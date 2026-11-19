# myShine

The patient app for **Shine clear aligners** by SmileLabs (Slovenia). It's built in Flutter for iOS and Android, and runs as a web app at myshine.smilelabs.app (served by drShine itself; see "Web app" below).

- **Without an account:** the welcome screen (a real Shine photo) says what myShine is for and asks for the clinic's code. There is no smile simulation (removed on 19.11.2026).
- **With the connect code from the clinic:** the full myShine:
  - today's aligner and check-ins;
  - the link to the treatment plan in 3D;
  - the aligner schedule;
  - messages with the clinic;
  - consents to sign;
  - the clinic's contact details.

Store details:
- Bundle id: `si.smilelabs.myshine`
- Display name: **myShine**
- Version: `1.0.0+1`
- Orientation: portrait only

## API

The app follows the drShine app API **contract v1, section B** (`/api/myshine/v1`) to the letter.
- Contract: `app-api-contract.md`, section B (myShine app). A copy is in `docs/app-api-contract.md`.
- Backend: `~/code/drshine`, in `app/Http/Controllers/Api/MyShineController.php` and `routes/api.php`.

How the app talks to it:
- **Code layout:** all HTTP is in `lib/api/`, behind the `ApiClient` interface. `HttpApiClient` is the real client; tests use a fake.
- **Server address:** phone builds talk to `https://myshine.smilelabs.app` (drShine production); on the web the app uses the address it was loaded from (`lib/config.dart`). For DEV build with `--dart-define=MYSHINE_SERVER=https://drshine-dev-h4s1yo.laravel.cloud`, or in a debug build **long-press the myShine logo** on the welcome screen for the hidden "Server" setting.
- **Storage:** the token is kept with `flutter_secure_storage` (Keychain on iOS, Keystore on Android). The server address is kept in `shared_preferences`.
- **Expired sign-in:** a `401` takes the patient back to the welcome screen.
- **Connect code:** shown as `ABCD-2345` and sent in that form; the server ignores the dash. Codes never use 0, O, 1, I or L, and the app says so if one is typed.

## Run

```sh
export PATH="$HOME/development/flutter/bin:$PATH"
flutter pub get
flutter analyze
flutter test
flutter run                 # on a connected device or simulator
flutter run -d chrome       # web preview (no camera there: photos come from a file picker)
```

### Preview in a browser

```sh
flutter build web
cd build/web && python3 -m http.server 8092    # open http://127.0.0.1:8092
```

There is also a preview with made-up example data. It shows the connected screens without a server or a code:

```sh
flutter build web -t tool/preview_main.dart -o build/web-preview
cd build/web-preview && python3 -m http.server 8093    # open http://127.0.0.1:8093
```

Add `?welcome` to the address to start at the welcome screen. The preview never talks to a server.

### Web app (myshine.smilelabs.app)

drShine serves the web app itself: each release lives in its own folder under drShine's `public/myshine-web/`, drShine answers `myshine.smilelabs.app/` with that release's `index.html`, and the app calls `/api/myshine/v1` on the address it was loaded from. So there is nothing to configure and no CORS.

```sh
tool/publish_web.sh ~/code/drshine     # builds, and copies the release into drShine
# then commit and deploy drShine
```

The drawing engine (CanvasKit) is kept on our own server instead of being loaded from Google, and there is no service worker.

## Build and sign

### iOS (App Store)

You need a Mac with Xcode and an Apple Developer account.

1. Run `open ios/Runner.xcworkspace`. Under **Runner → Signing & Capabilities**, choose the SmileLabs team and keep the bundle id `si.smilelabs.myshine`.
2. In App Store Connect, create the app with the same bundle id.
3. Run `flutter build ipa --release`. Then upload `build/ios/ipa/*.ipa` with Transporter (or with Xcode → Organizer → Distribute).
4. Already set:
   - the camera text (`NSCameraUsageDescription`): "myShine uses the camera only for photos you choose to send to your clinic with a check-in or a message."
   - `ITSAppUsesNonExemptEncryption` = `false` (the app only uses HTTPS).
   - `UIRequiresFullScreen`, because the app is portrait only.

### Android (Google Play)

You need the Android SDK (Android Studio) and a Play Console account.

1. Create an upload key once, and keep it out of git:
   ```sh
   keytool -genkey -v -keystore ~/myshine-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties` (git ignores it):
   ```properties
   storePassword=...
   keyPassword=...
   keyAlias=upload
   storeFile=/Users/you/myshine-upload.jks
   ```
3. In `android/app/build.gradle.kts`:
   - load `key.properties` into `signingConfigs { create("release") { ... } }`;
   - use that config in `buildTypes.release`.

   Until then, release builds are signed with the debug key. The steps are at https://docs.flutter.dev/deployment/android#configure-signing-in-gradle.
4. Run `flutter build appbundle --release`. Upload `build/app/outputs/bundle/release/app-release.aab` to Play Console, with Play App Signing.

Already set:
- the camera permission (the camera is optional, so the app also installs on devices without one);
- `minSdk` of at least 23;
- portrait only;
- the `<queries>` that `url_launcher` needs (https, tel, mailto, Custom Tabs).

## Folder structure

```
lib/
  main.dart                    portrait lock, loads the session
  app.dart                     light and dark theme; welcome screen or the tabs
  config.dart                  default server, clinic finder URL, poll interval
  theme.dart                   Shine palette: white, #f5f5f7, ink #1d1d1f, teal #83c9cb
  api/                         ApiClient, HttpApiClient, models (contract v1, section B)
  state/                       Session (token and server), MeController (/me for all tabs)
  util/                        connect code formatting and validation, dates
  widgets/                     wordmark, cards, in-app browser helpers
  screens/
    welcome_screen.dart        real photo, "Your treatment, with your clinic.", the code
    about_sheet.dart           "What myShine is for": the purpose map, Help, Privacy
    connect_screen.dart        ABCD-2345 code, then POST /connect
    server_settings_sheet.dart the hidden "Server" setting
    home/                      Today, Plan, Schedule, Messages, Documents, Profile
test/                          unit and widget tests (with a fake ApiClient)
tool/preview_main.dart         example-data preview (not part of the app)
```

## What's left

The purpose, the rules, the roadmap and the App Store / Google Play checklist are in [`docs/launch-plan.md`](docs/launch-plan.md). The store texts, privacy-label answers, reviewer notes and screenshot list are in [`docs/store/`](docs/store/).

There is no real patient data anywhere: the tests and the preview use made-up example data only.
