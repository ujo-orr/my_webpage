import 'package:flutter_riverpod/flutter_riverpod.dart';

// firebase Database에서 Future로 받을 예정
final blogPostsProvider = Provider<List<String>>((ref) {
  return [
    'Welcome to My Blog',
    'Flutter Tips and Tricks',
    'State Management with Riverpod',
    'data',
    'data2',
    'data3',
    'data4',
    'data5',
    'data6',
  ];
});

final sideBarProvider = Provider<List<String>>((ref) {
  return [
    'My name',
    'School',
    'age',
    'hobby',
  ];
});
