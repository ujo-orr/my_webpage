import 'package:flutter_riverpod/flutter_riverpod.dart';

final sideBarProvider = Provider<List<String>>((ref) {
  return [
    'My name',
    'School',
    'Age',
    'Hobby',
    'My Blog',
    'My Git',
    'etc',
  ];
});

final sideBarDetailsProvider = Provider<Map<String, String>>((ref) {
  return {
    'My name': 'Woogie',
    'School': 'Keimyung University',
    'Age': '29',
    'Hobby': 'Coding',
    'My Blog': 'https://ujo-orr.tistory.com/',
    'My Git': 'https://github.com/ujo-orr',
    'etc': '연습용',
  };
});
