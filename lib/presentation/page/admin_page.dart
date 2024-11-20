import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN PAGE'),
        leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: Icon(Icons.home)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  context.go('/postingPage');
                },
                child: Text('Post Write')),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.go('/');
                },
                child: Text('logout')),
          ],
        ),
      ),
    );
  }
}
