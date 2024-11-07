import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// firebase Database에서 Future로 받기
final blogPostsProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();
  return querySnapshot.docs; // 각 문서의 DocumentSnapshot 리스트를 반환
});

class BlogService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 특정 포스트 ID로 Firestore에서 포스트 데이터 가져오기
  Future<Map<String, dynamic>?> getPostById(String postId) async {
    try {
      final doc = await _fireStore.collection('posts').doc(postId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('포스트 데이터 가져오기 실패 : $e');
    }
  }

  // Firebase Storage에 파일 업로드 및 URL 반환
  Future<String?> uploadFileToStorage({
    required Uint8List fileData,
    required String fileName,
    required String folder,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      await ref.putData(fileData);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('file upload error : $e');
    }
  }

  // Firestore에 포스트 업로드
  Future<void> uploadPost({
    required String title,
    required String category,
    required String quillContentHtml,
  }) async {
    await _fireStore.collection('posts').doc(title).set({
      'title': title,
      'category': category,
      'content_html': quillContentHtml,
      'created_at': DateTime.now(),
    });
  }
}
