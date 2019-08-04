import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trembit_test_app/bloc/upcoming_movies/upcoming_movies_bloc.dart';
import 'package:trembit_test_app/bloc/upcoming_movies/upcoming_movies_event.dart';
import 'package:trembit_test_app/data/network/network_client.dart';
import 'package:trembit_test_app/model/navigation_bundle/movie_details_bundle.dart';
import 'package:trembit_test_app/model/result.dart';
import 'package:trembit_test_app/model/ui/movie.dart';
import 'package:trembit_test_app/route.dart' as AppRoute;

class UpcomingMoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpcomingMoviesPageState();
  }
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  final _subscriptions = List<StreamSubscription>();

  @override
  void initState() {
    super.initState();

    final bloc = BlocProvider.of<UpcomingMoviesBloc>(context);
    _subscriptions.add(bloc.navigateToMovieDetails.listen(
      (movie) {
        Navigator.of(context).pushNamed(AppRoute.Route.MOVIE_DETAILS_PAGE,
            arguments: MovieDetailsBundle.withMovie(movie));
      },
    ));
    _subscriptions.add(bloc.navigateToSettings.listen(
      (_) {
        Navigator.of(context).pushNamed(AppRoute.Route.SETTINGS_PAGE);
      },
    ));
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UpcomingMoviesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Trembit Test App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              bloc.dispatch(OnSettingsButtonClickEvent());
            },
          )
        ],
      ),
      body: _body(bloc),
    );
  }

  Widget _body(UpcomingMoviesBloc bloc) {
    return StreamBuilder<Result<List<Movie>>>(
      stream: bloc.movies,
      builder: (context, snapshot) {
        if (snapshot != null && snapshot.data != null) {
          final result = snapshot.data;
          if (result.state == ResultState.ERROR) {
            return Center(
              child: Text('Something went wrong...'),
            );
          } else {
            return ListView.builder(
              itemCount: result.data.length,
              itemBuilder: (context, index) => _buildItem(bloc, result.data[index]),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildItem(UpcomingMoviesBloc bloc, Movie movie) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text(movie.releaseDate.toUtc().toIso8601String()),
      leading: Image.network(
        NetworkClient.buildImageUrl(movie.imageUrl),
      ),
      onTap: () {
        bloc.dispatch(OnMovieItemClickEvent(movie));
      },
    );
  }
}
