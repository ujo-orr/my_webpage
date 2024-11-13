import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart';

class SoundViewModel extends StateNotifier<bool> {
  final AudioElement _audioElement;

  SoundViewModel()
      : _audioElement = AudioElement('assets/sound/night_ambience.mp3'),
        super(false) {
    _audioElement.loop = true; // 반복 재생
  }

  void toggleSound() {
    if (state) {
      _audioElement.pause();
      state = false;
    } else {
      _audioElement.play();
      state = true;
    }
  }

  @override
  void dispose() {
    _audioElement.pause();
    super.dispose();
  }
}
