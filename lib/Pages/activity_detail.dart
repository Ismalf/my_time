import 'package:flutter/material.dart';


import 'Widgets/activityWidget.dart';

class ActivityDetail extends StatefulWidget {
  @override
  _ActivityDetail createState() => _ActivityDetail();
}

class _ActivityDetail extends State<ActivityDetail> {
  String dropdownValue = 'High';
  DateTime today = DateTime.now();
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
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
              'Activities',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black38,
                fontSize: 25.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: 'ActivitiesTag',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Activities for today',
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
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return ActivityWidget();
            },
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newActivity,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        splashColor: Colors.white,
      ),
    );
  }

  _newActivity() {
    ///TODO implement new activity page
  }
}
