import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trembit_test_app/data/repository/settings_repository.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';
import 'package:trembit_test_app/model/ui/movie.dart';

class NotificationManager {
  static const _oneDayInMillis = Duration.millisecondsPerDay;
  static const _threeDaysInMillis = _oneDayInMillis * 3;
  static const _weekInMillis = _oneDayInMillis * 7;

  FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  List<Movie> _lastFetchedMovies;

  NotificationManager(this._localNotificationsPlugin);

  void initWith(SelectNotificationCallback onSelectNotification) {
    this._localNotificationsPlugin = _localNotificationsPlugin;
    final androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    final iosInitializationSettings = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    _localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void onDidMoviesFetched(List<Movie> movies) async {
    _lastFetchedMovies = movies;
    await _cancelAllNotifications();
    final currentTimespan = await settingsRepository.getNotificationTimespan();
    for (Movie m in _lastFetchedMovies) {
      await _scheduleNotification(m, currentTimespan);
    }
  }

  void onTimespanChanged() {
    if (_lastFetchedMovies != null && _lastFetchedMovies.isNotEmpty) {
      onDidMoviesFetched(_lastFetchedMovies);
    }
  }

  Future<void> _scheduleNotification(
      Movie movie, NotificationTimespan timespan) async {
    if (_shouldShowNotification(movie.releaseDate)) {
      final androidNotificationDetails = AndroidNotificationDetails(
          '0', 'trembit test app channel', 'trembit test app description');
      final iosNotificationDetails = IOSNotificationDetails();
      final notificationDetails = NotificationDetails(
          androidNotificationDetails, iosNotificationDetails);
      final scheduledDate =
          _resolveNotificationDate(movie.releaseDate, timespan);
      await _localNotificationsPlugin.schedule(
        movie.id,
        movie.title,
        movie.releaseDate.toUtc().toIso8601String(),
        scheduledDate,
        notificationDetails,
        payload: movie.id.toString(),
      );
    }
  }

  Future<void> _cancelAllNotifications() async {
    final pendingNotifications =
        await _localNotificationsPlugin.pendingNotificationRequests();
    pendingNotifications.forEach((n) {
      _localNotificationsPlugin.cancel(n.id);
    });
  }

  bool _shouldShowNotification(DateTime releaseDate) {
    final now = DateTime.now();
    return now.isBefore(releaseDate);
  }

  DateTime _resolveNotificationDate(
      DateTime releaseDate, NotificationTimespan timespan) {
    int timespanMillis;
    switch (timespan) {
      case NotificationTimespan.ONE_DAY:
        {
          timespanMillis = _oneDayInMillis;
          break;
        }
      case NotificationTimespan.THREE_DAYS:
        {
          timespanMillis = _threeDaysInMillis;
          break;
        }
      case NotificationTimespan.WEEK:
        {
          timespanMillis = _weekInMillis;
          break;
        }
    }

    final diff = releaseDate.millisecondsSinceEpoch - timespanMillis;
    final notifyDate = DateTime.fromMicrosecondsSinceEpoch(diff);
    final now = DateTime.now();
    if (now.isBefore(notifyDate)) {
      return notifyDate;
    } else {
      return now.add(Duration(minutes: 15));
    }
  }
}
