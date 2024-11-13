import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/data/provider/audio_provider.dart';
import 'package:my_webpage/data/provider/post_provider.dart';
import 'package:my_webpage/presentation/layout/nightanimation.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogPostsAsync = ref.watch(homeViewModelProvider);
    final isPlaying = ref.watch(soundViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () =>
              ref.read(homeViewModelProvider.notifier).fetchPosts(),
          child: const Text(
            '삼 매 경',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(soundViewModelProvider.notifier).toggleSound();
            },
            icon: Icon(
              isPlaying ? Icons.volume_up : Icons.volume_off,
              color: isPlaying ? Colors.grey : Colors.amberAccent,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const NightAnimation(),
          blogPostsAsync.when(
            data: (posts) {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  childAspectRatio: 6 / 2,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final postId = posts[index].id;
                  return GestureDetector(
                    onTap: () => context.go('/post/$postId'),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.grey.withOpacity(0.2 * (index % 5 + 1)),
                      ),
                      width: 300,
                      height: 200,
                      child: Center(
                        child: Text(
                          postId,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
