import 'package:json_annotation/json_annotation.dart';

part 'movie_details_videos.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetailsVideos {
  MovieDetailsVideos({required this.results});

  final List<MovieDetailsVideosResult> results;

  factory MovieDetailsVideos.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsVideosFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsVideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetailsVideosResult {
  MovieDetailsVideosResult({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  factory MovieDetailsVideosResult.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsVideosResultFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsVideosResultToJson(this);
}
