import 'package:my_time/Pages/activity_detail.dart';
import 'package:my_time/Pages/home.dart';

var appRoutes = {
  '/': (context) => MyTimeHomePage(title: 'hey'),
  '/activity_detail': (context) => ActivityDetail()
};
