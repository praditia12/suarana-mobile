import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../services/genre_service.dart';

final _genreService = GenreService();

final genreTracksProvider = FutureProvider.family<List<TrackModel>, String>(
  (ref, genre) async {
    return _genreService.fetchTracksByGenre(genre);
  },
);