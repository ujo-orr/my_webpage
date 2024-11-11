import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_webpage/data/provider/post_provider.dart';

class PostViewPage extends ConsumerStatefulWidget {
  final String postId;

  const PostViewPage({super.key, required this.postId});

  @override
  PostViewPageState createState() => PostViewPageState();
}

class PostViewPageState extends ConsumerState<PostViewPage> {
  @override
  void initState() {
    super.initState();
    // initState 내에서 fetchPostById 호출
    Future.microtask(() {
      ref.read(postViewModelProvider.notifier).fetchPostById(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: postState.when(
        data: (post) {
          if (post == null) {
            return const Center(child: Text('포스트를 찾을 수 없습니다.'));
          }
          final contentHtml = post.contentHtml;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '카테고리 : ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                    Text(
                      post.category,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post.createdAt.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Html(data: contentHtml),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
