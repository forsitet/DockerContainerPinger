import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:exapmle_docker_pinger/src/features/authorization/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity with EquatableMixin {
  UserModel({required super.username, super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [username, token];
}
