import '../entities/container_entity.dart';

abstract class ContainerRepository {
  Future<List<ContainerEntity>> getContainers({int limit});
  Future<ContainerEntity> sendPing(ContainerEntity entity);
  Future<void> deleteOldContainers();
}
