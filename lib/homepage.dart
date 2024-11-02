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
    )..repeat(reverse: true); // 반복 애니메이션

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            context.go('/');
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
          // 블로그 게시물 그리드 레이아웃
          StreamBuilder<List<String>>(
            stream: Stream.value(ref.watch(blogPostsProvider)), // Stream 변환
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final posts = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 가로에 두 개씩 배치
                  mainAxisSpacing: 25, // 수직 간격
                  crossAxisSpacing: 25, // 수평 간격
                  childAspectRatio: 6 / 2, // 300x200 비율
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    height: 200,
                    color: Colors.blueAccent.withOpacity(0.2 * (index % 5 + 1)),
                    child: Center(
                      child: Text(
                        posts[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
