import 'package:khedma/core/models/worker_model.dart';
abstract class WorkerDashboardState {
  
}
class WorkerDashboardInitial extends WorkerDashboardState {

}
class WorkerDashboardLoading extends WorkerDashboardState {

}
class WorkerDashboardSuccess extends WorkerDashboardState {
  final WorkerModel worker;
  WorkerDashboardSuccess(this.worker);
}
class WorkerDashboardError extends WorkerDashboardState {
  final String message;

  WorkerDashboardError(this.message);
}