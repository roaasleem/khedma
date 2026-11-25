import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khedma/core/enums/worker_status.dart';
import 'package:khedma/core/models/worker_model.dart';
import 'package:khedma/core/network/worker_api_service.dart';

import 'search_state.dart';

/// بيجيب العمال المعتمدين من الـ API مرة واحدة،
// — وبعد كده بيفلتر محليًا بالاسم أو المهنة أو المنطقة.
class SearchCubit extends Cubit<SearchState> {
  final WorkerApiService _workerApiService;

  SearchCubit({WorkerApiService? workerApiService})
      : _workerApiService = workerApiService ?? WorkerApiService(),
        super(const SearchState());

  Future<void> loadWorkers() async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final workers = await _workerApiService.getWorkers();

      final approvedWorkers = workers
          .where((worker) => worker.status == WorkerStatus.approved)
          .toList();

      final results = _filterWorkers(approvedWorkers, state.query);

      emit(
        state.copyWith(
          status: results.isEmpty ? SearchStatus.empty : SearchStatus.loaded,
          allWorkers: approvedWorkers,
          results: results,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          errorMessage: 'حدث خطأ أثناء تحميل العمال، حاول مرة تانية.',
        ),
      );
    }
  }

  /// بيتنادى مع تغيير نص البحث.
  void search(String query) {
    final results = _filterWorkers(state.allWorkers, query);

    emit(
      state.copyWith(
        query: query,
        results: results,
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.loaded,
      ),
    );
  }

  List<WorkerModel> _filterWorkers(
    List<WorkerModel> workers,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return workers;
    }

    return workers.where((worker) {
      return worker.name.toLowerCase().contains(normalizedQuery) ||
          worker.profession.toLowerCase().contains(normalizedQuery) ||
          worker.area.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}