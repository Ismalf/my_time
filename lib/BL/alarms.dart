import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// A port used to communicate from a background isolate to the UI isolate.

/// Global [SharedPreferences] object.
SharedPreferences prefs;

class AlarmManager {
  static final AlarmManager _instance = new AlarmManager._();

  static AlarmManager get instance => _instance;

  Completer<AlarmManager> _am;

  Future<AlarmManager> get am async {
    if (_am == null) {
      _am = Completer();
    }
    return _am.future;
  }

  AlarmManager._();

  // The background
  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');

    // Get the previous cached count and increment it.
    /*final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt(countKey);
    await prefs.setInt(countKey, currentCount + 1);*/

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  setReminder(DateTime at, String activityName) {
    AndroidAlarmManager.oneShotAt(
      at,
      activityName.hashCode,
      callback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  bool setDailyReminder(DateTime startAt, String activityName) {
    try {
      AndroidAlarmManager.periodic(
        Duration(days: 1),
        activityName.hashCode,
        callback,
        exact: true,
        wakeup: true,
        startAt: startAt,
        rescheduleOnReboot: true,
      );
    } catch (_) {
      return false;
    }
    return true;
  }
}
