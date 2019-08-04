import 'package:shared_preferences/shared_preferences.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';

final ILocalStorage localStorage = LocalStorage._();

abstract class ILocalStorage {
  Future<NotificationTimespan> getNotificationTimespan();

  Future<bool> isNotificationsEnabled();

  Future setNotificationsEnabled(bool enabled);

  Future setNotificationTimespan(NotificationTimespan timespan);
}

class LocalStorage extends ILocalStorage {
  static const _notificationTimespanKey = 'notification_timespan_key';
  static const _notificationsEnabledKey = 'notifications_enabled_key';

  LocalStorage._();

  @override
  Future<NotificationTimespan> getNotificationTimespan() {
    return SharedPreferences.getInstance().then(
      (prefs) {
        final index = prefs.getInt(_notificationTimespanKey) ?? 0;
        return NotificationTimespan.values[index];
      },
    );
  }

  @override
  Future<bool> isNotificationsEnabled() {
    return SharedPreferences.getInstance().then(
      (prefs) {
        final isNotificationsEnabled =
            prefs.getBool(_notificationsEnabledKey) ?? false;
        return isNotificationsEnabled;
      },
    );
  }

  @override
  Future setNotificationTimespan(NotificationTimespan timespan) {
    assert(timespan != null);
    return SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt(_notificationTimespanKey, timespan.index),
    );
  }

  @override
  Future setNotificationsEnabled(bool enabled) {
    assert(enabled != null);
    return SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool(_notificationsEnabledKey, enabled),
    );
  }
}
