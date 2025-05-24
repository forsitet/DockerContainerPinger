// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'container_model.g.dart';

@JsonSerializable()
class ContainerModel extends ContainerEntity with EquatableMixin {
  @JsonKey(name: 'container_name')
  @override
  final String containerName;

  @JsonKey(name: 'ip_address')
  @override
  final String ipAddress;

  @JsonKey(name: 'ping_time')
  @override
  final double pingTime;

  @JsonKey(name: 'last_success')
  @override
  final DateTime lastSuccess;

  ContainerModel({
    super.id,
    required this.containerName,
    required this.ipAddress,
    required this.pingTime,
    required this.lastSuccess,
  }) : super(
            containerName: containerName,
            ipAddress: ipAddress,
            pingTime: pingTime,
            lastSuccess: lastSuccess);

  factory ContainerModel.fromJson(Map<String, dynamic> json) =>
      _$ContainerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContainerModelToJson(this);

  @override
  List<Object?> get props =>
      [id, containerName, ipAddress, pingTime, lastSuccess];
}
