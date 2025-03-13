import '../entities/container_entity.dart';
import '../repositories/container_repository.dart';

class GetContainersUseCase {
  final ContainerRepository repository;

  GetContainersUseCase(this.repository);

  Future<List<ContainerEntity>> call() async {
    return await repository.getContainers();
  }
}
