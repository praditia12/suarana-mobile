import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/models/track_model.dart';

class AlbumService {
  static const _host = 'https://api.audius.co';
  static const _appName = 'suarana';
  static const _timeout = Duration(seconds: 10);

  Future<List<TrackModel>> fetchAlbumTracks(String albumId) async {
    final uri = Uri.parse(
      '$_host/v1/playlists/$albumId/tracks?app_name=$_appName',
    );

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Gagal fetch album tracks: ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;

      return data
          .map((json) => TrackModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception('no_internet');
    }
  }
}