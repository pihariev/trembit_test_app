import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final DateTime releaseDate;

  Movie({
    this.id,
    this.title,
    this.overview,
    this.releaseDate,
  }) : super([
          id,
          title,
          overview,
          releaseDate,
        ]);
}
