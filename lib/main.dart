import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time/Data/Routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Ubuntu',
        brightness: Brightness.dark
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
