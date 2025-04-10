// container_list_page_factory.dart

import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/delete_container_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/get_containers_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/send_ping_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/bloc/container_list_bloc.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/pages/container_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContainerListPageFactory {
  final GetContainersUseCase getContainersUseCase;

  ContainerListPageFactory({required this.getContainersUseCase});

  Widget create() {
    return BlocProvider(
      create: (_) => ContainerListBloc(
          getContainers: GetContainersUseCase(getContainersUseCase.repository),
          sendPing: SendPingUseCase(getContainersUseCase.repository),
          deleteOld: DeleteContainersUseCase(getContainersUseCase.repository)),
      child: const ContainerListPage(),
    );
  }
}
