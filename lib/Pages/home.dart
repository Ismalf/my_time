import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
import 'package:my_time/Data/Models/daily_set.dart';
import 'package:my_time/Pages/Widgets/daily_pie_chart.dart';

class MyTimeHomePage extends StatefulWidget {
  MyTimeHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyTimeHomePageState createState() => _MyTimeHomePageState();
}

class _MyTimeHomePageState extends State<MyTimeHomePage> {
  List<Widget> _days = [];

  IconData _homeView = Icons.donut_large;

  /// Identifiers for a maximum of three days contained on the array
  ///
  static const _list = Key('days');
  var _yesterday;
  var _today;
  var _tomorrow;
  var currentIndex;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 1);
    currentIndex = 1;
    _today = DateTime.now();
    _yesterday = _today.add(Duration(days: -1));
    _tomorrow = _today.add(Duration(days: 1));
    var t, tom, y;
    t = _today;
    tom = _tomorrow;
    y = _yesterday;
    _days.add(
      Container(
        width: 400.0,
        height: 400.0,
        child: DailyPieChart(
          dayRepresentation: y,
        ),
      ),
    );
    _days.add(
      Container(
        width: 400.0,
        height: 400.0,
        child: DailyPieChart(
          dayRepresentation: t,
        ),
      ),
    );
    _days.add(
      Container(
        width: 400.0,
        height: 400.0,
        child: DailyPieChart(
          dayRepresentation: tom,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark)); */

    var _appbarcolors = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: _appbarcolors,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(_homeView),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('Daily View'),
                    Icon(Icons.donut_large),
                  ],
                ),
                value: 'd',
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('Weekly View'),
                    Icon(Icons.equalizer),
                  ],
                ),
                value: 'w',
              ),
            ],
            onSelected: (e) => setState(() =>
                _homeView = e == 'w' ? Icons.equalizer : Icons.donut_large),
          ),
          IconButton(icon: Icon(Icons.help_outline), onPressed: null),
        ],
        title: Row(
          children: <Widget>[
            Text(
              'My',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _appbarcolors,
                fontSize: 25.0,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Time',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _appbarcolors,
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[DrawerHeader(child: Text('title'))],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 400.0,
              child: Align(
                alignment: Alignment.center,
                heightFactor: 400.0,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  key: _list,
                  children: _days,
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() {
                      _calculatedayslist(i);
                    });
                  },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Hero(
                  tag: 'ActivitiesTag',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Activities',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            FutureBuilder(
              future: DailySetDao().getDaySet(_today),
              builder: (context, snapshot) {
                if (snapshot.error != null) {
                  return Center(
                    child: Text(
                      'Something went wrong :(',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54),
                    ),
                  );
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    DailySet x = snapshot.data;
                    StateContainer.of(context).setTodaySet(x);
                    print(x.tasks);
                    return GestureDetector(
                      child: x.tasks.length == 0
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('Tap the + button to add a task',
                                    style: TextStyle(color: _appbarcolors)),
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  ///TODO implement activity list widget for homepage
                                  title: Text('${x.tasks[index].name}'),
                                  trailing: Container(
                                    width: 150.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                            '${x.tasks[index].timeForTask.format(context)}'),
                                        SizedBox(
                                          width: 25.0,
                                        ),
                                        CircleColor(
                                          circleSize: 10.0,
                                          color: x.tasks[index].taskColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: x.tasks.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                      onTap: () => x.tasks.length == 0
                          ? _newActivity()
                          : Navigator.of(context).pushNamed('/activity_detail'),
                    );
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newActivity,
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: _appbarcolors,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Colors.white,
      ),
    );
  }

  _newActivity() {
    ///TODO implement new activity page: home page

    Navigator.of(context).pushNamed('/new_activity');
  }

  _calculatedayslist(int i) {
    print(i);
    setState(() {
      _today = i < currentIndex ? _yesterday : _tomorrow;
      currentIndex = i == 0 ? 1 : i;
      _yesterday = _today.add(Duration(days: -1));
      _tomorrow = _today.add(Duration(days: 1));

      var tom = _tomorrow;
      if (i == _days.length - 1) {
        Widget w = Container(
          width: 400.0,
          height: 400.0,
          child: DailyPieChart(
            dayRepresentation: tom,
          ),
        );
        _days.add(w);
      }
      if (i + 2 == _days.length - 1) {
        _days.removeLast();
      }
    });
    print(_days.length);
  }
}
