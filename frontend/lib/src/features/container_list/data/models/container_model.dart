import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';

class ContainerModel extends ContainerEntity {
  ContainerModel({
    required super.id,
    required super.containerName,
    required super.ipAddress,
    required super.pingTime,
    required super.lastSuccess,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'] ?? 0,
      containerName: json['container_name'],
      ipAddress: json['ip_address'],
      pingTime: (json['ping_time'] as num).toDouble(),
      lastSuccess: DateTime.parse(json['last_success'].replaceAll('"', '')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'container_name': containerName,
      'ip_address': ipAddress,
      'ping_time': pingTime,
      'last_success': lastSuccess.toIso8601String(),
      // 'last_success': '"${lastSuccess.toIso8601String()}"',
    };
  }
}
