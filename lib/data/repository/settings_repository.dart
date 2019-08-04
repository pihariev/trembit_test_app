import 'package:trembit_test_app/data/storage/local_storage.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';

final ISettingsRepository settingsRepository =
    SettingsRepository._(localStorage);

abstract class ISettingsRepository {
  Future<NotificationTimespan> getNotificationTimespan();

  Future<bool> isNotificationsEnabled();

  Future setNotificationTimespan(NotificationTimespan timespan);

  Future setNotificationsEnabled(bool enabled);
}

class SettingsRepository extends ISettingsRepository {
  final ILocalStorage _localStorage;

  SettingsRepository._(this._localStorage);

  @override
  Future<NotificationTimespan> getNotificationTimespan() {
    return _localStorage.getNotificationTimespan();
  }

  @override
  Future<bool> isNotificationsEnabled() {
    return _localStorage.isNotificationsEnabled();
  }

  @override
  Future setNotificationTimespan(NotificationTimespan timespan) {
    return _localStorage.setNotificationTimespan(timespan);
  }

  @override
  Future setNotificationsEnabled(bool enabled) {
    return _localStorage.setNotificationsEnabled(enabled);
  }
}
