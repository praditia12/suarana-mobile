import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/track_model.dart';
import '../services/search_service.dart';

enum SearchStatus { idle, loading, success, empty, error }

class SearchState {
  final String query;
  final List<TrackModel> results;
  final SearchStatus status;
  final String? errorMessage;
  final bool isNoInternet;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.status = SearchStatus.idle,
    this.errorMessage,
    this.isNoInternet = false,
  });

  SearchState copyWith({
    String? query,
    List<TrackModel>? results,
    SearchStatus? status,
    String? errorMessage,
    bool? isNoInternet,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isNoInternet: isNoInternet ?? this.isNoInternet,
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  final _service = SearchService();
  Timer? _debounce;

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounce?.cancel();
    });
    return const SearchState();
  }

  void onQueryChanged(String query) {
    final trimmed = query.trim();

    // Reset ke idle kalau query kosong
    if (trimmed.isEmpty) {
      _debounce?.cancel();
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      query: trimmed,
      status: SearchStatus.loading,
    );

    // Debounce 500ms — tidak hit API setiap ketikan
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(trimmed);
    });
  }

  Future<void> _search(String query) async {
    try {
      final results = await _service.searchTracks(query);
      state = state.copyWith(
        results: results,
        status: results.isEmpty ? SearchStatus.empty : SearchStatus.success,
        isNoInternet: false,
      );
    } catch (e) {
      final isNoInternet = e.toString().contains('no_internet');
      state = state.copyWith(
        results: [],
        status: SearchStatus.error,
        errorMessage: isNoInternet
            ? 'Tidak ada koneksi internet'
            : 'Gagal mencari lagu, coba lagi',
        isNoInternet: isNoInternet,
      );
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    state = const SearchState();
  }

  // Cleanup handled via `ref.onDispose` in `build()`
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);