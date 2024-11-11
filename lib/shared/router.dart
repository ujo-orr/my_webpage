import 'package:go_router/go_router.dart';
import 'package:my_webpage/presentation/layout/sidebar_layout.dart';
import 'package:my_webpage/presentation/page/admin_page.dart';
import 'package:my_webpage/presentation/page/home_page.dart';
import 'package:my_webpage/presentation/page/login_page.dart';
import 'package:my_webpage/presentation/page/post_view_page.dart';
import 'package:my_webpage/presentation/page/posting_page.dart';
import 'package:my_webpage/presentation/page/sidebar_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SideBarLayout(child: HomePage()),
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
