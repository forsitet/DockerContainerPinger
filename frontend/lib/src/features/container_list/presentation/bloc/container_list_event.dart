import 'package:equatable/equatable.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/entities/container_entity.dart';

abstract class ContainerListEvent extends Equatable {
  const ContainerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadContainersEvent extends ContainerListEvent {
  final int? limit;

  const LoadContainersEvent({this.limit});

  @override
  List<Object?> get props => [limit];
}

class SendPingEvent extends ContainerListEvent {
  final ContainerEntity container;
  final void Function()? onSuccess;
  final void Function(String error)? onError;

  const SendPingEvent(this.container, {this.onSuccess, this.onError});
}

class DeleteOldContainersEvent extends ContainerListEvent {
  final DateTime before;
  final void Function()? onSuccess;
  final void Function(String error)? onError;

  const DeleteOldContainersEvent(
      {required this.before, this.onSuccess, this.onError});
}
