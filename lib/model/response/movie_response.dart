import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class MovieResponse {
  final int id;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'video')
  final bool hasVideo;
  @JsonKey(name: 'vote_average')
  final double averageVote;
  final String title;
  final double popularity;
  @JsonKey(name: 'poster_path')
  final String posterUrl;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  @JsonKey(name: 'genres_ids')
  final List<int> genreIds;
  @JsonKey(name: 'backdrop_path')
  final String backdropUrl;
  @JsonKey(name: 'adult')
  final bool isAdult;
  final String overview;
  @JsonKey(name: 'release_date')
  final String releaseDate;

  MovieResponse(
    this.id,
    this.voteCount,
    this.hasVideo,
    this.averageVote,
    this.title,
    this.popularity,
    this.posterUrl,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropUrl,
    this.isAdult,
    this.overview,
    this.releaseDate,
  );

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}
