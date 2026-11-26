// Ads System — design doc §6, system 8 (Ads / Earning).
// 3 jagah ads: fail ke baad kabhi kabhi interstitial, hint aur
// garage-coins ke liye rewarded. Rule: drive ke beech mein kabhi ad
// nahi — is liye ye service sirf result phase ya menu se bulayi jati hai.
//
// AdMob (google_mobile_ads) — mobile (Android/iOS) par real wiring,
// web par stub (ads_platform.dart conditional import). Test IDs
// Google ke official hain (AdsValues) — Awais ke AdMob account ke
// asal IDs milne par constants.dart + AndroidManifest/Info.plist
// mein badlo. Game kabhi ad ki wajah se nahi rukta — ad na mile to
// button disable ya reward nahi milta.
import '../../core/constants.dart';
import 'ads_platform.dart';

/// App bhar ek hi instance — main.dart mein banata hai.
final AdsService adsService = AdsService();

class AdsService {
  AdsService({this.testMode = false});

  /// true ho to ads hamesha ready, rewarded hamesha kamyab (tests ke liye).
  final bool testMode;

  /// Mobile platform implementation (web par no-op stub).
  final AdsPlatform _platform = AdsPlatform();

  /// AdMob wire hua ya nahi — testMode mein hamesha true, warna
  /// platform init kamyab hua ya nahi.
  bool get adsEnabled => testMode || _initialized;

  bool _initialized = false;

  /// Kul fails (interstitial rule ke liye).
  int totalFails = 0;

  /// Dikhaye gaye ads — test aur analytics ke liye.
  int interstitialsShown = 0;
  int rewardedShown = 0;

  /// Aakhri ad ka waqt — cooldown ke liye. Tests inhe peeche kar
  /// sakte hain (cooldown guzar gaya dikhane ke liye).
  DateTime? lastInterstitialAt;
  DateTime? lastRewardedAt;

  /// App start par — testMode mein foran ready, warna MobileAds init
  /// + ads preload (platform). Web/desktop par init false deta hai.
  Future<void> init() async {
    if (testMode) {
      _initialized = true;
      return;
    }
    _initialized = await _platform.init();
  }

  /// Fail ke baad bulayo — har 3rd fail par interstitial dikhata hai.
  /// Drive phase se kabhi mat bulana (game sirf result par bulata hai).
  /// Wapas: ad dikha ya nahi.
  Future<bool> maybeShowInterstitialAfterFail() async {
    totalFails++;
    if (totalFails % AdsValues.interstitialEveryNFails != 0) {
      return false;
    }
    if (!_interstitialAvailable) return false;
    if (!_cooldownPassed(
      lastInterstitialAt,
      AdsValues.interstitialCooldownSeconds,
    )) {
      return false;
    }
    lastInterstitialAt = DateTime.now();
    interstitialsShown++;
    if (testMode) return true;
    return _platform.showInterstitial();
  }

  /// Rewarded ad — 'hint', 'coins' ya 'skip' ke liye.
  /// Wapas: ad mukammal hua (reward milega) ya nahi.
  Future<bool> showRewarded({required String placement}) async {
    if (!_rewardedAvailable) return false;
    if (!_cooldownPassed(
      lastRewardedAt,
      AdsValues.rewardedCooldownSeconds,
    )) {
      return false;
    }
    lastRewardedAt = DateTime.now();
    rewardedShown++;
    if (testMode) return true;
    return _platform.showRewarded();
  }

  /// testMode mein ads hamesha ready — init() ka intezar nahi.
  /// Warna platform ki live readiness (ad load hua ya nahi).
  bool get _interstitialAvailable => testMode || _platform.interstitialReady;

  /// testMode mein ads hamesha ready — init() ka intezar nahi.
  bool get _rewardedAvailable => testMode || _platform.rewardedReady;

  bool _cooldownPassed(DateTime? last, int cooldownSeconds) {
    if (last == null) return true;
    return DateTime.now().difference(last).inSeconds >= cooldownSeconds;
  }

  /// Tests ke liye — counters aur waqt zero karo.
  void resetForTest() {
    totalFails = 0;
    interstitialsShown = 0;
    rewardedShown = 0;
    lastInterstitialAt = null;
    lastRewardedAt = null;
  }
}
