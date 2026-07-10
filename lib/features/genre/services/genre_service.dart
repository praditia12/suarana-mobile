import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/models/track_model.dart';

class GenreService {
  static const _host = 'https://api.audius.co';
  static const _appName = 'suarana';
  static const _timeout = Duration(seconds: 10);

  Future<List<TrackModel>> fetchTracksByGenre(String genre) async {
    final encodedGenre = Uri.encodeComponent(genre);
    final uri = Uri.parse(
      '$_host/v1/tracks/trending?app_name=$_appName&genre=$encodedGenre&limit=20',
    );

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Gagal fetch genre tracks: ${response.statusCode}');
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