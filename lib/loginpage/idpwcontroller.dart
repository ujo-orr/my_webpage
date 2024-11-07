import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class IdPwController {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Widget idTextFormField() {
    return TextFormField(
      controller: idController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Hi : )',
      ),
      inputFormatters: [
        FilteringTextInputFormatter(RegExp(r'^[가-힣a-zA-Z0-9@.]*$'), allow: true)
      ],
      maxLength: 20,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty.';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return '유효한 이메일을 입력하세요.';
        }
        return null;
      },
    );
  }

  Widget pwTextFormField() {
    return TextFormField(
      controller: pwController,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'I want to do better..',
      ),
      maxLength: 20,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty.';
        }
        if (!RegExp(r'^[a-zA-Z0-9!@+]+$').hasMatch(value)) {
          return 'No.';
        }
        return null;
      },
    );
  }

  Widget loginElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState?.validate() ?? false) {
          try {
            // ignore: unused_local_variable
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: idController.text, password: pwController.text);

            // 로그인 성공 후 로직
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              context.go('/ej23it289htaw4h');
            });
          } on FirebaseAuthException catch (e) {
            String errorMessage;
            if (e.code == 'invalid-email') {
              errorMessage = '없는 아이디 입니다.';
            } else if (e.code == 'invalid-password') {
              errorMessage = '비밀번호가 틀렸습니다.';
            } else if (e.code == 'invalid-credential') {
              errorMessage = '잘못된 정보입니다.';
            } else {
              errorMessage = '${e.message}';
            }

            // 다이얼로그 표시
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('로그인 실패'),
                    content: Text(errorMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
      child: Text('LOGIN'),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          idTextFormField(),
          SizedBox(height: 16),
          pwTextFormField(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
