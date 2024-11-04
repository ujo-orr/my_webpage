import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN PAGE'),
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
                  // modifying logic
                },
                child: Text('Pst Modify')),
          ],
        ),
      ),
    );
  }
}
