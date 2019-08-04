import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trembit_test_app/data/repository/movie_repository.dart';
import 'package:trembit_test_app/model/result.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class MovieDetailsBloc extends Bloc<dynamic, dynamic> {
  final Movie _movie;
  final int _movieId;

  final _movieSubject = BehaviorSubject<Result<Movie>>(sync: true);

  MovieDetailsBloc.withMovie(this._movie) : _movieId = null {
    _movieSubject.add(Result.success(_movie));
  }

  MovieDetailsBloc.withMovieId(this._movieId) : _movie = null {
    _fetchMovie(_movieId);
  }

  Observable<Result<Movie>> get movie => _movieSubject;

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  void _fetchMovie(int movieId) async {
    final result = await movieRepository.getMovie(movieId);
    _movieSubject.add(result);
  }
}
