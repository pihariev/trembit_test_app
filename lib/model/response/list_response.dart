import 'package:flutter/foundation.dart';

@immutable
class ListResponse<T> {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<T> items;

  ListResponse(
    this.page,
    this.totalResults,
    this.totalPages,
    this.items,
  );
}
