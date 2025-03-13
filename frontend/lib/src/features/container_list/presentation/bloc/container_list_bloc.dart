import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_containers_usecase.dart';
import 'container_list_event.dart';
import 'container_list_state.dart';

class ContainerListBloc extends Bloc<ContainerListEvent, ContainerListState> {
  final GetContainersUseCase getContainersUseCase;

  ContainerListBloc(this.getContainersUseCase) : super(ContainerListInitial()) {
    on<LoadContainersEvent>((event, emit) async {
      emit(ContainerListLoading());
      try {
        final containers = await getContainersUseCase();
        emit(ContainerListLoaded(containers));
      } catch (e) {
        emit(ContainerListError(e.toString()));
      }
    });
  }
}
