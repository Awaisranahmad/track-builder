// AdMob platform — mobile (Android/iOS) par real google_mobile_ads,
// web/desktop par stub. Conditional import: dart.library.io hone par
// ye file, warna ads_platform_stub.dart (web par dart:io nahi hota).
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants.dart';

/// Mobile AdMob implementation — AdsService isi se baat karta hai.
/// Ad unit IDs Google ke official TEST IDs hain (AdsValues) — Awais ke
/// AdMob account ke asal IDs milne par constants.dart mein badlo.
class AdsPlatform {
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  bool _initialized = false;

  /// Interstitial load ho kar ready hai.
  bool get interstitialReady => _interstitial != null;

  /// Rewarded ad load ho kar ready hai.
  bool get rewardedReady => _rewarded != null;

  /// MobileAds init + dono ads preload. Desktop par false (ads nahi).
  Future<bool> init() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadInterstitial();
    _loadRewarded();
    return true;
  }

  void _loadInterstitial() {
    if (!_initialized) return;
    InterstitialAd.load(
      adUnitId: AdsValues.testInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitial = null;
        },
      ),
    );
  }

  void _loadRewarded() {
    if (!_initialized) return;
    RewardedAd.load(
      adUnitId: AdsValues.testRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewarded = null;
              _loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewarded = null;
              _loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _rewarded = null;
        },
      ),
    );
  }

  /// Preloaded interstitial dikhao — dikha to true.
  Future<bool> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return false;
    _interstitial = null;
    await ad.show();
    return true;
  }

  /// Preloaded rewarded ad dikhao — user ne poora dekha (reward mila)
  /// to true, warna false.
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (ad == null) return false;
    _rewarded = null;
    var earned = false;
    await ad.show(
      onUserEarnedReward: (ad, reward) {
        earned = true;
      },
    );
    return earned;
  }
}
