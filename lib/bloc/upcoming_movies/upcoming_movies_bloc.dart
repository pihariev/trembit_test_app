import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trembit_test_app/bloc/upcoming_movies/upcoming_movies_event.dart';
import 'package:trembit_test_app/data/repository/movie_repository.dart';
import 'package:trembit_test_app/model/result.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

typedef OnMoviesFetchedCallback = Function(List<Movie>);

class UpcomingMoviesBloc extends Bloc<UpcomingMoviesEvent, dynamic> {
  final OnMoviesFetchedCallback onMoviesFetchedCallback;
  final _movies = BehaviorSubject<Result<List<Movie>>>();
  final _navigateToMovieDetails = PublishSubject<Movie>();
  final _navigateToSettings = PublishSubject();

  UpcomingMoviesBloc({@required this.onMoviesFetchedCallback}) {
    _fetchUpcomingMovies();
  }

  Observable<Result<List<Movie>>> get movies => _movies;

  Observable<Movie> get navigateToMovieDetails => _navigateToMovieDetails;

  Observable get navigateToSettings => _navigateToSettings;

  @override
  get initialState => null;

  @override
  Stream mapEventToState(UpcomingMoviesEvent event) async* {
    if (event is OnMovieItemClickEvent) {
      _mapOnMovieItemClickEvent(event);
    } else if (event is OnSettingsButtonClickEvent) {
      _mapOnSettingsButtonClickEvent();
    } else if (event is OnRefreshMoviesListEvent) {
      _mapOnRefreshMoviesListEvent();
    }
  }

  @override
  void dispose() {
    _movies.close();
    _navigateToMovieDetails.close();
    _navigateToSettings.close();
    super.dispose();
  }

  void _fetchUpcomingMovies() async {
    final result = await movieRepository.getUpcomingMovies();
    _movies.add(result);
    onMoviesFetchedCallback(result.data);
  }

  void _mapOnMovieItemClickEvent(OnMovieItemClickEvent event) {
    _navigateToMovieDetails.add(event.movie);
  }

  void _mapOnSettingsButtonClickEvent() {
    _navigateToSettings.add(true);
  }

  void _mapOnRefreshMoviesListEvent() {
    _fetchUpcomingMovies();
  }
}
