import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_time/BL/alarms.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Routes/routes.dart';
import 'package:my_time/Pages/activity_detail.dart';
import 'package:rxdart/subjects.dart';

import 'Data/Models/Notifications.dart';

final ReceivePort port = ReceivePort();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  /*WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StateContainer(
      child: _MyApp(),
    );
  }
}

class _MyApp extends StatefulWidget {
  @override
  _$MyApp createState() => _$MyApp();
}

class _$MyApp extends State<_MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*AndroidAlarmManager.initialize();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await _incrementCounter());*/

    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            FlatButton(
              //isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetail(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityDetail()),
      );
    });
  }

  _buildApp(_appBrightness) {
    return MaterialApp(
      title: 'MyTime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: 'Ubuntu',
          brightness: _appBrightness),
      initialRoute: '/',
      routes: appRoutes,
    );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _appBrightness = StateContainer.of(context).getSettings().isDark
        ? Brightness.dark
        : Brightness.light;
    // TODO: implement build
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) return null;
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            _appBrightness = snapshot.data;
            if (_appBrightness == Brightness.light)
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: Colors.white));
            return _buildApp(_appBrightness);
          case ConnectionState.done:
            _appBrightness = snapshot.data;
            return _buildApp(_appBrightness);
          case ConnectionState.waiting:
            return _buildApp(_appBrightness);
          case ConnectionState.none:
            return _buildApp(_appBrightness);
        }
      },
      stream: StateContainer.of(context).getThemeStream(),
    );
  }
}
