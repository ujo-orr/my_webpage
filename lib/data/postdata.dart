import 'dart:async';
import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// firebase Database에서 Future로 받기
final blogPostsProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();
  return querySnapshot.docs; // 각 문서의 DocumentSnapshot 리스트를 반환
});

final sideBarProvider = Provider<List<String>>((ref) {
  return [
    'My name',
    'School',
    'age',
    'hobby',
  ];
});

class BlogService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getPostById(String postId) async {
    try {
      final doc = await _fireStore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return doc.data(); // 문서 데이터를 반환
      } else {
        print('해당 포스트가 존재하지 않습니다.');
        return null;
      }
    } catch (e) {
      print('포스트 불러오기 실패: $e');
      return null;
    }
  }

  Future<String?> uploadImageToStorage({
    required Uint8List imageData,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('posts/$fileName');
      await ref.putData(imageData);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<String?> uploadVideoToStorage({
    required Uint8List videoData,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('posts/$fileName');
      await ref.putData(videoData);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Video upload error: $e");
      return null;
    }
  }

  Future<void> uploadPost({
    required String title,
    required String category,
    required List quillContent,
    String? imageUrl,
    String? videoUrl,
  }) async {
    final timestamp = DateTime.now();

    await _fireStore.collection('posts').doc(title).set({
      'title': title,
      'category': category,
      'content': quillContent,
      'created_at': timestamp,
      'image_url': imageUrl,
      'video_url': videoUrl,
    });
  }

  // 파일을 선택하고 Uint8List로 읽어오는 메서드
  Future<Uint8List?> pickFile(String fileType) async {
    final completer = Completer<Uint8List?>();
    final input = html.FileUploadInputElement()..accept = fileType;
    input.click();

    input.onChange.listen((event) async {
      final files = input.files;
      if (files?.isEmpty ?? true) {
        completer.complete(null);
        return;
      }
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files!.first);
      reader.onLoadEnd.listen((event) {
        completer.complete(reader.result as Uint8List);
      });
    });

    return completer.future;
  }
}
