import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:trembit_test_app/bloc/app/app_event.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class AppBloc extends Bloc<AppEvent, dynamic> {
  final _onMoviesFetched = PublishSubject<List<Movie>>(sync: true);
  final _onTimespanChanged = PublishSubject(sync: true);
  final _onNotificationsToggled = PublishSubject(sync: true);

  @override
  get initialState => null;

  Observable<List<Movie>> get onMoviesFetched => _onMoviesFetched;

  Observable get onTimespanChanged => _onTimespanChanged;

  Observable get onNotificationsToggled => _onNotificationsToggled;

  @override
  Stream mapEventToState(AppEvent event) async* {
    if (event is OnMoviesFetchedEvent) {
      _mapOnMoviesFetchedEvent(event);
    } else if (event is OnNotificationTimespanChangedEvent) {
      _mapOnTimespanChangedEvent();
    } else if (event is OnNotificationsToggledEvent) {
      _mapOnNotificationsToggledEvent();
    }
  }

  @override
  void dispose() {
    _onMoviesFetched.close();
    _onTimespanChanged.close();
    _onNotificationsToggled.close();
    super.dispose();
  }

  void _mapOnMoviesFetchedEvent(OnMoviesFetchedEvent event) {
    final movies = event.movies;
    _onMoviesFetched.add(movies);
  }

  void _mapOnTimespanChangedEvent() {
    _onTimespanChanged.add(dynamic);
  }

  void _mapOnNotificationsToggledEvent() {
    _onNotificationsToggled.add(dynamic);
  }
}
