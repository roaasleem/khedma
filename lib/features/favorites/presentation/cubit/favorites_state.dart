import '../../../../core/models/worker_model.dart';

class FavoritesState {
  final List<WorkerModel> favorites;
  final bool isLoading;
  final String? errorMessage;
  final bool requiresLogin;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.errorMessage,
    this.requiresLogin = false,
  });

  FavoritesState copyWith({
    List<WorkerModel>? favorites,
    bool? isLoading,
    String? errorMessage,
    bool? requiresLogin,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      requiresLogin: requiresLogin ?? this.requiresLogin,
    );
  }
}
