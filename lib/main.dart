import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Routes/routes.dart';

void main() => runApp(MyApp());

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
  _buildApp(_appBrightness) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  Widget build(BuildContext context) {
    var _appBrightness = StateContainer.of(context).getSettings().isDark()
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
