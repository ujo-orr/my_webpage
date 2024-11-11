import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/data/repository/auth_repository.dart';
import 'package:my_webpage/domain/usecase/sign_in_usecase.dart';
import 'package:my_webpage/presentation/viewmodel/auth_view_model.dart';

// AuthRepository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

// SignInUseCase Provider
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInUseCase(authRepository);
});

// AuthViewModel Provider
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<UserCredential?>>((ref) {
  final signInUseCase = ref.watch(signInUseCaseProvider);
  return AuthViewModel(
    signInUseCase,
    TextEditingController(),
    TextEditingController(),
  );
});
