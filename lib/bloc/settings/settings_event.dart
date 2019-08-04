import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const []]) : super([props]);
}

@immutable
class OnShowNotificationsToggleEvent extends SettingsEvent {
  final bool enabled;

  OnShowNotificationsToggleEvent(this.enabled) : super([enabled]);
}

@immutable
class OnNotificationsTimespanChangedEvent extends SettingsEvent {
  final NotificationTimespan timespan;

  OnNotificationsTimespanChangedEvent(this.timespan) : super([timespan]);
}
