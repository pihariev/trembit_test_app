// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) {
  return MovieResponse(
    json['id'] as int,
    json['vote_count'] as int,
    json['video'] as bool,
    (json['vote_average'] as num)?.toDouble(),
    json['title'] as String,
    (json['popularity'] as num)?.toDouble(),
    json['poster_path'] as String,
    json['original_language'] as String,
    json['original_title'] as String,
    (json['genres_ids'] as List)?.map((e) => e as int)?.toList(),
    json['backdrop_path'] as String,
    json['adult'] as bool,
    json['overview'] as String,
    json['release_date'] as String,
  );
}
