import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// События
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final bool isAdmin;

  LoginEvent(
      {required this.username, required this.password, required this.isAdmin});
}

class LogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(
            event.username, event.password, event.isAdmin);
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
