// AudioService ke tests — testMode mein koi audio call nahi hoti,
// sirf state badalti hai. Asli audio device par hi bajta hai.
import 'package:flutter_test/flutter_test.dart';
import 'package:track_builder/services/audio_service.dart';

void main() {
  group('AudioService (testMode)', () {
    test('playSfx, music aur engine calls error nahi deti', () async {
      final audio = AudioService(testMode: true);
      await audio.init();
      await audio.playSfx('coin');
      await audio.playSfx('win');
      await audio.playSfx('crash');
      await audio.playSfx('click');
      await audio.startMusic();
      await audio.startEngine();
      await audio.setEngineSpeed(0.5);
      await audio.setEngineSpeed(1.0);
      await audio.stopEngine();
      await audio.stopMusic();
    });

    test('music/sfx toggles state badalte hain', () async {
      final audio = AudioService(testMode: true);
      expect(audio.musicOn, isTrue);
      expect(audio.sfxOn, isTrue);
      await audio.setMusicEnabled(false);
      expect(audio.musicOn, isFalse);
      audio.setSfxEnabled(false);
      expect(audio.sfxOn, isFalse);
      await audio.setMusicEnabled(true);
      expect(audio.musicOn, isTrue);
    });

    test('sfx off ho to playSfx kuch nahi karta', () async {
      final audio = AudioService(testMode: true);
      audio.setSfxEnabled(false);
      // Error nahi aana chahiye — bas return.
      await audio.playSfx('coin');
    });
  });
}
