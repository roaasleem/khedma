import 'package:equatable/equatable.dart';

import '../../../../core/models/worker_model.dart';

class FavoritesState extends Equatable {
  final List<WorkerModel> favorites;
  final bool isLoading;
  final bool isLoaded;
  final String? errorMessage;
  final bool requiresLogin;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.isLoaded = false,
    this.errorMessage,
    this.requiresLogin = false,
  });

  FavoritesState copyWith({
    List<WorkerModel>? favorites,
    bool? isLoading,
    bool? isLoaded,
    String? errorMessage,
    bool? requiresLogin,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      requiresLogin: requiresLogin ?? this.requiresLogin,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    isLoading,
    isLoaded,
    errorMessage,
    requiresLogin,
  ];
}
