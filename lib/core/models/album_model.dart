// lib/core/models/album_model.dart

class AlbumModel {
  final String id;
  final String title;
  final String artistName;
  final String? artworkUrl;
  final int? trackCount;

  const AlbumModel({
    required this.id,
    required this.title,
    required this.artistName,
    this.artworkUrl,
    this.trackCount,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final artwork = json['artwork'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return AlbumModel(
      id: json['id'] as String,
      // Audius menyebut album sebagai "playlist" — nama ada di 'playlist_name'
      title: json['playlist_name'] as String,
      artistName: user['name'] as String? ?? 'Unknown Artist',
      artworkUrl: artwork?['480x480'] as String?,
      trackCount: json['track_count'] as int?,
    );
  }

  AlbumModel copyWith({
    String? id,
    String? title,
    String? artistName,
    String? artworkUrl,
    int? trackCount,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      trackCount: trackCount ?? this.trackCount,
    );
  }
}