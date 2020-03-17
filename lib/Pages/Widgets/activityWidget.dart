import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_time/Data/Models/Time.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_picker/flutter_picker.dart';

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

  var _alarmOpacity = 0.0;

  var _startDatePhOpacity = 0.0;

  var _dueDatePhOpacity = 0.0;

  var _timeAvailablePhOpacity = 0.0;

  var _expanded = false;

  var _trailWidth = 150.0;

  DateTime _dueDate;

  TimeOfDay _dueDateTime;

  Color _defaultColor = Colors.lightBlue;

  Time _timeForTask;

  String _pickerData;

  DateTime _reminder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timeForTask = Time();
    //Build data at the construction of the widget
    _buildReminderModalPickerData();
  }

  _buildReminderModalPickerData() {
    var x = [];
    //Fill an array with value from 1 to 99
    for (var i = 1; i <= 99; i++) x.add(i);
    //Fill an array with following values
    var y = '["Minutes", "Hours", "Days"]';
    var z = [x, y];
    //this data will be used in the reminder picker modal
    _pickerData = z.toString();
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
        });
      },
      trailing: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: _expanded ? 0.0 : 1.0,
        child: Container(
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
                color: _hasColor(),
                circleSize: 30.0,
                elevation: .0,
              ),
            ],
          ),
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
                  child: TextFormField(
                    initialValue: _name,
                    onChanged: (o) => setState(() => _name = o),
                    cursorColor: _hasColor(),
                    decoration: InputDecoration(
                        hintText: 'Task Name',
                        focusColor: _hasColor(),
                        fillColor: _hasColor()),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///DUE DATE
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Due date'),
                    _dueDate != null
                        ? Text(
                            DateFormat('EEE d, MMMM yyyy').format(_dueDate),
                          )
                        : Text(
                            'Press the icon to set a due date',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 10.0,
                            ),
                          ),
                    _dueDateTime != null
                        ? Text(MaterialLocalizations.of(context)
                            .formatTimeOfDay(_dueDateTime))
                        : Container(),
                  ],
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.white,
                    accentColor: _hasColor(),
                    accentTextTheme: TextTheme(
                      body1: TextStyle(
                        color: _hasColor().computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                      button: TextStyle(
                        color: _hasColor(),
                      ),
                    ),
                    textTheme: Theme.of(context).textTheme.copyWith(
                          button: TextStyle(
                            color: _hasColor(),
                          ),
                        ),
                    buttonTheme:
                        ButtonThemeData(textTheme: ButtonTextTheme.accent),
                  ),
                  child: Builder(
                    builder: (context) => IconButton(
                      color: _dueDate != null ? _hasColor() : Colors.black,
                      icon: Icon(Icons.date_range),
                      onPressed: () => _selectDueDate(context),
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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Text('Time assigned for the task (hh:mm)'),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_timeForTask.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50.0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _hasColor(),
                      accentColor: _hasColor(),
                    ),
                    child: NumberPicker.integer(
                      zeroPad: true,
                      highlightSelectedValue: true,
                      initialValue: _timeForTask.hours,
                      minValue: 0,
                      itemExtent: 30.0,
                      maxValue: 24,
                      onChanged: (o) => setState(() => _timeForTask.hours = o),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Text(':'),
                ),
                Container(
                  width: 50.0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _hasColor(),
                      accentColor: _hasColor(),
                    ),
                    child: NumberPicker.integer(
                      zeroPad: true,
                      highlightSelectedValue: true,
                      initialValue: _timeForTask.minutes,
                      minValue: 0,
                      itemExtent: 30.0,
                      maxValue: 59,
                      onChanged: (o) =>
                          setState(() => _timeForTask.minutes = o),
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
                  color: _hasColor(),
                  circleSize: 40.0,
                  elevation: .0,
                  onColorChoose: () => selectColor(context),
                )
              ],
            ),
          ),
        ),

        ///REMINDER SETUP
        Card(
          child: Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Switch(
                      value: _hasAlarm,
                      onChanged: (active) => setState(() {
                        //from no active to active
                        if (!_hasAlarm) {
                          _hasAlarm = active;
                          Future.delayed(
                              Duration(milliseconds: 50),
                              () => setState(() => _alarmOpacity =
                                  _alarmOpacity == 1.0 ? 0.0 : 1.0));
                        }
                        //from active to no active
                        else {
                          _alarmOpacity = _alarmOpacity == 0.0 ? 1.0 : 0.0;
                          Future.delayed(Duration(milliseconds: 100),
                              () => setState(() => _hasAlarm = active));
                        }
                      }),
                      activeColor: _hasColor(),
                    ),
                    Text('Reminder'),
                    Icon(Icons.alarm)
                  ],
                ),
                _hasAlarm
                    ? AnimatedOpacity(
                        opacity: _alarmOpacity,
                        duration: Duration(milliseconds: _hasAlarm ? 450 : 50),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text('Remind me: '),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _reminder != null
                                            ? Text(
                                                DateFormat(
                                                        'EEE d, MMMM yyyy HH:mm')
                                                    .format(_reminder),
                                              )
                                            : Text('No reminder set'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  primaryColor: _hasColor(),
                                  accentColor: _hasColor(),
                                  colorScheme: Theme.of(context)
                                      .colorScheme
                                      .copyWith(primary: _hasColor()),
                                ),
                                child: _reminder == null
                                    ? IconButton(
                                        color: _reminder != null
                                            ? _hasColor()
                                            : Colors.black,
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            showPickerModal(context),
                                      )
                                    : IconButton(
                                        color: _hasColor(),
                                        icon: Icon(Icons.clear),
                                        onPressed: () =>
                                            setState(() => _reminder = null),
                                      ),
                              ),
                            ],
                          ),
                        ),
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
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: _hasColor(),
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
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: _hasColor(),
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
            padding: EdgeInsets.only(right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Switch(
                      value: _hasPlan,
                      onChanged: (active) => setState(() {
                        _hasPlan = active;
                        Future.delayed(
                            Duration(milliseconds: 50),
                            () => setState(() => _startDatePhOpacity =
                                _startDatePhOpacity == 1.0 ? 0.0 : 1.0));
                        Future.delayed(
                            Duration(milliseconds: 100),
                            () => setState(() => _dueDatePhOpacity =
                                _dueDatePhOpacity == 1.0 ? 0.0 : 1.0));
                        Future.delayed(
                            Duration(milliseconds: 150),
                            () => setState(() => _timeAvailablePhOpacity =
                                _timeAvailablePhOpacity == 1.0 ? 0.0 : 1.0));
                      }),
                      activeColor: _hasColor(),
                    ),
                    Text('Plan Ahead'),
                    Icon(Icons.schedule),
                  ],
                ),
                _hasPlan
                    ? Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: _startDatePhOpacity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text('Start date of the task'),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(primaryColor: _hasColor()),
                                    child: Builder(
                                      builder: (context) => IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () => selectDate(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: _dueDatePhOpacity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Due date'),
                                      _dueDate != null
                                          ? Text(
                                              DateFormat('EEE d, MMMM yyyy')
                                                  .format(_dueDate),
                                            )
                                          : Container(),
                                      _dueDateTime != null
                                          ? Text(
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(
                                                      _dueDateTime),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      primaryColor: Colors.white,
                                    ),
                                    child: Builder(
                                      builder: (context) => IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () =>
                                            _selectDueDate(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: _timeAvailablePhOpacity,
                              duration: Duration(milliseconds: 500),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            ),
                          ],
                        ),
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
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(days: 1),
      ),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _hasColor(),
              ),
        ),
        child: child,
      ),
    );
    final TimeOfDay _time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _hasColor(),
              ),
        ),
        child: child,
      ),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateTime = _time;
      });
    }
  }

  void selectColor(BuildContext context) async {
    var _tempMainColor;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Color'),
          contentPadding: const EdgeInsets.all(6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: Container(
            height: 250.0,
            child: MaterialColorPicker(
              selectedColor: _hasColor(),
              onColorChange: (Color color) {
                _tempMainColor = color;
              },
              onMainColorChange: (Color color) {
                _tempMainColor = color;
              },
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              textColor: _hasColor(),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('Ok'),
              textColor: _hasColor(),
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

  Color _hasColor() {
    return _taskColor != null ? _taskColor : _defaultColor;
  }

  showPickerModal(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(_pickerData), isArray: true),
        changeToFirst: true,
        hideHeader: false,
        height: 100.0,
        confirmTextStyle: TextStyle(color: _hasColor(), fontSize: 20.0),
        cancelTextStyle: TextStyle(color: _hasColor(), fontSize: 15.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
          var x = picker.adapter.getSelectedValues();
          switch (x[1]) {
            case "Minutes":
              _reminder =
                  DateTime.now().subtract(Duration(minutes: int.parse(x[0])));
              break;
            case "Hours":
              _reminder =
                  DateTime.now().subtract(Duration(hours: int.parse(x[0])));
              break;
            case "Days":
              _reminder =
                  DateTime.now().subtract(Duration(days: int.parse(x[0])));
              break;

            default:
          }
          setState(() {});
        }).showModal(context); //_scaffoldKey.currentState);
  }
}
