import 'package:my_webpage/data/repository/post_repository.dart';
import 'package:my_webpage/domain/model/post_model.dart';

class GetPostByIdUseCase {
  final PostRepository postRepository;

  GetPostByIdUseCase(this.postRepository);

  Future<Post?> execute(String postId) {
    return postRepository.getPostById(postId);
  }
}
