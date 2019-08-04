import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

@immutable
abstract class AppEvent extends Equatable {
  AppEvent([List props = const []]) : super([props]);
}

@immutable
class OnMoviesFetchedEvent extends AppEvent {
  final List<Movie> movies;

  OnMoviesFetchedEvent(this.movies) : super([movies]);
}

@immutable
class OnNotificationTimespanChangedEvent extends AppEvent {}
