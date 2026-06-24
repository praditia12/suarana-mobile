class GenreModel {
  final String name;
  final int count;

  const GenreModel({
    required this.name,
    required this.count,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {

    return GenreModel(
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }

  GenreModel copyWith({
    String? name,
    int? count,
  }) {
    return GenreModel(
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }
}
