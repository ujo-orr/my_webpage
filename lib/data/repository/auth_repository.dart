import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '이메일 형식이 잘못되었습니다.';
      case 'wrong-password':
        return '비밀번호가 틀렸습니다.';
      case 'user-not-found':
        return '이 이메일 주소로 등록된 계정을 찾을 수 없습니다.';
      case 'user-disabled':
        return '이 계정은 비활성화되었습니다.';
      case 'too-many-requests':
        return '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해 주세요.';
      case 'operation-not-allowed':
        return '이 로그인 방식은 현재 허용되지 않습니다.';
      default:
        return '로그인 실패';
    }
  }
}
