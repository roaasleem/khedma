import 'package:flutter_bloc/flutter_bloc.dart';
import 'worker_dashboard_state.dart';
import 'package:khedma/core/network/worker_api_service.dart';
class WorkerDashboardCubit extends Cubit<WorkerDashboardState> {
  WorkerDashboardCubit() : super(WorkerDashboardInitial());

final WorkerApiService workerApiService = WorkerApiService();
Future<void> getWorkerData(String id) async {
   emit(WorkerDashboardLoading());
   try {
final worker = await workerApiService.getWorkerById(id);
emit(WorkerDashboardSuccess(worker));
} catch (e) {
  emit(WorkerDashboardError(e.toString()));

}
}
}