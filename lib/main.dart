import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trembit_test_app/bloc/movie_details/movie_details_bloc.dart';
import 'package:trembit_test_app/bloc/settings/settings_bloc.dart';
import 'package:trembit_test_app/bloc/upcoming_movies/upcoming_movies_bloc.dart';
import 'package:trembit_test_app/model/navigation_bundle/movie_details_bundle.dart';
import 'package:trembit_test_app/page/movie_details_page.dart';
import 'package:trembit_test_app/page/settings_page.dart';
import 'package:trembit_test_app/page/upcoming_movies_page.dart';
import 'package:trembit_test_app/route.dart' as AppRoute;
import 'package:trembit_test_app/utils/notification_manager.dart';

import 'bloc/app/app_bloc.dart';

NotificationManager notificationManager;

void main() {
  notificationManager = NotificationManager(FlutterLocalNotificationsPlugin());
  runApp(
    BlocProvider(
      builder: (context) => AppBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _subscriptions = List<StreamSubscription>();

  @override
  void initState() {
    super.initState();

    notificationManager.initWith(_onSelectNotification);
    final bloc = BlocProvider.of<AppBloc>(context);
    _subscriptions.add(
      bloc.onMoviesFetched
          .listen((movies) => notificationManager.onDidMoviesFetched(movies)),
    );
    _subscriptions.add(
      bloc.onTimespanChanged
          .listen((_) => notificationManager.onTimespanChanged()),
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

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
      case AppRoute.Route.SETTINGS_PAGE:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider<SettingsBloc>(
                builder: (context) => SettingsBloc(),
                child: SettingsPage(),
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

  Future<void> _onSelectNotification(String payload) async {
    await Navigator.of(context).pushNamed(AppRoute.Route.MOVIE_DETAILS_PAGE,
        arguments: MovieDetailsBundle.withMovieId(int.parse(payload)));
  }
}
