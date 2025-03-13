import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../pages/login_page.dart';

class LoginScreenFactory {
  static Widget create(BuildContext context) {
    var value = context.read<AuthBloc>();
    return BlocProvider<AuthBloc>.value(
      value: value,
      child: LoginPage(),
    );
  }
}
