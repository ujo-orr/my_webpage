import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:my_webpage/animation/nightanimation.dart';
import 'package:my_webpage/data/postdata.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class RefreshNotifier extends StateNotifier<bool> {
  RefreshNotifier() : super(false);

  void refresh() {
    state = !state;
  }
}

final reFreshNotifier =
    StateNotifierProvider<RefreshNotifier, bool>((ref) => RefreshNotifier());

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // 별의 위치를 저장할 리스트
  List<Offset> starPositions = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    // mounted 확인 후 repeat 실행
    if (mounted) {
      _controller.repeat(reverse: true); // 반복 애니메이션
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러를 정리하여 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final blogPostsAsync = ref.watch(blogPostsProvider);

    // 별 위치 초기화
    if (starPositions.isEmpty) {
      for (int i = 0; i < 400; i++) {
        double x = Random().nextDouble() * size.width;
        double y = Random().nextDouble() * size.height;
        starPositions.add(Offset(x, y));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            // 새로고침
            ref.read(reFreshNotifier.notifier).refresh();
          },
          child: Text(
            '삼 매 경',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_rounded),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: StarryNightPainter(
                  starPositions: starPositions,
                  opacity: _animation.value,
                ),
                child: Container(),
              );
            },
          ),
          blogPostsAsync.when(
            data: (posts) {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 가로에 두 개씩 배치
                  mainAxisSpacing: 25, // 수직 간격
                  crossAxisSpacing: 25, // 수평 간격
                  childAspectRatio: 6 / 2, // 300x200 비율
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final postId = posts[index].id; // Firestore 문서 ID
                  return GestureDetector(
                    onTap: () {
                      // 개별적인 클릭 반응
                      context.go('/post/$postId');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.grey.withOpacity(0.2 * (index % 5 + 1)),
                      ),
                      width: 300,
                      height: 200,
                      child: Center(
                        child: Text(
                          posts[index].id,
                          style: TextStyle(
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
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
