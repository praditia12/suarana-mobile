class TrackModel {
  final String id;
  final String title;
  final String artistName;
  final String? artworkUrl;
  final int? duration; // detik
  final int? playCount;
  final String? genre;

  const TrackModel({
    required this.id,
    required this.title,
    required this.artistName,
    this.artworkUrl,
    this.duration,
    this.playCount,
    this.genre,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    // Audius mengembalikan artwork sebagai object: { "150x150": "...", "480x480": "..." }
    final artwork = json['artwork'] as Map<String, dynamic>?;

    // Audius menaruh info artist di dalam key 'user'
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return TrackModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: user['name'] as String? ?? 'Unknown Artist',
      artworkUrl: artwork?['480x480'] as String?,
      duration: json['duration'] as int?,
      playCount: json['play_count'] as int?,
      genre: json['genre'] as String?,
    );
  }

  TrackModel copyWith({
    String? id,
    String? title,
    String? artistName,
    String? artworkUrl,
    int? duration,
    int? playCount,
    String? genre,
  }) {
    return TrackModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      duration: duration ?? this.duration,
      playCount: playCount ?? this.playCount,
      genre: genre ?? this.genre,
    );
  }

  // Untuk ditampilkan di UI: "3:45"
  String get formattedDuration {
    if (duration == null) return '--:--';
    final m = duration! ~/ 60;
    final s = duration! % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // getter untuk mendapatkan URL stream dari Audius
  String get streamUrl => 'https://api.audius.co/v1/tracks/$id/stream?app_name=suarana';
}