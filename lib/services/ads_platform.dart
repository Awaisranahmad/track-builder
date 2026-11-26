// AdMob platform selector — dart.library.io (Android/iOS/desktop)
// hone par real mobile implementation, web par stub.
// Desktop (Linux/macOS/Windows) par mobile file import hoti hai lekin
// AdsPlatform.init() wahan false deta hai (Platform check) — ads
// sirf Android/iOS par chalte hain.
export 'ads_platform_stub.dart'
    if (dart.library.io) 'ads_platform_mobile.dart';
