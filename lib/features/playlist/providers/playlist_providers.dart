import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../services/playlist_service.dart';

// Service Provider
final playlistServiceProvider = Provider<PlaylistService>((ref) {
  return PlaylistService(ref.watch(supabaseClientProvider));
});

// Playlists List
final playlistsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(playlistServiceProvider).fetchPlaylists();
});

// Playlist Tracks

final playlistTracksProvider =
    FutureProvider.family<List<TrackModel>, String>((ref, playlistId) async {
  final rows = await ref
      .watch(playlistServiceProvider)
      .fetchPlaylistTracks(playlistId);

  // Convert dari Map Supabase ke TrackModel
  return rows.map((row) {
    return TrackModel(
      id: row['track_id'] as String,
      title: row['track_title'] as String,
      artistName: row['artist_name'] as String,
      artworkUrl: row['artwork_url'] as String?,
      duration: row['duration'] as int?,
    );
  }).toList();
});

// Like State
class LikeNotifier extends AsyncNotifier<bool> {
  LikeNotifier(this.trackId);
  final String trackId;

  @override
  Future<bool> build() async {
    return ref.watch(playlistServiceProvider).isTrackLiked(trackId);
  }

  Future<void> toggle(TrackModel track) async {
    await ref.read(playlistServiceProvider).toggleLike(track);
    state = AsyncData(!(state.value ?? false));
    // Refresh playlist "Suka" agar list terupdate
    ref.invalidate(playlistsProvider);
  }
}

final likeProvider = AsyncNotifierProvider.family<LikeNotifier, bool, String>(
  LikeNotifier.new,
);

// Playlist Actions Notifier
class PlaylistActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createPlaylist(String name) async {
    await ref.read(playlistServiceProvider).createPlaylist(name);
    ref.invalidate(playlistsProvider);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await ref.read(playlistServiceProvider).deletePlaylist(playlistId);
    ref.invalidate(playlistsProvider);
  }

  Future<void> addTrackToPlaylist({
    required String playlistId,
    required TrackModel track,
  }) async {
    final tracks = await ref
        .read(playlistServiceProvider)
        .fetchPlaylistTracks(playlistId);

    await ref.read(playlistServiceProvider).addTrackToPlaylist(
          playlistId: playlistId,
          track: track,
          position: tracks.length,
        );

    ref.invalidate(playlistTracksProvider(playlistId));
  }

  Future<void> removeTrackFromPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    await ref.read(playlistServiceProvider).removeTrackFromPlaylist(
          playlistId: playlistId,
          trackId: trackId,
        );
    ref.invalidate(playlistTracksProvider(playlistId));
  }
}

final playlistActionsProvider =
    AsyncNotifierProvider<PlaylistActionsNotifier, void>(
  PlaylistActionsNotifier.new,
);