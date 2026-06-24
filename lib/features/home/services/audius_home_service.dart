// lib/features/home/data/audius_home_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/models/track_model.dart';
import '../../../../core/models/album_model.dart';
import '../../../core/models/genre_model.dart';

class AudiusHomeService {
  static const _host = 'https://api.audius.co';
  static const _appName = 'suarana';
  static const _timeout = Duration(seconds: 10);

  Future<List<TrackModel>> fetchTrendingTracks({int limit = 25}) async {
    final uri = Uri.parse(
      '$_host/v1/tracks/trending?app_name=$_appName&limit=$limit',
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Gagal fetch trending tracks: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data
        .map((json) => TrackModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<AlbumModel>> fetchPopularAlbums({
    int limit = 15,
    String type = 'album',
  }) async {
    // ambil trending playlists dan filter type = album.
    final uri = Uri.parse(
      '$_host/v1/playlists/trending?app_name=$_appName&limit=$limit&type=$type',
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Gagal fetch popular albums: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data
        .map((json) => AlbumModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<GenreModel>> fetchPopularGenre({int limit = 10}) async {
    final uri = Uri.parse('$_host/v1/genres/popular?limit=$limit');

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Gagal fetch trending tracks: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data
        .map((json) => GenreModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
