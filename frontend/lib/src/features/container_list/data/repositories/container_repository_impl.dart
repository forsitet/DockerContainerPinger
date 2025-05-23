import 'package:exapmle_docker_pinger/src/features/container_list/data/datasources/container_remote_datasource.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/data/models/container_model.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/repositories/container_repository.dart';

class ContainerRepositoryImpl implements ContainerRepository {
  final ContainerRemoteDataSource remote;

  ContainerRepositoryImpl(this.remote);

  @override
  Future<List<ContainerEntity>> getContainers({int limit = 100}) {
    return remote.getContainers(limit: limit);
  }

  @override
  Future<ContainerEntity> sendPing(ContainerEntity entity) {
    return remote.sendPing(ContainerModel(
      id: entity.id ?? 0,
      containerName: entity.containerName,
      ipAddress: entity.ipAddress,
      pingTime: entity.pingTime,
      lastSuccess: entity.lastSuccess,
    ));
  }

  @override
  Future<void> deleteOldContainers(DateTime before) {
    return remote.deleteOldContainers(before);
  }
}
