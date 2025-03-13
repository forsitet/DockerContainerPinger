import 'package:exapmle_docker_pinger/src/features/authorization/domain/entities/user_entity.dart';

class UserModel {
  final String token;
  final String username;

  UserModel({required this.token, required this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      username: json['username'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(token: token, username: username);
  }
}
