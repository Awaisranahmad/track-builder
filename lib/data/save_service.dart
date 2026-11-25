// Progress ko phone ki storage mein save/load karna.
// Layer 3 (Data) — isay game logic ya UI ka kuch pata nahi, sirf data.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/player_progress.dart';

/// Save karne ki key — ek jagah, taake badalni ho to yahin badle.
const String _progressKey = 'track_builder_progress_v1';

/// SaveService — PlayerProgress ko JSON bana kar SharedPreferences
/// mein rakhta hai, aur wapas parh kar object banata hai.
class SaveService {
  SaveService(this._prefs);

  final SharedPreferences _prefs;

  /// SharedPreferences kholo aur service banao.
  static Future<SaveService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SaveService(prefs);
  }

  /// Progress save karo — har level complete par foran save hota hai,
  /// taake app band ho jaye to progress na zaya ho.
  Future<bool> saveProgress(PlayerProgress progress) {
    final json = jsonEncode(progress.toJson());
    return _prefs.setString(_progressKey, json);
  }

  /// Progress load karo — pehli dafa khaali progress milti hai.
  PlayerProgress loadProgress() {
    final json = _prefs.getString(_progressKey);
    if (json == null) return PlayerProgress();
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PlayerProgress.fromJson(map);
    } on FormatException {
      // Kharab data ho to nayi progress — game crash nahi karega.
      return PlayerProgress();
    }
  }

  /// Progress reset karo — Settings mein confirm ke saath istemal hota hai.
  Future<bool> clearProgress() => _prefs.remove(_progressKey);
}
