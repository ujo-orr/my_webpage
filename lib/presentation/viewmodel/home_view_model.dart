import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<AsyncValue<List<DocumentSnapshot>>> {
  HomeViewModel(this.ref) : super(const AsyncValue.loading()) {
    fetchPosts();
  }

  final Ref ref;

  Future<void> fetchPosts() async {
    state = const AsyncValue.loading();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('created_at', descending: true) // 최신순 정렬
          .get();
      state = AsyncValue.data(querySnapshot.docs);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
