import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/postpage.dart';

import 'homepage.dart';

// GoRouter 설정
class CustomRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/post',
        builder: (context, state) => PostPage(),
      ),
    ],
  );
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: CustomRouter.router,
    );
  }
}

// 블로그 글 목록을 관리하는 간단한 Riverpod 상태 관리
final blogPostsProvider = Provider<List<String>>((ref) {
  return [
    'Welcome to My Blog',
    'Flutter Tips and Tricks',
    'State Management with Riverpod',
  ];
});
