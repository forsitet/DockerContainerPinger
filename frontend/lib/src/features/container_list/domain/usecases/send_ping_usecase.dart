import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/repositories/container_repository.dart';

class SendPingUseCase {
  final ContainerRepository repository;

  SendPingUseCase(this.repository);

  Future<ContainerEntity> call(ContainerEntity entity) {
    return repository.sendPing(entity);
  }
}
