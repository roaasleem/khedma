abstract class WorkerRegistrationState {}

class WorkerRegistrationInitial extends WorkerRegistrationState {}

class WorkerRegistrationLoading extends WorkerRegistrationState {}

class WorkerRegistrationSuccess extends WorkerRegistrationState {}

class WorkerRegistrationError extends WorkerRegistrationState {
  final String message;

  WorkerRegistrationError(this.message);
}
