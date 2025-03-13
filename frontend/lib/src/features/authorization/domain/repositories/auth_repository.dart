import 'package:exapmle_docker_pinger/src/features/authorization/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String password, bool isAdmin);
  Future<void> logout();
}
