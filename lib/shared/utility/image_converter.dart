import 'dart:convert';
import 'dart:typed_data';

class ImageConverter {
  static String convertToBase64(Uint8List data) {
    return 'data:image/png;base64,${base64Encode(data)}';
  }
}
