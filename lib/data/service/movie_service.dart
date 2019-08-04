import 'package:trembit_test_app/data/network/network_client.dart';
import 'package:trembit_test_app/model/response/movie_list_response.dart';
import 'package:trembit_test_app/model/response/movie_response.dart';

final IMovieService movieService = MovieService._(networkClient);

abstract class IMovieService {
  Future<MovieListResponse> getUpcomingMovies();

  Future<MovieResponse> getMovie(int movieId);
}

class MovieService extends IMovieService {
  final NetworkClient _networkClient;

  MovieService._(this._networkClient);

  @override
  Future<MovieListResponse> getUpcomingMovies() async {
    final response = await _networkClient.dio.get('/movie/upcoming');
    return MovieListResponse.fromJson(response.data);
  }

  @override
  Future<MovieResponse> getMovie(int movieId) async {
    assert(movieId != null);
    final response = await _networkClient.dio.get('/movie/$movieId');
    return MovieResponse.fromJson(response.data);
  }
}
