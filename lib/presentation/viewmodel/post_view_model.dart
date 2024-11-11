import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/domain/model/post_model.dart';
import 'package:my_webpage/domain/usecase/get_post_by_id_usecase.dart';

class PostViewModel extends StateNotifier<AsyncValue<Post?>> {
  final GetPostByIdUseCase getPostByIdUseCase;

  PostViewModel(this.getPostByIdUseCase) : super(const AsyncValue.loading());

  Future<void> fetchPostById(String postId) async {
    state = const AsyncValue.loading();
    try {
      final postData = await getPostByIdUseCase.execute(postId);
      state = AsyncValue.data(postData);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
