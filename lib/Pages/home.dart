import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time/Pages/Widgets/daily_pie_chart.dart';

class MyTimeHomePage extends StatefulWidget {
  MyTimeHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyTimeHomePageState createState() => _MyTimeHomePageState();
}

class _MyTimeHomePageState extends State<MyTimeHomePage> {
  List<Widget> _days = [];

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: null),
          IconButton(icon: Icon(Icons.payment), onPressed: null),
        ],
        title: Row(
          children: <Widget>[
            Text(
              'My',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
                  color: Colors.black38,
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
            SizedBox(
              height: 25.0,
            ),
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
            GestureDetector(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Activity $index for today'),
                    trailing: Container(
                      width: 150.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('9h'),
                          SizedBox(
                            width: 25.0,
                          ),
                          Container(
                            height: 15.0,
                            width: 15.0,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
              ),
              onTap: () => Navigator.of(context).pushNamed('/activity_detail'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _newActivity,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        splashColor: Colors.white,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _newActivity() {}

  _calculatedayslist(int i) {
    print(i);
    setState(() {
      _today = i < currentIndex ? _yesterday : _tomorrow;
      currentIndex = i == 0 ? 1 : i;
      _yesterday = _today.add(Duration(days: -1));
      _tomorrow = _today.add(Duration(days: 1));

      var t, tom, y;
      t = _today;
      tom = _tomorrow;
      y = _yesterday;
      if (i == _days.length - 1) {
        Widget w = Container(
          width: 400.0,
          height: 400.0,
          child: DailyPieChart(
            dayRepresentation: tom,
          ),
        );
        _days.add(w);
      } else if (i == 0) {
        /* Widget w = Container(
          width: 400.0,
          height: 400.0,
          child: DailyPieChart(
            dayRepresentation: y,
          ),
        );
        _days = [w]..addAll(_days);
        print(_days); */

      }
    });
  }
}
