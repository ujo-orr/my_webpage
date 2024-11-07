import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sidebardata.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(sideBarProvider);

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
                  // 항목을 선택할 때 해당 이름을 URL 매개변수로 전달
                  context.go('/detail/${posts[index]}');
                },
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
            icon: Icon(Icons.key)),
      ],
    );
  }
}
