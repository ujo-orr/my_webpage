import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// firebase Database에서 Future로 받을 예정
final blogPostsProvider = StreamProvider<List<String>>((ref) async* {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();
  yield querySnapshot.docs.map((doc) => doc['title'] as String).toList();
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

  // 이미지와 동영상을 Firebase Storage에 업로드하고 URL을 Firestore에 저장하는 함수
  Future<void> uploadPost({
    required String title,
    required String category,
    required String text,
    required File? imageFile,
    required File? videoFile,
  }) async {
    try {
      // 업로드할 때 타임스탬프 생성
      final timestamp = Timestamp.now();

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

      // Firestore에 데이터 저장 (title을 문서 ID로 사용)
      await _fireStore.collection('posts').doc(title).set({
        'title': title,
        'category': category,
        'text': text,
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
