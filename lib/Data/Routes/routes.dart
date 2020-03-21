import 'package:my_time/Pages/activity_detail.dart';
import 'package:my_time/Pages/home.dart';
import 'package:my_time/Pages/new_activity.dart';

var appRoutes = {
  '/': (context) => MyTimeHomePage(title: 'hey'),
  '/activity_detail': (context) => ActivityDetail(),
  '/new_activity': (context) => NewActivity()
};
