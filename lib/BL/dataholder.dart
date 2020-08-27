import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_time/BL/alarms.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/Data/AppSettings/settings.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
import 'package:my_time/Data/Models/Notifications.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final ValueChanged onThemeChange;

  StateContainer({Key key, this.child, this.onThemeChange}) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedContainer>())
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  DailySetList _sets;

  var _theme = StreamController.broadcast(onListen: () => print('listening'));

  Map<int, String> _keys = Map();

  Map<int, StreamController> _controllers = Map();

  TimeOfDay _lastTaskEndTime;

  /// have a copy of the todayset
  /// which must be accesible all time
  DailySet _todaySet;
  DailySet _yesterdaySet;
  DailySet _tomorrowSet;

  /// App Settings

  AppSettings _settings;

  TimeOfDay get lastTaskEndTime => this._lastTaskEndTime;
  set lastTaskEndTime(TimeOfDay tod) => this._lastTaskEndTime = tod;

  Stream getThemeStream() {
    return _theme.stream;
  }

  void setTodaySet(DailySet x) {
    _todaySet = x;
  }

  updateDailySet() {
    var ds = getTodaySet();
    DailySetDao().updateTask(ds, _getKey(ds));
  }

  void setYesterdaySet(DailySet x) {
    _yesterdaySet = x;
  }

  void setTomorrowSet(DailySet x) {
    _tomorrowSet = x;
  }

  DailySet getTodaySet() {
    return this._todaySet;
  }

  DailySet getYesterdaySet() {
    return this._yesterdaySet;
  }

  DailySet getTomorrowSet() {
    return this._tomorrowSet;
  }

  void addKey(List<MapEntry<int, String>> key) {
    _keys.addEntries(key);
  }

  bool isLoaded() {
    return this._sets == null;
  }

  addTask(Task task) async {
    if (task.hasAlarm && task.reminder != null)
      ScheduleNotification.showDailyAtTime(task.reminder, task.name);
    DailySet ds = await loadSet(task.dueDate, context);
    //_sets.dailysets.firstWhere((s) => Commons().compareDates(s.day, task.dueDate));
    setState(() {
      try {
        Task t = ds.tasks.firstWhere((element) => element.name == task.name);
        int tIndex = ds.tasks.indexOf(t);
        ds.tasks[tIndex] = task;
      } catch (_) {
        ds.tasks.add(task);
      }
      //send new DailySet into the stream to update
      //the corresponding pie chart
      dsStreamController(ds).add(ds);
    });
    DailySetDao().updateTask(ds, _getKey(ds));

    return true;
  }

  _getKey(ds) {
    return _keys.keys.firstWhere((m) => _keys[m] == ds.formatDate());
  }

  getKeys() {
    return this._keys;
  }

  getSets() {
    return this._sets;
  }

  /// Compare the sets of the current date
  /// to check if one of them already contains
  /// a given value, in an effort to prevent
  /// overlaping activities or making the undifferentiable
  bool doesOverlap(dynamic _v) {
    // Check if start time is already being used by other task
    try {
      if (_v is TimeOfDay) {
        _todaySet.tasks.firstWhere((_t) => _t.startDateTime == _v);
        return true;
      } else
      // Check if a color is already used by a task, to prevent confusion
      if (_v is Color) {
        _todaySet.tasks.firstWhere((_t) => _t.taskColor == _v);
        return true;
      } else
      // Check if another activity has the same name
      if (_v is String) {
        _todaySet.tasks.firstWhere((_t) => _t.name == _v);
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  /// Read data from DB
  Future<DailySetList> loadData(context) async {
    // execute db read
    _sets = await DailySetDao().getAllData(context);
    //load keys into memory

    await _setValues(_sets, context);
    return _sets;
  }

  _setValues(DailySetList _sets, context) async {
    var _today = DateTime.now();
    var _yesterday = _today.add(Duration(days: -1));
    var _tomorrow = _today.add(Duration(days: 1));

    setTodaySet(await loadSet(_today, context));

    setYesterdaySet(await loadSet(_yesterday, context));

    setTomorrowSet(await loadSet(_tomorrow, context));
  }

  /// As the activity list reorders, so must do the activity list
  void updateTaskOrder(Task task, int currentindex, int newindex) {
    _todaySet.tasks.removeAt(currentindex);
    _todaySet.tasks.insert(newindex, task);
    // TODO update on db
  }

  /// Get a date-specific set of tasks
  Future<DailySet> loadSet(DateTime day, context) async {
    DailySet _set;
    try {
      // search the sets for a set matching the correspondig date
      _set = _sets.dailysets
          .firstWhere((dSet) => Commons().compareDates(dSet.day, day));
      _setController(_set);
    } catch (_) {
      // as the firstWhere method throws an error if no match is found
      // catch it and make a new set with the corresponding date
      _set = DailySet(day: day, tasks: []);
      await DailySetDao().insert(_set, context);
      //when new date is finished inserting, set its new controller

      _setController(_set);

      _sets.dailysets.add(_set);
    }

    return _set;
  }

  _setController(DailySet _set) {
    var controller;

    controller = dsStreamController(_set);
    if (controller == null) {
      controller =
          new StreamController.broadcast(onListen: () => print('listening'));
      var key = _getKey(_set);
      _controllers.addEntries([MapEntry(key, controller)]);
    }

    return controller;
  }

  StreamController dsStreamController(DailySet _set) {
    var key = _getKey(_set);
    try {
      return _controllers[key];
    } catch (e) {
      return null;
    }
  }

  void updateSet(DateTime day, List<Task> tasks, context) async {
    var _set = await loadSet(day, context); // get the corresponding set
    _set.tasks = tasks; // update tasks

    //TODO save to DB once set is updated
  }

  AppSettings getSettings() {
    return _settings;
  }

  void setDarkMode(val) {
    setState(() => _settings.setDarkMode(val));
    _theme.add(val ? Brightness.dark : Brightness.light);
  }

  @override
  void initState() {
    super.initState();
    //load sets from db
    _settings = AppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedContainer(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedContainer extends InheritedWidget {
  InheritedContainer({Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);
  static InheritedContainer of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedContainer>();
  }

  final StateContainerState data;

  @override
  bool updateShouldNotify(InheritedContainer old) {
    return true;
  }
}
