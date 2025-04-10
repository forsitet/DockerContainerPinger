import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/repositories/container_repository.dart';

class GetContainersUseCase {
  final ContainerRepository repository;

  GetContainersUseCase(this.repository);

  Future<List<ContainerEntity>> call({int limit = 100}) {
    return repository.getContainers(limit: limit);
  }
}
