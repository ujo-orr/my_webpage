import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_webpage/data/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserCredential?> execute(String email, String password) {
    return authRepository.signIn(email, password);
  }
}
