// AdMob platform — web/desktop stub. google_mobile_ads Android/iOS
// par hi chalta hai, is liye web build mein ye no-op implementation
// use hoti hai (conditional import: ads_platform.dart).
class AdsPlatform {
  /// Interstitial kabhi ready nahi (web par ads nahi).
  bool get interstitialReady => false;

  /// Rewarded ad kabhi ready nahi (web par ads nahi).
  bool get rewardedReady => false;

  /// Web par init kuch nahi karta — ads band rehte hain.
  Future<bool> init() async => false;

  /// Web par interstitial nahi dikhta.
  Future<bool> showInterstitial() async => false;

  /// Web par rewarded ad nahi dikhta.
  Future<bool> showRewarded() async => false;
}
