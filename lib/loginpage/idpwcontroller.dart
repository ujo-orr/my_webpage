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
          return 'Empty';
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
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: idController.text, password: pwController.text);
            print('login complete $userCredential');
            // 로그인 성공 후 로직
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              context.go('/postingPage');
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('error'),
                    content: Text('User not found'),
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
              });
            } else if (e.code == 'wrong-password') {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('password'),
                      content: Text('password not'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('ok'),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              Exception('login Fail: ${e.message}');
            }
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
