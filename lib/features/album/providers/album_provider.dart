import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../services/album_service.dart';

final _albumService = AlbumService();

final albumTracksProvider = FutureProvider.family<List<TrackModel>, String>(
  (ref, albumId) async {
    return _albumService.fetchAlbumTracks(albumId);
  },
);