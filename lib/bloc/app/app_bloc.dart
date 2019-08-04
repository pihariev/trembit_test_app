import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:trembit_test_app/bloc/app/app_event.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class AppBloc extends Bloc<AppEvent, dynamic> {
  final _onMoviesFetched = PublishSubject<List<Movie>>(sync: true);
  final _onTimespanChanged = PublishSubject(sync: true);

  @override
  get initialState => null;

  Observable<List<Movie>> get onMoviesFetched => _onMoviesFetched;

  Observable get onTimespanChanged => _onTimespanChanged;

  @override
  Stream mapEventToState(AppEvent event) async* {
    if (event is OnMoviesFetchedEvent) {
      _mapOnMoviesFetchedEvent(event);
    } else if (event is OnNotificationTimespanChangedEvent) {
      _mapOnTimespanChangedEvent();
    }
  }

  @override
  void dispose() {
    _onMoviesFetched.close();
    _onTimespanChanged.close();
    super.dispose();
  }

  void _mapOnMoviesFetchedEvent(OnMoviesFetchedEvent event) {
    final movies = event.movies;
    _onMoviesFetched.add(movies);
  }

  void _mapOnTimespanChangedEvent() {
    _onTimespanChanged.add(dynamic);
  }
}
