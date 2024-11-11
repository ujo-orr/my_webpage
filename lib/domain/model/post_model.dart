import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String category;
  final String contentHtml;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.category,
    required this.contentHtml,
    required this.createdAt,
  });

  // Firestore 데이터를 Post 모델로 변환
  factory Post.fromDocument(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      title: data['title'] ?? 'No Title',
      category: data['category'] ?? 'No Category',
      contentHtml: data['content_html'] ?? '<p>내용이 없습니다</p>',
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}
