import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/delete_container_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/get_containers_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/send_ping_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'container_list_event.dart';
import 'container_list_state.dart';

class ContainerListBloc extends Bloc<ContainerListEvent, ContainerListState> {
  final GetContainersUseCase getContainers;
  final SendPingUseCase sendPing;
  final DeleteContainersUseCase deleteOld;

  ContainerListBloc({
    required this.getContainers,
    required this.sendPing,
    required this.deleteOld,
  }) : super(ContainerListInitial()) {
    on<LoadContainersEvent>(_onLoadContainers);
    on<SendPingEvent>(_onSendPing);
    on<DeleteOldContainersEvent>(_onDeleteOld);
  }

  Future<void> _onLoadContainers(
    LoadContainersEvent event,
    Emitter<ContainerListState> emit,
  ) async {
    emit(ContainerListLoading());
    try {
      final containers = await getContainers();
      emit(ContainerListLoaded(containers));
    } catch (e) {
      emit(ContainerListError(message: e.toString()));
    }
  }

  Future<void> _onSendPing(
    SendPingEvent event,
    Emitter<ContainerListState> emit,
  ) async {
    if (state is! ContainerListLoaded) return;

    final currentState = state as ContainerListLoaded;
    emit(ContainerListLoading());

    try {
      final updated = await sendPing(event.container);

      final updatedList = currentState.containers.map((c) {
        if (c.id != null && updated.id != null && c.id == updated.id) {
          return updated;
        }
        return c;
      }).toList();

      emit(ContainerListLoaded(updatedList));
      event.onSuccess?.call();
    } catch (e) {
      emit(currentState);
      event.onError?.call('Ошибка при обновлении: ${e.toString()}');
    }
  }

  Future<void> _onDeleteOld(
    DeleteOldContainersEvent event,
    Emitter<ContainerListState> emit,
  ) async {
    if (state is ContainerListLoaded) {
      try {
        await deleteOld();
        add(LoadContainersEvent());
        event.onSuccess?.call();
      } catch (e) {
        event.onError?.call('Ошибка при удалении: ${e.toString()}');
      }
    }
  }
}
