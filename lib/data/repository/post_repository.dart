import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:my_webpage/domain/model/post_model.dart';

class PostRepository {
  final FirebaseFirestore _fireStore;
  // ignore: unused_field
  final FirebaseStorage _storage;

  PostRepository(this._fireStore, this._storage);

  // Firestore에서 전체 게시물 불러오기
  Future<List<QueryDocumentSnapshot>> fetchPosts() async {
    final querySnapshot = await _fireStore.collection('posts').get();
    return querySnapshot.docs;
  }

  // Firestore에서 특정 포스트 ID로 데이터 가져오기
  Future<Post?> getPostById(String postId) async {
    try {
      final doc = await _fireStore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return Post.fromDocument(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('포스트 데이터 가져오기 실패: $e');
    }
  }

  // Firestore에 새로운 게시물 업로드
  Future<void> uploadPost(
      String title, String category, String contentHtml) async {
    await _fireStore.collection('posts').doc(title).set({
      'title': title,
      'category': category,
      'content_html': contentHtml,
      'created_at': DateTime.now(),
    });
  }
}
