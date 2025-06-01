// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContainerModel _$ContainerModelFromJson(Map<String, dynamic> json) =>
    ContainerModel(
      id: (json['id'] as num?)?.toInt(),
      containerName: json['container_name'] as String,
      ipAddress: json['ip_address'] as String,
      pingTime: (json['ping_time'] as num).toDouble(),
      lastSuccess: DateTime.parse(json['last_success'] as String),
    );

Map<String, dynamic> _$ContainerModelToJson(ContainerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'container_name': instance.containerName,
      'ip_address': instance.ipAddress,
      'ping_time': instance.pingTime,
      'last_success': instance.lastSuccess.toIso8601String(),
    };
