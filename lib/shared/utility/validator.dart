class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Empty.';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '유효한 이메일을 입력하세요.';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Empty.';
    if (!RegExp(r'^[a-zA-Z0-9!@+]+$').hasMatch(value)) {
      return 'Invalid characters used.';
    }
    return null;
  }
}
