import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trembit_test_app/bloc/settings/settings_bloc.dart';
import 'package:trembit_test_app/bloc/settings/settings_event.dart';
import 'package:trembit_test_app/model/notification_timespan.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<bool>(
            stream: bloc.initialNotificationsEnabled,
            builder: (context, snapshot) {
              if (snapshot != null && snapshot.data != null) {
                return SwitchListTile(
                  title: Text('Enable notifications'),
                  value: snapshot.data,
                  onChanged: (value) =>
                      bloc.dispatch(OnShowNotificationsToggleEvent(value)),
                );
              } else {
                return SwitchListTile(
                  value: false,
                  onChanged: null,
                );
              }
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Notifications timespan'),
              ),
              StreamBuilder<NotificationTimespan>(
                stream: bloc.initialNotificationsTimespan,
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.data != null) {
                    final timespan = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: DropdownButton(
                        items: [
                          DropdownMenuItem(
                            child: Text('One day'),
                            value: NotificationTimespan.ONE_DAY,
                          ),
                          DropdownMenuItem(
                            child: Text('Three days'),
                            value: NotificationTimespan.THREE_DAYS,
                          ),
                          DropdownMenuItem(
                            child: Text('One week'),
                            value: NotificationTimespan.WEEK,
                          ),
                        ],
                        onChanged: (value) => bloc.dispatch(
                            OnNotificationsTimespanChangedEvent(value)),
                        value: timespan,
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
