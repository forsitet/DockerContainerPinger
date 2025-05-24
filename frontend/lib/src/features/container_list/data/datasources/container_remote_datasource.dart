import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:exapmle_docker_pinger/src/core/constants/api_constants.dart';
import 'package:exapmle_docker_pinger/src/core/constants/network_constants.dart';
import 'package:exapmle_docker_pinger/src/features/container_list/data/models/container_model.dart';

class ContainerRemoteDataSource {
  final Dio dio;

  ContainerRemoteDataSource(this.dio);

  String baseUrl =
      '${NetworkConstants.SCHEME}${NetworkConstants.HOST}:${NetworkConstants.PORT}';

  Future<List<ContainerModel>> getContainers({int limit = 100}) async {
    try {
      final response = await dio
          .get(baseUrl + ApiConstants.pings, queryParameters: {'limit': limit});
      if (response.statusCode == 200) {
        log(response.data.toString());
        log((response.data as List).isEmpty.toString());
        if ((response.data as List).isEmpty) {
          return [];
        }
        final raw = List<Map<String, dynamic>>.from(response.data);
        return raw.map((e) => ContainerModel.fromJson(e)).toList();
      }
      log('Error: ${response.statusCode} - ${response.data}');
      throw Exception('Failed to load containers');
    } catch (e) {
      log('Error: $e');
      throw Exception('Failed to load containers');
    }
  }

  Future<ContainerModel> sendPing(ContainerModel model) async {
    try {
      final response =
          await dio.post(baseUrl + ApiConstants.ping, data: model.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        return model;
      }
      throw Exception('Failed to send ping: ${response.statusCode}');
    } on DioException catch (e) {
      //log('DioError: ${e.message}');
      throw Exception('Failed to send ping: ${e.message}');
    } catch (e) {
      //log('Error: $e');
      throw Exception('Failed to send ping');
    }
  }

  Future<void> deleteOldContainers(DateTime before) async {
    final url = baseUrl + ApiConstants.pingsOld;
    log('Deleting containers older than $before');
    final response = await dio.delete(url, queryParameters: {
      'before': before.toUtc().toIso8601String(),
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete old containers');
    }
  }
}
