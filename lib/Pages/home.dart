import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Models/daily_set.dart';
import 'package:my_time/Pages/Widgets/daily_pie_chart.dart';
import 'package:my_time/custom_icons/custom_icons_icons.dart';

class MyTimeHomePage extends StatefulWidget {
  MyTimeHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyTimeHomePageState createState() => _MyTimeHomePageState();
}

class _MyTimeHomePageState extends State<MyTimeHomePage> {
  List<DailyPieChart> _days = [];

  IconData _homeView = Icons.donut_large;

  /// Identifiers for a maximum of three days contained on the array
  ///
  static const _list = Key('days');
  var _yesterday;
  var _today;
  var _tomorrow;
  var currentIndex;

  var update = false;

  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _today = DateTime.now();
    _yesterday = _today.add(Duration(days: -1));
    _tomorrow = _today.add(Duration(days: 1));
    _pageController = PageController(initialPage: 0);

    currentIndex = 0;
    setState(() {});
  }

  PageView _pageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      key: _list,
      children: _days,
      controller: _pageController,
      onPageChanged: (i) {
        _calculatedayslist(i);
      },
    );
  }

  Widget _dayActivity() {
    return Container(
      height: 400.0,
      child: Align(
        alignment: Alignment.center,
        heightFactor: 400.0,
        child: _pageView(),
      ),
    );
  }

  Widget _activitiesList(DailySet x, _appbarcolors) {
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
                dynamic hour = x.tasks[index].timeForTask.hour;
                dynamic minute = x.tasks[index].timeForTask.minute;
                hour = hour < 10 ? '0$hour' : '$hour';
                minute = minute < 10 ? '0$minute' : '$minute';
                return ListTile(
                  ///TODO implement activity list widget for homepage
                  title: Text('${x.tasks[index].name}'),
                  trailing: Container(
                    width: 150.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Text('${x.tasks[index].startDateTime.format(context)}'),
                          Text('${x.tasks[index].dueDateTime?.format(context)}'),
                        ],),
                        SizedBox(
                          width: 15.0,
                        ),
                        /* Text('$hour:$minute'),
                        SizedBox(
                          width: 25.0,
                        ), */
                        CircleColor(
                          circleSize: 20.0,
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
  }

  _initialize() async {
    //get from DB
    //load on memory so it's not neccesary to read from db each time
    //widget is built
    var _gData = StateContainer.of(context);
    DailySetList sets = await _gData.loadData(context);
    DailySet _todaySet = _gData.getTodaySet();
    DailySet _yesterdaySet = _gData.getYesterdaySet();
    DailySet _tomorrowSet = _gData.getTomorrowSet();

    //if yesteday doesnt had any activity dont show it
    if (_yesterdaySet.tasks.length != 0) {
      _pageController = PageController(initialPage: 1);
      currentIndex = 1;
      _days.add(
        DailyPieChart(
          taskController: StateContainer.of(context)
              .dsStreamController(_yesterdaySet)
              .stream,
          initData: _yesterdaySet,
        ),
      );
    }

    _days.add(
      DailyPieChart(
        taskController:
            StateContainer.of(context).dsStreamController(_todaySet).stream,
        initData: _todaySet,
      ),
    );
    _days.add(
      DailyPieChart(
        taskController:
            StateContainer.of(context).dsStreamController(_tomorrowSet).stream,
        initData: _tomorrowSet,
      ),
    );
    setState(() {});
    return _todaySet;
  }

  _buildDrawerItems() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.view_list),
          title: Text('Pending tasks'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/settings');
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('History'),
        ),
        ListTile(
          leading: Icon(Icons.backup),
          title: Text('Back up tasks'),
        ),
        Divider(),
        ListTile(
          leading: IconShadowWidget(
            Icon(
              CustomIcons.heart,
              color: Colors.pinkAccent,
            ),
          ),
          title: Text('Support'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/settings');
          },
        ),
        ListTile(
          leading: Icon(Icons.star_border),
          title: Text('Rate'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _gData = StateContainer.of(context);
    DailySet _ds = _gData.getTodaySet();
    var _appbarcolors = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness:
            _gData.getSettings().isDark ? Brightness.dark : Brightness.light,
        backgroundColor: _gData.getSettings().isDark
            ? Theme.of(context).primaryColor
            : Colors.white,
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
        child: _buildDrawerItems(),
      ),
      body: SafeArea(
        child: StateContainer.of(context).isLoaded()
            ? FutureBuilder(
                future: _initialize(),
                builder: (context, snapshot) {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text(
                        'Something went wrong :(',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54,
                        ),
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
                      print(x.tasks);
                      return ListView(
                        children: <Widget>[
                          _dayActivity(),
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
                          _activitiesList(x, _appbarcolors),
                        ],
                      );
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return Container();
                  }
                },
              )
            : ListView(
                children: <Widget>[
                  _dayActivity(),
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
                  _activitiesList(_ds, _appbarcolors),
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
        backgroundColor: _gData.getSettings().isDark
            ? Theme.of(context).primaryColor
            : Colors.white,
        splashColor: Colors.white,
      ),
    );
  }

  _newActivity() async {
    await Navigator.of(context).pushNamed('/new_activity');
  }

  _calculatedayslist(int i) async {
    var _gData = StateContainer.of(context);
    _gData.setTodaySet(
        i < currentIndex ? _gData.getYesterdaySet() : _gData.getTomorrowSet());
    _today = i < currentIndex ? _yesterday : _tomorrow;
    currentIndex = i == 0 ? 1 : i;
    _yesterday = _today.add(Duration(days: -1));
    _tomorrow = _today.add(Duration(days: 1));
    var _ys = await _gData.loadSet(_yesterday, context);
    var _ts = await _gData.loadSet(_tomorrow, context);
    _gData.setYesterdaySet(_ys);
    _gData.setTomorrowSet(_ts);
    setState(() {
      if (i == _days.length - 1) {
        Widget w = DailyPieChart(
          taskController:
              _gData.dsStreamController(_gData.getTomorrowSet()).stream,
          initData: _gData.getTomorrowSet(),
        );
        _days.add(w);
      }
      if (i + 2 == _days.length - 1) {
        _days.removeLast();
      }
    });
  }
}
