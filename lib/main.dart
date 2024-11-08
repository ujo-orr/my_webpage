import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/adminpage.dart';
import 'package:my_webpage/data/firebase_options.dart';
import 'package:my_webpage/loginpage/loginpage.dart';
import 'package:my_webpage/postingpage.dart';
import 'package:my_webpage/postviewpage.dart';
import 'package:my_webpage/sidebar/sidebar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_webpage/sidebar/sidebarpage.dart';

import 'homepage.dart';

// GoRouter 설정
class CustomRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainLayout(child: HomePage()),
      ),
      GoRoute(
        path: '/postingPage',
        builder: (context, state) => const PostingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/ej23it289htaw4h',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/post/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostViewPage(postId: postId);
        },
      ),
      GoRoute(
        path: '/detail/:detailKey',
        builder: (context, state) {
          final detailKey = state.pathParameters['detailKey']!;
          return SidebarPage(detailKey: detailKey);
        },
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: CustomRouter.router,
      theme: ThemeData(
        fontFamily: 'Onglyp_harunanum',
        brightness: Brightness.dark,
      ),
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        FlutterQuillLocalizations.delegate, // 추가된 delegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
    );
  }
}

// 메인 레이아웃
class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context)로 화면 크기 정보를 가져옵니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 화면 크기에 따라 사이드바 너비를 조절합니다.
    double sidebarWidth = screenWidth * 0.2;
    if (screenWidth < 600) {
      sidebarWidth = screenWidth * 0.1;
    }
    sidebarWidth = sidebarWidth.clamp(0, 200);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/images/glitter.jpg'),
                opacity: 0.5,
                fit: BoxFit.cover,
              ),
            ),
            child: Sidebar(),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
