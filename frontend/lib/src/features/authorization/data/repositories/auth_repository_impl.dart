import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:exapmle_docker_pinger/src/core/constants/api_constants.dart';
import 'package:exapmle_docker_pinger/src/core/constants/network_constants.dart';
import 'package:exapmle_docker_pinger/src/core/router/navigation_manager.dart';
import 'package:exapmle_docker_pinger/src/features/authorization/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final String baseUrl;

  AuthRepositoryImpl({
    required this.dio,
    this.baseUrl = "${NetworkConstants.SCHEME}${NetworkConstants.HOST}:${NetworkConstants.AUTH_PORT}",
  });

  @override
  Future<void> login(String username, String password) async {
    final response = await dio.post(
      '$baseUrl${ApiConstants.login}',
      data: jsonEncode({
        'username': username,
        'password': password,
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<void> logout() async {
    NavigatorManager navigatorManager = NavigatorManager();
    navigatorManager.navigateToLogin();
  }

  @override
  Future<bool> isAuthenticated() async {
    return true;
  }

  @override
  Future<String> getToken() async {
    return 'session';
  }
}