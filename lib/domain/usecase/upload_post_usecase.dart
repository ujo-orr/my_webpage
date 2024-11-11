import 'package:my_webpage/data/repository/post_repository.dart';

class UploadPostUseCase {
  final PostRepository postRepository;

  UploadPostUseCase(this.postRepository);

  Future<void> execute(String title, String category, String contentHtml) {
    return postRepository.uploadPost(title, category, contentHtml);
  }
}
