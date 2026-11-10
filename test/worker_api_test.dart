import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/core/network/worker_api_service.dart';
import 'package:khedma/core/network/api_client.dart';

void main() {
  test('Worker API CRUD operations', () async {
    final service = WorkerApiService();
    String? workerId;

    try {
      final worker = await service.createWorker({
        'name': 'Test Worker',
        'job': 'Plumber',
        'specialty': 'Water pipes',
        'experience': 3,
        'area': 'Cairo',
        'price': 200,
        'phone': '01000000000',
        'bio': 'Test worker',
        'rating': 0,
        'status': 'pending',
        'avatar': '',
        'available': false,
        'portfolioImages': '[]',
        'reviews': '[]',
      });

      workerId = worker.id;

      final workers = await service.getWorkers();
      expect(workers.any((w) => w.id == worker.id), true);

      final result = await service.getWorkerById(worker.id);
      expect(result.id, worker.id);

      final updatedWorker = await service.updateWorker(worker.id, {
        'name': 'Updated Worker',
      });

      expect(updatedWorker.name, 'Updated Worker');
    } finally {
      if (workerId != null) {
        await ApiClient.dio.delete('/workers/$workerId');
      }
    }
  });
}
