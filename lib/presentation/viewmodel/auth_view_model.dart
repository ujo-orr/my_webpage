import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/domain/usecase/sign_in_usecase.dart';

class AuthViewModel extends StateNotifier<AsyncValue<UserCredential?>> {
  final SignInUseCase signInUseCase;
  final TextEditingController idController;
  final TextEditingController pwController;
  final formKey = GlobalKey<FormState>();

  AuthViewModel(this.signInUseCase, this.idController, this.pwController)
      : super(const AsyncValue.data(null));

  Future<void> signIn() async {
    if (formKey.currentState?.validate() ?? false) {
      state = const AsyncValue.loading();
      try {
        final userCredential = await signInUseCase.execute(
          idController.text,
          pwController.text,
        );
        state = AsyncValue.data(userCredential);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
}
