import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_webpage/data/repository/post_repository.dart';
import 'package:my_webpage/domain/model/post_model.dart';
import 'package:my_webpage/domain/usecase/get_post_by_id_usecase.dart';
import 'package:my_webpage/domain/usecase/pick_image_usecase.dart';
import 'package:my_webpage/domain/usecase/upload_post_usecase.dart';
import 'package:my_webpage/presentation/viewmodel/home_view_model.dart';
import 'package:my_webpage/presentation/viewmodel/post_view_model.dart';
import 'package:my_webpage/presentation/viewmodel/posting_view_model.dart';

// PostRepository Provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
});

// 모든 게시물 가져오는 FutureProvider
final blogPostsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.fetchPosts();
});

// GetPostByIdUseCase Provider 정의
final getPostByIdUseCaseProvider = Provider<GetPostByIdUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return GetPostByIdUseCase(repository);
});

// PostViewModel Provider 정의
final postViewModelProvider =
    StateNotifierProvider<PostViewModel, AsyncValue<Post?>>((ref) {
  final getPostByIdUseCase = ref.watch(getPostByIdUseCaseProvider);
  return PostViewModel(getPostByIdUseCase);
});

// uploadPostUseCaseProvider 정의
final uploadPostUseCaseProvider = Provider<UploadPostUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return UploadPostUseCase(repository);
});

// pickImageUseCaseProvider 정의
final pickImageUseCaseProvider = Provider<PickImageUseCase>((ref) {
  return PickImageUseCase();
});

// PostingViewModel의 Provider
final postingViewModelProvider =
    StateNotifierProvider<PostingViewModel, AsyncValue<void>>((ref) {
  final uploadPostUseCase = ref.watch(uploadPostUseCaseProvider);
  final pickImageUseCase = ref.watch(pickImageUseCaseProvider);
  return PostingViewModel(
    uploadPostUseCase,
    pickImageUseCase,
    QuillController.basic(),
    TextEditingController(),
    TextEditingController(),
  );
});

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<DocumentSnapshot>>>(
  (ref) => HomeViewModel(ref),
);
