import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';

class ContainerModel {
  final String id;
  final String ip;
  final int pingTime;
  final DateTime lastSuccessfulPing;

  ContainerModel({
    required this.id,
    required this.ip,
    required this.pingTime,
    required this.lastSuccessfulPing,
  });

  ContainerEntity toEntity() {
    return ContainerEntity(
      id: id,
      ip: ip,
      pingTime: pingTime,
      lastSuccessfulPing: lastSuccessfulPing,
    );
  }

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'],
      ip: json['ip'],
      pingTime: json['pingTime'],
      lastSuccessfulPing: DateTime.parse(json['lastSuccessfulPing']),
    );
  }
}
