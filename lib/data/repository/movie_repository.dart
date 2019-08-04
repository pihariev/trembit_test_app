import 'package:trembit_test_app/data/mapper/mapper.dart';
import 'package:trembit_test_app/data/mapper/movie_mapper.dart';
import 'package:trembit_test_app/data/service/movie_service.dart';
import 'package:trembit_test_app/model/response/movie_response.dart';
import 'package:trembit_test_app/model/result.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

final IMovieRepository movieRepository =
    MovieRepository._(movieService, MovieMapper());

abstract class IMovieRepository {
  Future<Result<List<Movie>>> getUpcomingMovies();

  Future<Result<Movie>> getMovie(int movieId);
}

class MovieRepository extends IMovieRepository {
  final IMovieService _movieService;
  final Mapper<MovieResponse, Movie> _movieMapper;

  MovieRepository._(this._movieService, this._movieMapper);

  @override
  Future<Result<List<Movie>>> getUpcomingMovies() async {
    try {
      final response = await _movieService.getUpcomingMovies();
      final movies = response.items
          .map((movieResponse) => _movieMapper.map(movieResponse))
          .take(10)
          .toList();
      final result = Result.success(movies);
      return Future.value(result);
    } catch (e) {
      final result = Result<List<Movie>>.error(e.toString());
      return Future.value(result);
    }
  }

  @override
  Future<Result<Movie>> getMovie(int movieId) async {
    try {
      final response = await _movieService.getMovie(movieId);
      final movie = _movieMapper.map(response);
      final result = Result.success(movie);
      return Future.value(result);
    } catch (e) {
      final result = Result<Movie>.error(e.toString());
      return Future.value(result);
    }
  }
}
