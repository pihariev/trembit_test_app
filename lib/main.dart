import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trembit_test_app/bloc/app/app_event.dart';
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

void main() async {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  notificationManager = NotificationManager(localNotificationsPlugin);
  final appLaunchDetails =
      await localNotificationsPlugin.getNotificationAppLaunchDetails();
  final myApp = appLaunchDetails.didNotificationLaunchApp
      ? MyApp(
          movieDetailsBundle: MovieDetailsBundle.withMovieId(
              int.parse(appLaunchDetails.payload)),
        )
      : MyApp();

  runApp(
    BlocProvider(
      builder: (context) => AppBloc(),
      child: myApp,
    ),
  );
}

class MyApp extends StatefulWidget {
  final MovieDetailsBundle movieDetailsBundle;

  MyApp({this.movieDetailsBundle});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _subscriptions = List<StreamSubscription>();
  String _initialRoute = AppRoute.Route.ROOT;
  bool _notificationRoutingResolved = false;

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
    _subscriptions.add(
      bloc.onNotificationsToggled
          .listen((_) => notificationManager.onNotificationsToggled()),
    );

    if (widget.movieDetailsBundle != null) {
      _initialRoute = AppRoute.Route.MOVIE_DETAILS_PAGE;
    }
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Trembit Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _initialRoute,
      onGenerateRoute: (settings) => _onGenerateRoute(context, settings),
    );
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    switch (settings.name) {
      case AppRoute.Route.ROOT:
      case AppRoute.Route.UPCOMING_MOVIES_PAGE:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return BlocProvider(
                builder: (context) => UpcomingMoviesBloc(
                  onMoviesFetchedCallback: (movies) {
                    appBloc.dispatch(OnMoviesFetchedEvent(movies));
                  },
                ),
                child: UpcomingMoviesPage(),
              );
            },
          );
        }
      case AppRoute.Route.MOVIE_DETAILS_PAGE:
        {
          MovieDetailsBundle bundle;
          if (widget.movieDetailsBundle != null &&
              !_notificationRoutingResolved) {
            bundle = widget.movieDetailsBundle;
            _notificationRoutingResolved = true;
          } else {
            bundle = settings.arguments as MovieDetailsBundle;
          }
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
                child: SettingsPage(
                  onNotificationsToggledCallback: () {
                    appBloc.dispatch(OnNotificationsToggledEvent());
                  },
                  onNotificationsTimespanChangedCallback: () {
                    appBloc.dispatch(OnNotificationTimespanChangedEvent());
                  },
                ),
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
    await _navigatorKey.currentState.pushNamed(
        AppRoute.Route.MOVIE_DETAILS_PAGE,
        arguments: MovieDetailsBundle.withMovieId(int.parse(payload)));
  }
}
