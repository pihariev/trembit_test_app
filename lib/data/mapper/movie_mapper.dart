import 'package:trembit_test_app/data/mapper/mapper.dart';
import 'package:trembit_test_app/model/response/movie_response.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class MovieMapper extends Mapper<MovieResponse, Movie> {
  @override
  Movie map(MovieResponse from) {
    return Movie(
      id: from.id,
      title: from.title,
      overview: from.overview,
      releaseDate: DateTime.parse(from.releaseDate),
      imageUrl: from.posterUrl,
    );
  }
}
