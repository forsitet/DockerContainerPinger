import 'package:exapmle_docker_pinger/src/core/router/app_router.dart';
import 'package:exapmle_docker_pinger/src/core/styles/app_colors.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_event.dart';
import 'package:exapmle_docker_pinger/src/core/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController usernameController;

  late final TextEditingController passwordController;

  @override
  void initState() {
    usernameController = TextEditingController(text: 'forsitet');
    passwordController = TextEditingController(text: '12345');
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final screenSenter = MediaQuery.of(context).size.width / 3 - 200;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: screenSenter),
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AuthTitleAndInput(
                      usernameController: usernameController,
                      passwordController: passwordController),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Успешный вход!')),
                        );
                        context.go(AppRouteNames.containers);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Направильный логин или пароль')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                            onPressed: () {
                              final username = usernameController.text;
                              final password = passwordController.text;
                              authBloc.add(LoginRequested(
                                username: username,
                                password: password,
                              ));
                              // context.goNamed(AppRouteNames.containers);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 26, 49, 27),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: TextStyle(fontSize: 18),
                              foregroundColor: Colors.white,
                            ),
                            child:
                                Text('Войти', style: TextStyle(fontSize: 18))),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void authBlocListener(context, state) {}
}

class AuthTitleAndInput extends StatelessWidget {
  const AuthTitleAndInput({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Авторизация',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя'),
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                authBloc.add(LoginRequested(
                  username: usernameController.text,
                  password: passwordController.text,
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
