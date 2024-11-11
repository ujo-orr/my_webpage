import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '없는 아이디 입니다.';
      case 'wrong-password':
        return '비밀번호가 틀렸습니다.';
      case 'user-not-found':
        return '계정을 찾을 수 없습니다.';
      default:
        return '로그인 실패: ${e.message}';
    }
  }
}
