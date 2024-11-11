import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_webpage/data/repository/post_repository.dart';

class FetchPostsUseCase {
  final PostRepository postRepository;

  FetchPostsUseCase(this.postRepository);

  Future<List<QueryDocumentSnapshot>> execute() {
    return postRepository.fetchPosts();
  }
}
