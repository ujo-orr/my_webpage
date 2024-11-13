import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/presentation/viewmodel/audio_view_model.dart';

final soundViewModelProvider =
    StateNotifierProvider<SoundViewModel, bool>((ref) {
  return SoundViewModel();
});
