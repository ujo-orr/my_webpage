import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PickImageUseCase {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> execute() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? await pickedFile.readAsBytes() : null;
  }
}
