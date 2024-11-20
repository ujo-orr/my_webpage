import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart';

class SoundViewModel extends StateNotifier<bool> {
  final AudioElement _audioElement;

  SoundViewModel()
      : _audioElement = AudioElement('assets/assets/sound/night_ambience.mp3'),
        super(false) {
    _audioElement.loop = true;
    _audioElement.preload = 'auto';
    _audioElement.defaultMuted = true;
    _audioElement.muted = true;
  }

  Future<void> toggleSound() async {
    if (state) {
      _audioElement.pause();
      state = false;
    } else {
      try {
        _audioElement.muted = false;
        await _audioElement.play();
        state = true;
      } catch (e) {
        throw Exception('audio error $e');
      }
    }
  }

  @override
  void dispose() {
    _audioElement.pause();
    super.dispose();
  }
}
