import 'package:equatable/equatable.dart';

import 'package:khedma/core/models/worker_model.dart';

enum SearchStatus { initial, loading, loaded, empty, error }

class SearchState extends Equatable {
  /// حالة الشاشة الحالية.
  final SearchStatus status;

  /// العمال المعتمدون القادمين من الـ API.
  final List<WorkerModel> allWorkers;

  /// النتائج بعد تطبيق نص البحث.
  final List<WorkerModel> results;

  final String query;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.allWorkers = const [],
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<WorkerModel>? allWorkers,
    List<WorkerModel>? results,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      allWorkers: allWorkers ?? this.allWorkers,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allWorkers,
        results,
        query,
        errorMessage,
      ];
}