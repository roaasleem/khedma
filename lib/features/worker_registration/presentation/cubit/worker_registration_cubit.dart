import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/worker_registration/presentation/cubit/worker_registration_state.dart';
import 'package:khedma/core/network/worker_api_service.dart';

class WorkerRegistrationCubit extends Cubit<WorkerRegistrationState> {
  WorkerRegistrationCubit() : super(WorkerRegistrationInitial());
  final WorkerApiService workerApiService = WorkerApiService();
  Future<void> registerWorker({
    required Map<String, dynamic> workerData,
  }) async {
    try {
      emit(WorkerRegistrationLoading());

      await workerApiService.createWorker(workerData);

      emit(WorkerRegistrationSuccess());
    } catch (e) {
      emit(WorkerRegistrationError(e.toString()));
    }
  }
}
