import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(blogPostsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('\'ujo_orr\'s web')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]),
            onTap: () {
              context.go('/post/$index');
            },
          );
        },
      ),
    );
  }
}
