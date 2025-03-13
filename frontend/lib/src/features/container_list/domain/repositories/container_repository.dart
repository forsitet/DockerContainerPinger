import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';

abstract class ContainerRepository {
  Future<List<ContainerEntity>> getContainers();
}
