import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time/Data/Routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Ubuntu'
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
