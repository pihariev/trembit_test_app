import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trembit_test_app/bloc/settings/settings_event.dart';
import 'package:trembit_test_app/data/repository/settings_repository.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';

class SettingsBloc extends Bloc<SettingsEvent, dynamic> {
  final _initialNotificationsEnabled =
      BehaviorSubject<bool>.seeded(false, sync: true);
  final _initialNotificationsTimespan =
      BehaviorSubject<NotificationTimespan>.seeded(NotificationTimespan.ONE_DAY,
          sync: true);

  SettingsBloc() {
    _fetchSettings();
  }

  Observable<bool> get initialNotificationsEnabled =>
      _initialNotificationsEnabled;

  Observable<NotificationTimespan> get initialNotificationsTimespan =>
      _initialNotificationsTimespan;

  @override
  get initialState => null;

  @override
  Stream mapEventToState(SettingsEvent event) async* {
    if (event is OnShowNotificationsToggleEvent) {
      _mapOnShowNotificationsToggleEvent(event);
    } else if (event is OnNotificationsTimespanChangedEvent) {
      _mapOnNotificationsTimespanChangedEvent(event);
    }
  }

  @override
  void dispose() {
    _initialNotificationsEnabled.close();
    _initialNotificationsTimespan.close();
    super.dispose();
  }

  void _fetchSettings() async {
    final isNotificationsEnabled =
        await settingsRepository.isNotificationsEnabled();
    final notificationsTimespan =
        await settingsRepository.getNotificationTimespan();
    _initialNotificationsEnabled.add(isNotificationsEnabled);
    _initialNotificationsTimespan.add(notificationsTimespan);
  }

  void _mapOnShowNotificationsToggleEvent(
      OnShowNotificationsToggleEvent event) async {
    final notificationsEnabled = event.enabled;
    await settingsRepository.setNotificationsEnabled(notificationsEnabled);
    _initialNotificationsEnabled.add(notificationsEnabled);
  }

  void _mapOnNotificationsTimespanChangedEvent(
      OnNotificationsTimespanChangedEvent event) async {
    final timespan = event.timespan;
    await settingsRepository.setNotificationTimespan(timespan);
    _initialNotificationsTimespan.add(timespan);
  }
}
