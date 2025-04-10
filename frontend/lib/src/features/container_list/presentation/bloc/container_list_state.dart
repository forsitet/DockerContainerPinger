import 'package:equatable/equatable.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';
abstract class ContainerListState extends Equatable {
  const ContainerListState();

  @override
  List<Object?> get props => [];
}

class ContainerListInitial extends ContainerListState {}

class ContainerListLoading extends ContainerListState {}

class ContainerListLoaded extends ContainerListState {
  final List<ContainerEntity> containers;

  const ContainerListLoaded(this.containers);

  @override
  List<Object> get props => [containers];
}

class ContainerListError extends ContainerListState {
  final String message;

  const ContainerListError({required this.message});

  @override
  List<Object> get props => [message];
}
