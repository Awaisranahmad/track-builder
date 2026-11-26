# Track Builder — Play Store Release Checklist

Game poora hai (96 levels, 6 gariyan) — Play Store par dalne ke liye ye steps
hain. Signing key aur Play Console account Awais ka apna hoga — key kabhi
repo mein mat dalo, kabhi share mat karo.

## App ki pehchan (pehle se set hai)

- Package / applicationId: `com.awaisranahmad.track_builder`
- App naam: `Track Builder` (AndroidManifest.xml)
- Version: `1.0.0+1` (pubspec.yaml) — har release par versionCode (+1) barhao.
- Icon: custom icon `android/app/src/main/res/mipmap-*/ic_launcher.png`
  (512px store icon: `assets/icon-512.png`).

## 1. Signing key banao (ek dafa — apne laptop par)

```bash
keytool -genkey -v -keystore ~/track-builder-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias track-builder
```

Keystore file + password ko password manager mein rakho. **Key kho gayi to
app update nahi ho sakta** — Play Store purani key hi mangta hai.

## 2. Signing config (apne laptop par, repo mein nahi)

`android/key.properties` banao (ye file git mein nahi jati):

```properties
storePassword=<keystore password>
keyPassword=<key password>
keyAlias=track-builder
storeFile=/home/<user>/track-builder-keystore.jks
```

`android/app/build.gradle.kts` mein release block ko update karo — abhi
woh debug key se sign karta hai (TODO comment wahan hai). `key.properties`
se `signingConfig` lagao (Flutter docs: "Sign your app").

## 3. App Bundle banao

Android SDK chahiye (is VM mein nahi hai — apne laptop par Android Studio
install karo, phir):

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab` — yahi file Play
Console par upload hoti hai. Pehle `flutter build apk --release` se phone
par test kar lo.

## 4. Play Console listing

- App naam: Track Builder
- Short description: "Track banao, phir gari chalao — 96 puzzle-driving levels."
- Full description: 8 worlds, Loop/Spring/See-Saw/Magnet pieces, 6 cars,
  stars + coins, offline khela ja sakta hai.
- Category: Puzzle / Racing. Content rating: Everyone.
- Screenshots: phone + 7-inch tablet (game ke Home, World Map, ek Loop
  level, Garage).
- Feature graphic: 1024x500 (icon-512 se banao).
- Privacy policy: game koi data collect nahi karta (ads hain — AdMob ka
  privacy note add karo jab ads live hon). Privacy policy ka URL Play
  Console mangta hai — GitHub Pages par ek page banao.
- Ads: "Contains ads" tick karo (Phase 4 ads system hai).

## 5. Release se pehle check

- [ ] `flutter analyze` 0 errors, `flutter test` sab pass.
- [ ] Web build pass (`flutter build web --base-href /track-builder/`).
- [ ] Release APK apne phone par install kar ke Level 1, ek Loop level
      (L40) aur Level 96 khelo.
- [ ] Version code barhaya (har upload par +1).
- [ ] Keystore backup hai (password manager + ek offline copy).

## Notes

- Is VM mein Android SDK nahi hai, is liye appbundle yahan build nahi
  hota — web build hi yahan verify hota hai. Play Store build Awais ke
  laptop par (Android Studio ke saath) ya CI se hoga.
- Pehli release "Closed testing" track se shuru karo (khud + 2-3 testers),
  phir Production.
