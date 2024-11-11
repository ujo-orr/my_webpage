import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/data/provider/auth_provider.dart';
import 'package:my_webpage/shared/utility/validator.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final viewModelNotifier = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: viewModelNotifier.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: viewModelNotifier.idController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Email',
                      ),
                      validator: Validators.emailValidator,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: viewModelNotifier.pwController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Password',
                      ),
                      validator: Validators.passwordValidator,
                    ),
                  ),
                  const SizedBox(height: 16),
                  authViewModel.when(
                    data: (user) {
                      return ElevatedButton(
                        onPressed: () async {
                          await viewModelNotifier.signIn();
                          if (user != null) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (timeStamp) {
                                context.go('/ej23it289htaw4h');
                              },
                            );
                          }
                        },
                        child: const Text('LOGIN'),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('로그인 실패: $error'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('GO HOME'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
