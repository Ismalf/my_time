import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:my_time/Data/Models/Time.dart';

class ActivityWidget extends StatefulWidget {
  @override
  _ActivityWidget createState() => _ActivityWidget();
}

class _ActivityWidget extends State<ActivityWidget> {
  var today;

  var selected;

  var _date;

  var _hasPlan = false;

  var _taskColor;

  var _hasAlarm = false;

  var _priority = 'Low';

  var _category = 'Misc';

  var _name = '';

  var _expanded = false;

  var _trailWidth = 150.0;

  Time _alarm;

  Time _timeForTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _alarm = Time();
    _timeForTask = Time();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExpansionTile(
      leading: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
      title: Text(_name),
      initiallyExpanded: false,
      onExpansionChanged: (changed) {
        setState(() {
          _expanded = changed;
          _trailWidth = _expanded ? 0.0 : 150.0;
        });
      },
      trailing: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: _trailWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_timeForTask.toString()),
            SizedBox(
              width: 25.0,
            ),
            CircleColor(
                color: _taskColor != null ? _taskColor : Colors.grey,
                circleSize: 30.0),
          ],
        ),
      ),
      children: <Widget>[
        ///TASK NAME
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text('Task name'),
                ),
                Container(
                  width: 150.0,
                  height: 30.0,
                  child: TextFormField(
                    initialValue: _name,
                    onChanged: (o) => setState(() => _name = o),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Task Name',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///TIME FOR THE TASK
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text('Time assigned for the task'),
                ),
                Container(
                  width: 50.0,
                  height: 30.0,
                  child: TextFormField(
                    initialValue: _timeForTask.hours.toString(),
                    onChanged: (o) =>
                        setState(() => _timeForTask.hours = int.parse(o)),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Hours',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Text(':'),
                ),
                Container(
                  width: 50.0,
                  height: 30.0,
                  child: TextFormField(
                    initialValue: _timeForTask.minutes.toString(),
                    onChanged: (o) =>
                        setState(() => _timeForTask.minutes = int.parse(o)),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Mins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///COLOR PICKER
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Color'),
                CircleColor(
                  color: _taskColor != null ? _taskColor : Colors.grey,
                  circleSize: 40.0,
                  elevation: 5.0,
                  onColorChoose: () => selectColor(context),
                )
              ],
            ),
          ),
        ),

        ///ALARM SETUP
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Checkbox(
                        value: _hasAlarm,
                        onChanged: (active) =>
                            setState(() => _hasAlarm = active)),
                    Text('Alarm'),
                    Icon(Icons.alarm)
                  ],
                ),
                _hasAlarm
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.0,
                            height: 30.0,
                            child: TextFormField(
                              onChanged: (o) => print(o),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Hours',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(':'),
                          ),
                          Container(
                            width: 50.0,
                            height: 30.0,
                            child: TextFormField(
                              onChanged: (o) => print(o),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Mins',
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),

        ///PRIORITY
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Priority'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _priority,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _priority = newValue;
                        });
                      },
                      items: <String>['High', 'Mid', 'Low']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        ///CATEGORY
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Category'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _category,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      },

                      ///TODO load from data base
                      items: <String>['Misc', 'Sport', 'Academic']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        ///PLAN AHEAD
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Checkbox(
                        value: _hasPlan,
                        onChanged: (active) =>
                            setState(() => _hasPlan = active)),
                    Text('Plan Ahead'),
                    Icon(Icons.schedule),
                  ],
                ),
                _hasPlan
                    ? Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text('Start date of the task'),
                              IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () => selectDate(context))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text('End date of the task'),
                              IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () => selectDate(context))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    'Max amount of time available (Daily)'),
                              ),
                              Container(
                                width: 150.0,
                                child: TextFormField(
                                  onChanged: (o) => print(o),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void selectColor(BuildContext context) async {
    var _tempMainColor;
    final Color picked = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Color'),
          contentPadding: const EdgeInsets.all(6.0),
          content: MaterialColorPicker(
            onColorChange: (Color color) {
              _tempMainColor = color;
            },
            onMainColorChange: (Color color) {
              _tempMainColor = color;
            },
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _taskColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }
}
