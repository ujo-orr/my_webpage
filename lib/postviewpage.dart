import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart'; // flutter_html 패키지 import

import 'data/postdata.dart';

class PostViewPage extends ConsumerWidget {
  final String postId;

  const PostViewPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogService = BlogService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: blogService.getPostById(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final post = snapshot.data!;
            final contentHtml = post['content_html'] ?? '<p>내용이 없습니다</p>';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'] ?? 'No Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '카테고리 : ',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        post['category'] ?? 'No Category',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Html(data: contentHtml), // Html 위젯으로 HTML 렌더링
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('포스트를 찾을 수 없습니다.'));
          }
        },
      ),
    );
  }
}
