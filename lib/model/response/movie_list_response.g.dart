// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListResponse _$MovieListResponseFromJson(Map<String, dynamic> json) {
  return MovieListResponse(
    json['page'] as int,
    json['total_results'] as int,
    json['total_pages'] as int,
    (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : MovieResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
