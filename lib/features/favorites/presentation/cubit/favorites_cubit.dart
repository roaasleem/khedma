import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/worker_model.dart';
import '../../../../core/network/user_api_service.dart';
import '../../../../core/network/worker_api_service.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  String? _userId;

  final UserApiService _userApiService;
  final WorkerApiService _workerApiService;

  bool _isUpdatingFavorites = false;
  int _loadRequestId = 0;

  FavoritesCubit({
    String? userId,
    UserApiService? userApiService,
    WorkerApiService? workerApiService,
  }) : _userApiService = userApiService ?? UserApiService(),
       _workerApiService = workerApiService ?? WorkerApiService(),
       super(const FavoritesState()) {
    _userId = userId;
  }

  Future<void> setUserId(String? userId) async {
    if (_userId == userId) return;

    _userId = userId;
    _loadRequestId++;

    if (userId == null || userId.isEmpty) {
      emit(
        const FavoritesState(
          requiresLogin: true,
          errorMessage: 'Please log in to view your favorites.',
        ),
      );
      return;
    }

    emit(const FavoritesState(isLoading: true));

    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    final userId = _userId;

    if (userId == null || userId.isEmpty) {
      emit(
        const FavoritesState(
          requiresLogin: true,
          errorMessage: 'Please log in to view your favorites.',
        ),
      );
      return;
    }

    final requestId = ++_loadRequestId;

    emit(
      state.copyWith(isLoading: true, clearError: true, requiresLogin: false),
    );

    try {
      final user = await _userApiService.getUserById(userId);

      final favoriteIds = user.favorites
          .toSet()
          .where((id) => id.isNotEmpty)
          .toList();

      final results = await Future.wait(
        favoriteIds.map((id) async {
          try {
            return await _workerApiService.getWorkerById(id);
          } on DioException catch (e) {
            if (e.response?.statusCode == 404) {
              return null;
            }
            rethrow;
          }
        }),
      );

      if (isClosed || requestId != _loadRequestId || _userId != userId) {
        return;
      }

      final workers = results.whereType<WorkerModel>().toList();

      emit(FavoritesState(favorites: workers));
    } catch (e) {
      if (isClosed || requestId != _loadRequestId || _userId != userId) {
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load favorites. Please try again.',
        ),
      );
    }
  }

  Future<void> toggleFavorite(WorkerModel worker) async {
    final userId = _userId;

    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          requiresLogin: true,
          errorMessage: 'Please log in to manage your favorites.',
        ),
      );
      return;
    }

    if (_isUpdatingFavorites) return;

    _isUpdatingFavorites = true;

    final previousFavorites = List<WorkerModel>.from(state.favorites);
    final updatedFavorites = List<WorkerModel>.from(previousFavorites);

    final alreadyFavorite = updatedFavorites.any(
      (item) => item.id == worker.id,
    );

    if (alreadyFavorite) {
      updatedFavorites.removeWhere((item) => item.id == worker.id);
    } else {
      updatedFavorites.add(worker);
    }

    emit(state.copyWith(favorites: updatedFavorites, clearError: true));

    try {
      final favoriteIds = updatedFavorites
          .map((item) => item.id)
          .toSet()
          .toList();

      await _userApiService.updateFavorites(userId, favoriteIds);
    } catch (e) {
      if (!isClosed && _userId == userId) {
        emit(
          state.copyWith(
            favorites: previousFavorites,
            errorMessage: 'Unable to update favorites. Please try again.',
          ),
        );
      }
    } finally {
      _isUpdatingFavorites = false;
    }
  }

  bool isFavorite(String workerId) {
    return state.favorites.any((worker) => worker.id == workerId);
  }
}
