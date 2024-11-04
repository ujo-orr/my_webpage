import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// firebase Database에서 Future로 받을 예정
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 포스트 ID로 특정 포스트를 불러오는 함수
  Future<Map<String, dynamic>?> getPostById(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return doc.data(); // 포스트 데이터를 반환
      } else {
        print('해당 포스트가 존재하지 않습니다.');
        return null;
      }
    } catch (e) {
      print('포스트 불러오기 실패: $e');
      return null;
    }
  }

  Future<void> uploadPost({
    required String title,
    required String category,
    required quill.QuillController quillController,
    required quillContent,
    File? imageFile,
    File? videoFile,
  }) async {
    try {
      final timestamp = Timestamp.now();

      // Quill 에디터 내용 가져오기
      final content = quillController.document.toPlainText();
      final contentJson = quillController.document.toDelta().toJson();

      // 이미지 업로드 후 URL 가져오기
      String? imageUrl;
      if (imageFile != null) {
        final imageRef = _storage.ref().child('posts/$title-image.jpg');
        await imageRef.putFile(imageFile);
        imageUrl = await imageRef.getDownloadURL();
      }

      // 동영상 업로드 후 URL 가져오기
      String? videoUrl;
      if (videoFile != null) {
        final videoRef = _storage.ref().child('posts/$title-video.mp4');
        await videoRef.putFile(videoFile);
        videoUrl = await videoRef.getDownloadURL();
      }

      // Firestore에 데이터 저장
      await _firestore.collection('posts').doc(title).set({
        'title': title,
        'category': category,
        'text': content,
        'content': contentJson, // JSON 형태로 저장된 포맷 정보 포함
        'created_at': timestamp,
        'updated_at': timestamp,
        'image_url': imageUrl,
        'video_url': videoUrl,
      });

      print("포스트가 성공적으로 업로드되었습니다!");
    } catch (e) {
      print("포스트 업로드 중 오류 발생: $e");
    }
  }
}
