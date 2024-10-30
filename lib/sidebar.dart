import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(blogPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/black_cat_normal.jpg'),
            backgroundColor: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'woogie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(color: Colors.white),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  posts[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  context.go('/post');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// 블로그 글 목록 상태
final blogPostsProvider = Provider<List<String>>((ref) {
  return [
    'Welcome to My Blog',
    'Flutter Tips and Tricks',
    'State Management with Riverpod',
  ];
});
