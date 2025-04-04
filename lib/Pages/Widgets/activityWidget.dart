import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Pages/Widgets/timeIndicator.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ActivityWidget extends StatefulWidget {
  final Task task;
  final Key key;
  final ValueChanged<Task> onChanged;
  final expanded;
  ActivityWidget(this.task, {this.key, this.onChanged, this.expanded});

  @override
  _ActivityWidget createState() => _ActivityWidget(this.task);
}

class _ActivityWidget extends State<ActivityWidget> {
  _ActivityWidget(this._task);

  ///TASK CLASS VARIABLES

  Task _task;

  ///WIDGET VARIABLES

  var _mainctx;

  var _dateTextStyle;

  var _subtitleTextStyle;

  var _cardsOpacity = 1.0;

  var _alarmOpacity = 0.0;

  var _startDatePhOpacity = 0.0;

  var _dueDatePhOpacity = 0.0;

  var _timeAvailablePhOpacity = 0.0;

  var _expanded = false;

  var _trailWidth = 150.0;

  Color _defaultColor = Colors.lightBlue;

  String _pickerData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _expanded = widget.expanded ?? false;
    //Build data at the construction of the widget
    _buildReminderModalPickerData();
    _alarmOpacity = _task.hasAlarm ? 1.0 : 0.0;
    if (_task.startDateTime == null) _task.startDateTime = TimeOfDay.now();
    var _now = DateTime.now();
    _task.startDate = DateTime(_now.year, _now.month, _now.day,
        _task.startDateTime.hour, _task.startDateTime.minute);
    _dateTextStyle = TextStyle(fontWeight: FontWeight.w100, fontSize: 13.0);
    _subtitleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0);
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
    print(_task.reminder);
    // TODO: implement build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      if (widget.onChanged != null) widget.onChanged(_task);
    });

    //setState(() => _mainctx = context);
    var hour = _task.timeForTask?.hour ?? 0;
    var minute = _task.timeForTask?.minute ?? 0;
    return ExpansionTile(
      leading: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
      title: Text(_task.name),
      initiallyExpanded: widget.expanded ?? false,
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
              _task.timeForTask != null
                  ? Text((hour < 10 ? '0$hour' : '$hour') +
                      ' : ' +
                      (minute < 10 ? '0$minute' : '$minute'))
                  : Container(),
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
                  child: Text(
                    'Activity name',
                    style: _subtitleTextStyle,
                  ),
                ),
                Container(
                  width: 150.0,
                  child: TextFormField(
                    initialValue: _task.name,
                    onChanged: (o) => setState(() => _task.name = o),
                    cursorColor: _hasColor(),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      focusColor: _hasColor(),
                      fillColor: _hasColor(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasColor(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ///DUE DATE
        /* _task.hasPlan
            ? Container()
            : AnimatedOpacity(
                opacity: _cardsOpacity,
                duration: Duration(milliseconds: 500),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Due date',
                                style: _subtitleTextStyle,
                              ),
                              _task.dueDate != null
                                  ? Text(
                                      DateFormat('EEE d, MMMM yyyy')
                                          .format(_task.dueDate),
                                      style: _dateTextStyle,
                                    )
                                  : Text(
                                      'Press the icon to set a due date',
                                      style: _dateTextStyle,
                                    ),
                              _task.dueDateTime != null
                                  ? Text(MaterialLocalizations.of(context)
                                      .formatTimeOfDay(_task.dueDateTime))
                                  : Container(),
                            ],
                          ),
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
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.accent),
                          ),
                          child: Builder(
                            builder: (context) => IconButton(
                              color: _task.dueDate != null
                                  ? _hasColor()
                                  : Theme.of(context).primaryColor,
                              icon: Icon(Icons.date_range),
                              onPressed: () => _selectDueDate(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), */

        ///TIME FOR THE TASK
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
                    Text('Daily Schedule', style: _subtitleTextStyle),
                    Icon(Icons.schedule),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Start at',
                                style: _subtitleTextStyle,
                              ),
                              _task.startDateTime != null
                                  ? Text(
                                      MaterialLocalizations.of(context)
                                          .formatTimeOfDay(_task.startDateTime),
                                      style: _dateTextStyle,
                                    )
                                  : Container(),
                            ],
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Colors.white,
                              accentColor: _hasColor(),
                              accentTextTheme: TextTheme(
                                bodyText2: TextStyle(
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
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.accent),
                            ),
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () => _selectStartDate(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'End at',
                                style: _subtitleTextStyle,
                              ),
                              _task.dueDateTime != null
                                  ? Text(
                                      MaterialLocalizations.of(context)
                                          .formatTimeOfDay(_task.dueDateTime),
                                      style: _dateTextStyle,
                                    )
                                  : Container(),
                            ],
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Colors.white,
                              accentColor: _hasColor(),
                              accentTextTheme: TextTheme(
                                bodyText2: TextStyle(
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
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.accent),
                            ),
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () => _selectDueDate(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('Time assigned'),
                                      ),
                                    ],
                                  ),
                                ),
                                /* Text(
                                  'Tap to set',
                                  style: _dateTextStyle,
                                ), */
                              ],
                            ),
                          ),
                          TimeIndicator(
                            hour: _task.timeForTask?.hour ?? 0,
                            minute: _task.timeForTask?.minute ?? 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        /* GestureDetector(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: 
            ),
          ),
          onTap: () => _showTaskTimeModal(context),
        ), */

        ///COLOR PICKER
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Color',
                  style: _subtitleTextStyle,
                ),
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

        ///PRIORITY
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Priority',
                  style: _subtitleTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _task.priority,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: _hasColor(),
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _task.priority = newValue;
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
                Text(
                  'Category',
                  style: _subtitleTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _task.category,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: _hasColor(),
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _task.category = newValue;
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
                      value: _task.hasAlarm,
                      onChanged: (active) => setState(() {
                        _task.hasAlarm
                            ? _hideReminderSettings()
                            : _showReminderSettings();
                      }),
                      activeColor: _hasColor(),
                    ),
                    Text('Reminder'),
                    Icon(Icons.alarm)
                  ],
                ),
                _task.hasAlarm
                    ? AnimatedOpacity(
                        opacity: _alarmOpacity,
                        duration:
                            Duration(milliseconds: _task.hasAlarm ? 450 : 50),
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
                                            child: Text('Remind me: ',
                                                style: _dateTextStyle),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _task.reminder != null
                                            ? Text(
                                                'Daily at: ' +
                                                    TimeOfDay.fromDateTime(
                                                            _task.reminder)
                                                        .format(context),
                                                style: _subtitleTextStyle,
                                              )
                                            : Text(
                                                'No reminder set',
                                                style: _subtitleTextStyle,
                                              ),
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
                                child: _task.reminder == null
                                    ? IconButton(
                                        color: _task.reminder != null
                                            ? _hasColor()
                                            : Theme.of(context).accentColor,
                                        icon: Icon(Icons.add),
                                        onPressed: () => _showReminderModal(
                                            context,
                                            dueDate: _task.dueDate,
                                            startDate: _task.startDate),
                                      )
                                    : IconButton(
                                        color: _hasColor(),
                                        icon: Icon(Icons.clear),
                                        onPressed: () => setState(
                                            () => _task.reminder = null),
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

        ///PLAN AHEAD

        SizedBox(
          height: 40.0,
        )
      ],
    );
  }

  void _showPlanAheadSettings() {
    _cardsOpacity = 0.0;
    _task.hasPlan = true;

    Future.delayed(
        Duration(milliseconds: 50),
        () => setState(() =>
            _startDatePhOpacity = _startDatePhOpacity == 1.0 ? 0.0 : 1.0));
    Future.delayed(
        Duration(milliseconds: 100),
        () => setState(
            () => _dueDatePhOpacity = _dueDatePhOpacity == 1.0 ? 0.0 : 1.0));
    Future.delayed(
        Duration(milliseconds: 150),
        () => setState(() => _timeAvailablePhOpacity =
            _timeAvailablePhOpacity == 1.0 ? 0.0 : 1.0));
  }

  void _hidePlanAheadSettings() {
    _timeAvailablePhOpacity = _timeAvailablePhOpacity == 0.0 ? 1.0 : 0.0;
    _dueDatePhOpacity = _dueDatePhOpacity == 0.0 ? 1.0 : 0.0;
    _startDatePhOpacity = _startDatePhOpacity == 0.0 ? 1.0 : 0.0;
    Future.delayed(
        Duration(milliseconds: 200),
        () => setState(() {
              _task.hasPlan = false;
              Future.delayed(Duration(milliseconds: 50),
                  () => setState(() => _cardsOpacity = 1.0));
            }));
  }

  void _selectDueDate(BuildContext context) async {
    /* final DateTime picked = await showDatePicker(
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
    ); */
    if (_task.startDateTime == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please set a starting hour'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
      return;
    }
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

    if (_time == null) return;

    setState(() {
      var _now = DateTime.now();

      _task.dueDateTime = _time;
      _task.dueDate =
          DateTime(_now.year, _now.month, _now.day, _time.hour, _time.minute);
      _task.timeForTask = _substractTOD(_task.dueDateTime, _task.startDateTime);
      StateContainer.of(context).lastTaskEndTime = _time;
    });
  }

  _substractTOD(TimeOfDay end, TimeOfDay start) {
    if (end.period == start.period) {
      var _total =
          (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
      var _hour = 0;
      var _minute = 0;
      if (_total >= 60) {
        _hour = (_total / 60).floor();
        _minute = _total - 60 * _hour;
      } else {
        _hour = 0;
        _minute = _total;
      }
      return TimeOfDay(hour: _hour, minute: _minute);
    } else if (end.period.index < start.period.index) {
      var _total =
          ((start.hourOfPeriod - start.periodOffset) * 60 + start.minute) -
              (end.hour * 60 + end.minute);
      _total = _total.abs();

      var _hour = 0;
      var _minute = 0;
      if (_total >= 60) {
        _hour = (_total / 60).floor();
        _minute = _total - 60 * _hour;
      } else {
        _hour = 0;
        _minute = _total;
      }
      return TimeOfDay(hour: _hour, minute: _minute);
    } else {
      var _total = ((end.hour + start.periodOffset) * 60 + end.minute) -
          (start.hour * 60 + start.minute);
      _total = _total.abs();

      var _hour = 0;
      var _minute = 0;
      if (_total >= 60) {
        _hour = (_total / 60).floor();
        _minute = _total - 60 * _hour;
      }
      return TimeOfDay(hour: _hour, minute: _minute);
    }
  }

  void _selectStartDate(BuildContext context) async {
    /* final DateTime picked = await showDatePicker(
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
    ); */
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
    if (_time == null) return;
    setState(() {
      var _now = DateTime.now();

      _task.startDateTime = _time;
      _task.startDate =
          DateTime(_now.year, _now.month, _now.day, _time.hour, _time.minute);
      _task.dueDateTime =
          _task.timeForTask = StateContainer.of(context).lastTaskEndTime = null;
      _task.hasDailyReminder = false;
      _task.reminder = null;
      _task.hasAlarm = false;
      _alarmOpacity = 0.0;
    });
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
                setState(() => _task.taskColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }

  Color _hasColor() {
    return _task.taskColor != null ? _task.taskColor : _defaultColor;
  }

  _showReminderModal(BuildContext context, {dueDate, startDate}) {
    if (dueDate == null && startDate == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please set a starting hour'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
      return;
    }
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(_pickerData), isArray: true),
        changeToFirst: true,
        hideHeader: false,
        height: 100.0,
        backgroundColor: Theme.of(context).primaryColor,
        textStyle: TextStyle(
          color: _hasColor(),
          fontSize: 20.0,
        ),
        confirmTextStyle: TextStyle(color: _hasColor(), fontSize: 20.0),
        cancelTextStyle: TextStyle(color: _hasColor(), fontSize: 15.0),
        onConfirm: (Picker picker, List value) {
          var x = picker.adapter.getSelectedValues();
          var _referenceDate = startDate ?? dueDate;
          switch (x[1]) {
            case "Minutes":
              _task.reminder =
                  _referenceDate.subtract(Duration(minutes: int.parse(x[0])));
              break;
            case "Hours":
              _task.reminder =
                  _referenceDate.subtract(Duration(hours: int.parse(x[0])));
              break;
            case "Days":
              _task.reminder =
                  _referenceDate.subtract(Duration(days: int.parse(x[0])));
              break;

            default:
          }
          setState(() {});
        }).showModal(context); //_scaffoldKey.currentState);
  }

  _showTaskTimeModal(BuildContext context) {
    var x = [], y = [], z;
    for (var i = 0; i <= 24; i++) x.add(i < 10 ? '"0$i"' : i);
    for (var i = 0; i <= 59; i++) y.add(i < 10 ? '"0$i"' : i);
    z = [x, y].toString();
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(z), isArray: true),
        changeToFirst: true,
        selectedTextStyle: TextStyle(
          color: _hasColor(),
          fontSize: 25.0,
        ),
        hideHeader: false,
        height: 100.0,
        backgroundColor: Theme.of(context).primaryColor,
        textStyle: TextStyle(
          color: _hasColor(),
          fontSize: 20.0,
        ),
        confirmTextStyle: TextStyle(color: _hasColor(), fontSize: 20.0),
        cancelTextStyle: TextStyle(color: _hasColor(), fontSize: 15.0),
        onConfirm: (Picker picker, List value) {
          var time = picker.adapter.getSelectedValues();
          _task.timeForTask =
              TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
          if (_task.startDateTime != null)
            _task.dueDateTime = TimeOfDay(
                hour: _task.timeForTask.hour + _task.startDateTime.hour,
                minute: _task.timeForTask.minute + _task.startDateTime.minute);

          setState(() {});
        }).showModal(context); //_scaffoldKey.currentState);
  }

  _forceReminder() {
    if (!_task.hasAlarm) {
      setState(() {
        _showReminderSettings();
        _showReminderModal(context,
            startDate: _task.startDate, dueDate: _task.dueDate);
      });
    }
  }

  _hideReminderSettings() {
    _alarmOpacity = _alarmOpacity == 0.0 ? 1.0 : 0.0;
    Future.delayed(Duration(milliseconds: 100),
        () => setState(() => _task.hasAlarm = false));
  }

  _showReminderSettings() {
    _task.hasAlarm = true;
    Future.delayed(Duration(milliseconds: 50),
        () => setState(() => _alarmOpacity = _alarmOpacity == 1.0 ? 0.0 : 1.0));
  }
}
