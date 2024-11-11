import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/data/provider/sidebar_provider.dart';

class SideBarLayout extends ConsumerWidget {
  final Widget child;

  const SideBarLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 화면 크기에 따라 사이드바 너비를 조절
    double screenWidth = MediaQuery.of(context).size.width;
    double sidebarWidth = screenWidth * 0.2;
    if (screenWidth < 600) {
      sidebarWidth = screenWidth * 0.1;
    }
    sidebarWidth = sidebarWidth.clamp(0, 200);

    final viewModel = ref.watch(sidebarViewModelProvider);
    final posts = viewModel.getSidebarItems();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              image: const DecorationImage(
                image: AssetImage('assets/images/glitter.jpg'),
                opacity: 0.5,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        const AssetImage('assets/images/black_cat_normal.jpg'),
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
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              posts[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              context.go('/detail/${posts[index]}');
                            },
                          ),
                          const Divider(color: Colors.white30),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      context.go('/ej23it289htaw4h');
                    } else {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.key),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
