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
                  children: <Widget>[
                    Container(
                      width: 400.0,
                      height: 400.0,
                      child: DailyPieChart(
                        dayRepresentation: DateTime.now(),
                      ),
                    ),
                    Container(
                      width: 400.0,
                      height: 400.0,
                      child: DailyPieChart(
                        dayRepresentation: DateTime.now(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(title: Text('item $index'));
              },
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
