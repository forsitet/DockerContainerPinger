import 'package:exapmle_docker_pinger/src/features/authorization/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.username, super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token,
    };
  }
}