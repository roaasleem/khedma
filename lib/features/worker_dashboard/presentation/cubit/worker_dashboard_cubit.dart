
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/network/worker_api_service.dart';
import 'worker_dashboard_state.dart';

class WorkerDashboardCubit extends Cubit<WorkerDashboardState> {
  WorkerDashboardCubit() : super(WorkerDashboardInitial());

  final WorkerApiService workerApiService = WorkerApiService();

  Timer? _refreshTimer;

  bool _isFetching = false;
  bool _isUpdating = false;

  Future<void> getWorkerData(String id) async {
    _refreshTimer?.cancel();

    await _fetchWorkerData(id, showLoading: true);

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        _fetchWorkerData(id, showLoading: false);
      },
    );
  }

  Future<void> _fetchWorkerData(
    String id, {
    required bool showLoading,
  }) async {
    if (_isFetching || _isUpdating) return;

    _isFetching = true;

    if (showLoading) {
      emit(WorkerDashboardLoading());
    }

    try {
      final worker = await workerApiService.getWorkerById(id);
      emit(WorkerDashboardSuccess(worker));
    } catch (e) {
      if (showLoading || state is! WorkerDashboardSuccess) {
        emit(WorkerDashboardError(e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }

 
  Future<bool> updateWorkerProfile(
  String id,
  Map<String, dynamic> workerData,
) async {
  print('UPDATE START');

  if (_isUpdating || _isFetching) {
    print('UPDATE BLOCKED: another request is running');
    return false;
  }

  _isUpdating = true;

  try {
    print('SENDING PUT REQUEST...');

    final updatedWorker = await workerApiService.updateWorker(
      id,
      workerData,
    );

    print('UPDATE SUCCESS');

    emit(WorkerDashboardSuccess(updatedWorker));
    return true;
  } catch (e) {
    print('UPDATE ERROR: $e');

    emit(WorkerDashboardError(e.toString()));
    return false;
  } finally {
    _isUpdating = false;
    print('UPDATE FINISHED');
  }
}
  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
