import 'package:dio/dio.dart';
import 'package:exapmle_docker_pinger/src/core/constants/api_constants.dart';
import 'package:exapmle_docker_pinger/src/core/constants/network_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final String apiUrl =
      '${NetworkConstants.SCHEME}${NetworkConstants.HOST}:${NetworkConstants.PORT}${ApiConstants.login}';

  AuthRepositoryImpl() : dio = Dio() {
    dio.options.baseUrl = apiUrl;
  }

  @override
  Future<UserEntity> login(
      String username, String password, bool isAdmin) async {
    try {
      // final response = await dio.post('/login', data: {
      //   'username': username,
      //   'password': password,
      //   'isAdmin': isAdmin,
      // });

      if (true) {
        // if (response.statusCode == 200) {
        // return UserModel.fromJson(response.data).toEntity();
        return UserModel(token: 'qdwqdqwdqwd', username: username).toEntity();
      } else {
        // throw Exception('Ошибка авторизации: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Ошибка запроса: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/logout');
    } on DioException catch (e) {
      throw Exception('Ошибка выхода: ${e.message}');
    }
  }
}
