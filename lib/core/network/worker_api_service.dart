import 'package:khedma/core/models/worker_model.dart';
import 'api_client.dart';

class WorkerApiService {
  Future<List<WorkerModel>> getWorkers() async {
    final response = await ApiClient.dio.get('/workers');
    final List<dynamic> data = response.data;
    return data.map((worker) => WorkerModel.fromJson(worker)).toList();
  }

  Future<WorkerModel> getWorkerById(String id) async {
    final response = await ApiClient.dio.get('/workers/$id');
    return WorkerModel.fromJson(response.data);
  }

  Future<WorkerModel> createWorker(Map<String, dynamic> workerData) async {
    final response = await ApiClient.dio.post('/workers', data: workerData);
    return WorkerModel.fromJson(response.data);
  }

  Future<WorkerModel> updateWorker(
    String id,
    Map<String, dynamic> workerData,
  ) async {
    final response = await ApiClient.dio.put(
      '/workers/$id',
      data: workerData,
    );
    return WorkerModel.fromJson(response.data);
  }
}
