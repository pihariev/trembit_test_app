import 'package:flutter/foundation.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

@immutable
class MovieDetailsBundle {
  final Movie movie;
  final int movieId;

  MovieDetailsBundle.withMovie(this.movie) : movieId = null;

  MovieDetailsBundle.withMovieId(this.movieId) : movie = null;
}
