import 'package:exapmle_docker_pinger/src/features/container_list/domain/repositories/container_repository.dart';

class DeleteContainersUseCase {
  final ContainerRepository repository;

  DeleteContainersUseCase(this.repository);

  Future<void> call(DateTime before) {
    return repository.deleteOldContainers(before);
  }
}
