import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trembit_test_app/bloc/movie_details/movie_details_bloc.dart';
import 'package:trembit_test_app/bloc/upcoming_movies/upcoming_movies_bloc.dart';
import 'package:trembit_test_app/model/navigation_bundle/movie_details_bundle.dart';
import 'package:trembit_test_app/page/movie_details_page.dart';
import 'package:trembit_test_app/page/upcoming_movies_page.dart';
import 'package:trembit_test_app/route.dart' as AppRoute;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trembit Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoute.Route.ROOT,
      onGenerateRoute: (settings) => _onGenerateRoute(settings),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.Route.ROOT:
      case AppRoute.Route.UPCOMING_MOVIES_PAGE:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider(
                builder: (context) => UpcomingMoviesBloc(),
                child: UpcomingMoviesPage(),
              );
            },
          );
        }
      case AppRoute.Route.MOVIE_DETAILS_PAGE:
        {
          final bundle = settings.arguments as MovieDetailsBundle;
          final withMovie = bundle.movie != null;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider<MovieDetailsBloc>(
                builder: (context) => withMovie
                    ? MovieDetailsBloc.withMovie(bundle.movie)
                    : MovieDetailsBloc.withMovieId(bundle.movieId),
                child: MovieDetailsPage(),
              );
            },
          );
        }
      default:
        {
          return null;
        }
    }
  }
}
