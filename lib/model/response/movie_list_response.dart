import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trembit_test_app/model/response/list_response.dart';
import 'package:trembit_test_app/model/response/movie_response.dart';

part 'movie_list_response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class MovieListResponse extends ListResponse<MovieResponse> {
  final int page;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'results')
  final List<MovieResponse> items;

  MovieListResponse(this.page, this.totalResults, this.totalPages, this.items)
      : super(page, totalResults, totalPages, items);

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);
}
