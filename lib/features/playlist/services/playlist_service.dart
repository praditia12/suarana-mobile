import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/track_model.dart';

class PlaylistService {
  final SupabaseClient _client;

  PlaylistService(this._client);

  // Playlist CRUD

  Future<List<Map<String, dynamic>>> fetchPlaylists() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthenticated');

    return await _client
        .from('playlists')
        .select()
        .eq('user_id', user.id)
        .order('created_at');
  }

  Future<Map<String, dynamic>> createPlaylist(String name) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthenticated');

    final result = await _client
        .from('playlists')
        .insert({'user_id': user.id, 'name': name})
        .select()
        .single();

    return result;
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _client
        .from('playlists')
        .delete()
        .eq('id', playlistId);
  }

  // Playlist Tracks

  Future<List<Map<String, dynamic>>> fetchPlaylistTracks(
      String playlistId) async {
    return await _client
        .from('playlist_tracks')
        .select()
        .eq('playlist_id', playlistId)
        .order('position');
  }

  Future<void> addTrackToPlaylist({
    required String playlistId,
    required TrackModel track,
    required int position,
  }) async {
    await _client.from('playlist_tracks').upsert({
      'playlist_id': playlistId,
      'track_id': track.id,
      'track_title': track.title,
      'artist_name': track.artistName,
      'artwork_url': track.artworkUrl,
      'duration': track.duration,
      'position': position,
    });
  }

  Future<void> removeTrackFromPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    await _client
        .from('playlist_tracks')
        .delete()
        .eq('playlist_id', playlistId)
        .eq('track_id', trackId);
  }

  Future<bool> isTrackInPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    final result = await _client
        .from('playlist_tracks')
        .select('id')
        .eq('playlist_id', playlistId)
        .eq('track_id', trackId)
        .maybeSingle();

    return result != null;
  }

  // Liked Playlist

  Future<Map<String, dynamic>?> fetchLikedPlaylist() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Unauthenticated');

    return await _client
        .from('playlists')
        .select()
        .eq('user_id', user.id)
        .eq('is_default', true)
        .maybeSingle();
  }

  Future<bool> isTrackLiked(String trackId) async {
    final liked = await fetchLikedPlaylist();
    if (liked == null) return false;
    return isTrackInPlaylist(
      playlistId: liked['id'] as String,
      trackId: trackId,
    );
  }

  Future<void> toggleLike(TrackModel track) async {
    final liked = await fetchLikedPlaylist();
    if (liked == null) return;

    final playlistId = liked['id'] as String;
    final alreadyLiked = await isTrackInPlaylist(
      playlistId: playlistId,
      trackId: track.id,
    );

    if (alreadyLiked) {
      await removeTrackFromPlaylist(
        playlistId: playlistId,
        trackId: track.id,
      );
    } else {
      // Hitung posisi terakhir
      final tracks = await fetchPlaylistTracks(playlistId);
      await addTrackToPlaylist(
        playlistId: playlistId,
        track: track,
        position: tracks.length,
      );
    }
  }
}