# Screenshots

Every screenshot is made from the example-data preview (`tool/preview_main.dart`), never from a real patient. Make a set for each language you list: en first, then sl and de.

```sh
flutter build web -t tool/preview_main.dart -o build/web-preview --no-web-resources-cdn
cd build/web-preview && python3 -m http.server 8044     # http://127.0.0.1:8044
```

Useful addresses:
- `/?welcome`: the welcome screen
- `/`: Today
- `/?late`: Today with a late change

## The set (in this order)

| # | Screen | Caption (en) |
|---|---|---|
| 1 | Welcome | Your treatment, with your clinic. |
| 2 | Today | Which aligner today, and when to change. |
| 3 | Today → Check in (the form open) | Tell your doctor you changed. |
| 4 | Plan | Your plan in 3D. |
| 5 | Schedule | Every change date. |
| 6 | Messages (with a photo) | Write to your clinic. |
| 7 | Profile → About myShine | What myShine is for. |

## Sizes

**App Store:**
- iPhone 6.9″: 1320 × 2868 portrait. This set is required; Apple scales it down for smaller iPhones.
- iPad 13″ (2064 × 2752): only if the app stays available on iPad (`TARGETED_DEVICE_FAMILY = "1,2"` today). My recommendation is iPhone only for 1.0 (see `docs/launch-plan.md`).

**Google Play:**
- phone screenshots, at least 2: 1080 × 1920 or larger, 9:16;
- feature graphic 1024 × 500: the welcome photo with the myShine wordmark, no extra text;
- icon 512 × 512, from `tool/brand`.

Captions sit above the screen in Inter Bold, ink on #f5f5f7, without device frames or gradients (smilelabs-design).

## The English set (27.11.2026)

`screenshots/en/` holds the seven screens at 1320 × 2868, taken in the iPhone 18 Pro Max simulator from the example-data preview (light mode, status bar at 9:41): `1-welcome`, `2-today`, `3-check-in`, `4-plan`, `5-schedule`, `6-messages`, `7-about`. They are plain screens, without captions; App Store Connect takes them as they are.

To make them again:

```sh
flutter build ios --simulator --debug -t tool/preview_main.dart
xcrun simctl install booted build/ios/iphonesimulator/Runner.app && xcrun simctl launch booted si.smilelabs.myshine
xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl io booted screenshot docs/store/screenshots/en/2-today.png
```

The welcome screen comes after Profile → Disconnect in the preview. The sl and de sets are still to make (set the simulator's language first).

