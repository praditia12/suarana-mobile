import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/track_model.dart';
import '../../../../core/models/album_model.dart';
import '../../../core/models/genre_model.dart';
import '../services/audius_home_service.dart';

// Instance service
final _homeService = AudiusHomeService();

final trendingTracksProvider = FutureProvider<List<TrackModel>>((ref) async {
  return _homeService.fetchTrendingTracks(limit: 4);
});

final popularAlbumsProvider = FutureProvider<List<AlbumModel>>((ref) async {
  return _homeService.fetchPopularAlbums(limit: 10);
});

final popularGenreProvider = FutureProvider<List<GenreModel>>((ref) async {
  return _homeService.fetchPopularGenre(limit: 4);
});
