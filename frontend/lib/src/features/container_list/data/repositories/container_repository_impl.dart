import 'package:dio/dio.dart';
import 'package:exapmle_docker_pinger/src/core/constants/api_constants.dart';
import 'package:exapmle_docker_pinger/src/core/constants/network_constants.dart';
import '../../domain/entities/container_entity.dart';
import '../../domain/repositories/container_repository.dart';
import '../models/container_model.dart';

class ContainerRepositoryImpl implements ContainerRepository {
  final Dio dio;
  final String apiUrl =
      '${NetworkConstants.SCHEME}${NetworkConstants.HOST}:${NetworkConstants.PORT}${ApiConstants.pings}';

  ContainerRepositoryImpl() : dio = Dio() {
    dio.options.baseUrl = apiUrl;
  }

  @override
  Future<List<ContainerEntity>> getContainers() async {
    try {
      // final response = await dio.get('/containers');
      // if (response.statusCode == 201) {
      //   List data = response.data;
      // return data.map((e) => ContainerModel.fromJson(e).toEntity()).toList();
      final List<ContainerEntity> mockContainers = [
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '1',
                ip: '192.168.1.1',
                pingTime: 12,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 5)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        // ContainerModel(
        ContainerModel(
                id: '2',
                ip: '192.168.1.2',
                pingTime: 24,
                lastSuccessfulPing:
                    DateTime.now().subtract(Duration(minutes: 10)))
            .toEntity(),
        //   id: '3',
        //   ip: '192.168.1.3',
        //   pingTime: 36,
        //   lastSuccessfulPing: DateTime.now().subtract(Duration(minutes: 15)),
        // ).toEntity(),
      ];

      return mockContainers;
      // } else {
      //   throw Exception('Ошибка: ${response.statusCode}');
      // }
    } on DioException catch (e) {
      throw Exception('Ошибка запроса: ${e.message}');
    }
  }
}
