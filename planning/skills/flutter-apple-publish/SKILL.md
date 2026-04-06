---
name: flutter-apple-publish
description: >
  Complete end-to-end guide for publishing a Flutter iOS app to Apple App Store Connect and TestFlight.
  Use this skill whenever the user mentions: submitting a Flutter app to the App Store, uploading an IPA,
  setting up TestFlight, fixing Transporter errors, configuring Info.plist for App Store validation,
  aligning Firebase with Apple account settings, setting up App Check or enabling Firebase Analytics for
  an iOS Flutter app, generating iOS app icon sizes, or any combination of these. Also trigger when the
  user says things like "deploy my Flutter app to Apple", "get my app on TestFlight", "Transporter gave
  me an error", or "my IPA was rejected". This skill covers the full pipeline from App Store Connect setup
  to a successfully delivered build.
---

# Flutter → Apple App Store / TestFlight — Publishing Skill

This skill guides you through every step of publishing a Flutter app to Apple's ecosystem.
Work through the phases in order, skipping any that are already done.

---

## Phase 0 — Prerequisites checklist

Before starting, confirm the following exist:

- [ ] Apple Developer account (paid, $99/yr) at [developer.apple.com](https://developer.apple.com)
- [ ] App Store Connect access at [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- [ ] A registered **Bundle ID** in the Apple Developer portal (e.g. `com.yourcompany.appname`)
- [ ] A valid **Distribution Certificate** + **Provisioning Profile** installed in Xcode
- [ ] Flutter project with iOS target configured (`ios/` folder present)
- [ ] Firebase project (if using Firebase services)

> **Account pitfall**: Apple supports multiple teams on one login. Always confirm you are in the **correct team** before creating apps, bundle IDs, or certificates. A mismatch between the team that owns the Bundle ID and the team selected in App Store Connect is one of the most common sources of confusion.

---

## Phase 1 — Register the Bundle ID (if not yet done)

1. Go to [developer.apple.com → Certificates, IDs & Profiles → Identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click **+**, choose **App IDs → App**
3. Fill in:
   - **Description**: human-readable app name
   - **Bundle ID**: Explicit, e.g. `com.yourcompany.appname`
4. Enable capabilities your app uses (Push Notifications, Sign in with Apple, etc.)
5. Click **Continue → Register**

---

## Phase 2 — Create the app in App Store Connect

1. Go to [appstoreconnect.apple.com → Apps → +](https://appstoreconnect.apple.com/apps)
2. Select **New App**
3. Fill in the form:
   | Field | Notes |
   |-------|-------|
   | Platforms | iOS |
   | Name | Public app name |
   | Primary Language | e.g. English (U.S.) |
   | Bundle ID | Select from dropdown (must match registered ID) |
   | SKU | Unique internal string, e.g. `MYAPP-2026` |
   | User Access | Full Access for personal accounts |

> **If Bundle ID dropdown is empty**: You are likely in the wrong team. Click your account name (top right) and switch to the team that owns the Bundle ID.

> **React form tip**: The Primary Language dropdown may not respond to standard input automation. Use keyboard navigation: click the field, type the first two letters of the language (e.g. `en`), then use arrow keys to select.

---

## Phase 3 — Configure `Info.plist` for App Store validation

Flutter generates a broad `Info.plist` by default. Before building, audit it to avoid App Store rejections.

### 3a — `UIBackgroundModes` audit

Remove any background mode your app does **not** actively use. Common unused entries:

| Value | Requires | Remove if not used |
|-------|----------|-------------------|
| `processing` | `BGTaskSchedulerPermittedIdentifiers` key | ✅ Remove if no `BGTaskScheduler` in code |
| `push-to-talk` | `com.apple.developer.push-to-talk` entitlement | ✅ Remove if no PTT feature |
| `voip` | VoIP entitlement + PushKit | Review carefully |
| `bluetooth-central` / `bluetooth-peripheral` | — | Remove if no BLE |
| `nearby-interaction` | — | Remove if no UWB/NI |

To search for BGTaskScheduler usage:
```bash
grep -r "BGTaskScheduler" lib/ ios/
```

### 3b — Usage descriptions audit

Every `NS*UsageDescription` key must have a **non-empty** string. An empty string causes automatic App Review rejection.

| Key | Needed if |
|-----|-----------|
| `NSCameraUsageDescription` | App accesses camera |
| `NSMicrophoneUsageDescription` | App records audio |
| `NSPhotoLibraryUsageDescription` | App reads/writes photo library |
| `NSLocationWhenInUseUsageDescription` | App requests location |
| `NSLocationAlwaysAndWhenInUseUsageDescription` | App has `location` in `UIBackgroundModes` |
| `NSCalendarsFullAccessUsageDescription` | App reads/writes calendar events (not just shows a calendar icon) |
| `NSFaceIDUsageDescription` | App uses Face ID |
| `NSUserTrackingUsageDescription` | App uses ATT / tracking |

> **Icon ≠ API**: Using `Icons.calendar_today` as a UI widget does **not** require `NSCalendarsFullAccessUsageDescription`. Only remove keys for permissions your app never requests in code.

> **Location background mode**: If `location` is in `UIBackgroundModes`, you must include **both** `NSLocationWhenInUseUsageDescription` AND `NSLocationAlwaysAndWhenInUseUsageDescription`, even if you only request "when in use" permission at runtime.

### 3c — Quick validation command

After edits, verify the plist is valid XML:
```bash
plutil -lint ios/Runner/Info.plist
```

---

## Phase 4 — Firebase alignment (if using Firebase)

When changing Apple accounts or creating a new app listing, Firebase settings must stay in sync.

### 4a — Update `GoogleService-Info.plist`

| Key to verify | Where to find the correct value |
|---------------|--------------------------------|
| `BUNDLE_ID` | Must match Bundle ID registered in Apple Developer portal |
| `GOOGLE_APP_ID` | Firebase console → Project Settings → Your iOS app |
| `IS_ANALYTICS_ENABLED` | Set to `<true/>` to enable Firebase Analytics |
| `IS_GCM_ENABLED` | Set to `<true/>` if using push notifications |

To update: Firebase Console → Project Settings → Your Apps → iOS app → Download `GoogleService-Info.plist` → replace `ios/Runner/GoogleService-Info.plist`.

### 4b — Update Firebase iOS app metadata

In Firebase Console → Project Settings → Your Apps → (iOS app):
- **App Store ID**: Must match the new app's App Store ID (found in App Store Connect → App Information)
- **Team ID**: Must match your Apple Developer Team ID (found in developer.apple.com → Membership)

### 4c — Firebase App Check

App Check protects your Firebase backend. For iOS production:

1. Go to Firebase Console → **App Check** → click your iOS app → Register
2. Choose **App Attest** as the provider (recommended for iOS 14+, uses Secure Enclave)
3. Optionally add **DeviceCheck** as fallback (requires a `.p8` APNs key upload)

> App Attest alone is sufficient for apps targeting iOS 14+, which covers nearly all active devices.

### 4d — APNs key (for push notifications)

If using Firebase Cloud Messaging:
1. developer.apple.com → Certificates, IDs & Profiles → Keys → create an **APNs Authentication Key**
2. Note the **Key ID** (10-char string)
3. Upload to Firebase Console → Project Settings → Cloud Messaging → iOS app → APNs Authentication Key

---

## Phase 5 — Build the IPA

```bash
flutter build ipa --release
```

This produces `.ipa` at `build/ios/ipa/*.ipa`.

**Common build issues:**

| Error | Fix |
|-------|-----|
| `No profiles for 'com.x.y' were found` | Re-download provisioning profile in Xcode → Preferences → Accounts |
| `Code signing is required` | Set `DEVELOPMENT_TEAM` in `ios/Runner.xcodeproj` |
| Build fails after changing `Info.plist` | Run `flutter clean && flutter build ipa --release` |

---

## Phase 6 — Upload via Transporter

1. Open **Transporter** app (free on Mac App Store)
2. Sign in with your Apple ID (same account/team as App Store Connect)
3. Drag the `.ipa` file into Transporter
4. Click **Deliver**

### Common Transporter warnings (yellow ⚠) — fix before App Review

These are warnings, not hard failures — the build still delivers but will likely be **rejected** during review if not fixed.

| Warning | Root cause | Fix |
|---------|-----------|-----|
| `Missing entitlement: push-to-talk` (90917) | `push-to-talk` in `UIBackgroundModes` without entitlement | Remove `push-to-talk` from `UIBackgroundModes` |
| `Missing purpose string NSLocationAlwaysAndWhenInUseUsageDescription` | `location` background mode without the "always" description | Add `NSLocationAlwaysAndWhenInUseUsageDescription` to `Info.plist` |
| `Missing purpose string NS*UsageDescription` | Empty or missing usage description | Add non-empty description for that permission |

### Common Transporter errors (red ✕) — build not delivered

| Error | Root cause | Fix |
|-------|-----------|-----|
| 409 `Missing BGTaskSchedulerPermittedIdentifiers` | `processing` in `UIBackgroundModes` without the plist key | Remove `processing` from `UIBackgroundModes` if `BGTaskScheduler` is not used |
| `Invalid Signature` | Wrong distribution certificate | Rebuild with correct Distribution cert |
| `CFBundleVersion` conflict | Same build number already uploaded | Increment `ios/Runner/Info.plist → CFBundleVersion` |

After fixing, rebuild the IPA (Phase 5) and re-upload.

---

## Phase 7 — App icon pack

All iOS icon sizes must be provided. Generate them from a single 1024×1024 master PNG using the script below.

### Required sizes

| File | Pixels |
|------|--------|
| `Icon-App-1024x1024@1x.png` | 1024×1024 |
| `Icon-App-60x60@3x.png` | 180×180 |
| `Icon-App-60x60@2x.png` | 120×120 |
| `Icon-App-83.5x83.5@2x.png` | 167×167 |
| `Icon-App-76x76@2x.png` | 152×152 |
| `Icon-App-76x76@1x.png` | 76×76 |
| `Icon-App-40x40@3x.png` | 120×120 |
| `Icon-App-40x40@2x.png` | 80×80 |
| `Icon-App-40x40@1x.png` | 40×40 |
| `Icon-App-29x29@3x.png` | 87×87 |
| `Icon-App-29x29@2x.png` | 58×58 |
| `Icon-App-29x29@1x.png` | 29×29 |
| `Icon-App-20x20@3x.png` | 60×60 |
| `Icon-App-20x20@2x.png` | 40×40 |
| `Icon-App-20x20@1x.png` | 20×20 |

### Auto-generate script

```python
from PIL import Image
import os

ICON_DIR = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
MASTER   = "master_icon_1024.png"  # your 1024x1024 source

icons = [
    ("Icon-App-20x20@1x.png",      20),
    ("Icon-App-20x20@2x.png",      40),
    ("Icon-App-20x20@3x.png",      60),
    ("Icon-App-29x29@1x.png",      29),
    ("Icon-App-29x29@2x.png",      58),
    ("Icon-App-29x29@3x.png",      87),
    ("Icon-App-40x40@1x.png",      40),
    ("Icon-App-40x40@2x.png",      80),
    ("Icon-App-40x40@3x.png",     120),
    ("Icon-App-50x50@1x.png",      50),
    ("Icon-App-50x50@2x.png",     100),
    ("Icon-App-57x57@1x.png",      57),
    ("Icon-App-57x57@2x.png",     114),
    ("Icon-App-60x60@2x.png",     120),
    ("Icon-App-60x60@3x.png",     180),
    ("Icon-App-72x72@1x.png",      72),
    ("Icon-App-72x72@2x.png",     144),
    ("Icon-App-76x76@1x.png",      76),
    ("Icon-App-76x76@2x.png",     152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

master = Image.open(MASTER).convert("RGBA")
for filename, px in icons:
    resized = master.resize((px, px), Image.LANCZOS)
    final   = Image.new("RGB", (px, px), (0, 0, 0))
    final.paste(resized, mask=resized.split()[3])
    final.save(os.path.join(ICON_DIR, filename), "PNG")
    print(f"  ✓ {filename} ({px}×{px})")
```

> iOS clips icons to rounded corners automatically — your master should fill the full square (no pre-rounded corners).

---

## Phase 8 — TestFlight distribution

After Transporter delivers successfully:

1. App Store Connect → **TestFlight** tab → wait ~5 min for processing
2. Go to **Builds** → select the new build
3. Add **Test Information** (What to Test notes)
4. Add internal testers or create an **External Testing** group
5. For external testing: submit for **Beta App Review** (usually approved in <24 h)

---

## Commit workflow (for Claude with project access)

After any `Info.plist` or `GoogleService-Info.plist` changes, suggest a commit:

```bash
git add ios/Runner/Info.plist ios/Runner/GoogleService-Info.plist
git commit -m "fix: <describe what was changed and why>"
```

Never commit without user confirmation. Always show the diff summary first.

---

## Quick reference — key file locations

| File | Purpose |
|------|---------|
| `ios/Runner/Info.plist` | App permissions, background modes, metadata |
| `ios/Runner/GoogleService-Info.plist` | Firebase config for iOS |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | All icon sizes |
| `ios/Runner.xcodeproj/project.pbxproj` | Signing, team ID, bundle ID |
| `pubspec.yaml` | Flutter version (maps to CFBundleShortVersionString) |
