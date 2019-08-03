import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

@immutable
abstract class UpcomingMoviesEvent extends Equatable {
  UpcomingMoviesEvent([List props = const []]) : super([props]);
}

@immutable
class OnMovieItemClickEvent extends UpcomingMoviesEvent {
  final Movie movie;

  OnMovieItemClickEvent(this.movie) : super([movie]);
}

@immutable
class OnSettingsButtonClickEvent extends UpcomingMoviesEvent {}

@immutable
class OnRefreshMoviesListEvent extends UpcomingMoviesEvent {}
