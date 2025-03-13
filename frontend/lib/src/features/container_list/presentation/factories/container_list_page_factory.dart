import 'package:exapmle_docker_pinger/src/features/container_list/data/repositories/container_repository_impl.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/domain/usecases/get_containers_usecase.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/bloc/container_list_bloc.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/presentation/pages/container_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContainerListPageFactory {
  final GetContainersUseCase getContainersUseCase;

  ContainerListPageFactory({required this.getContainersUseCase});

  Widget create() {
    final containerRepository = ContainerRepositoryImpl();
    final getContainersUseCase = GetContainersUseCase(containerRepository);
    return BlocProvider(
      create: (context) => ContainerListBloc(getContainersUseCase),
      child: ContainerListPage(),
    );
  }
}
