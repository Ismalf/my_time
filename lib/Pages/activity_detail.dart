import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    Color _appbarcolors = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: _appbarcolors,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        centerTitle: true,
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
              'Activities',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _appbarcolors,
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
    ///TODO implement new activity page
  }
}
