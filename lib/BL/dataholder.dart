import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/Data/AppSettings/settings.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
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

  /// have a copy of the todayset
  /// which must be accesible all time
  DailySet _todaySet;
  DailySet _yesterdaySet;
  DailySet _tomorrowSet;

  /// App Settings

  AppSettings _settings;

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

  void addTask(task, date) {
    print(getTodaySet().day.toString());
    var ds =
        _sets.dailysets.firstWhere((s) => Commons().compareDates(s.day, date));
    setState(() {
      ds.tasks.add(task);
      //send new DailySet into the stream to update
      //the corresponding pie chart
      dsStreamController(ds).add(ds);
    });
    DailySetDao().updateTask(ds, _getKey(ds));
  }

  _getKey(ds) {
    return _keys.keys.firstWhere((m) => _keys[m] == ds.formatDate());
  }

  /// Read data from DB
  Future<DailySetList> loadData(context) async {
    // execute db read
    _sets = await DailySetDao().getAllData(context);
    //load keys into memory

    _setValues(_sets);
    return _sets;
  }

  _setValues(DailySetList _sets) {
    var _today = DateTime.now();
    var _yesterday = _today.add(Duration(days: -1));
    var _tomorrow = _today.add(Duration(days: 1));

    setTodaySet(loadSet(_today));

    setYesterdaySet(loadSet(_yesterday));

    setTomorrowSet(loadSet(_tomorrow));
  }

  /// As the activity list reorders, so must do the activity list
  void updateTaskOrder(Task task, int currentindex, int newindex) {
    _todaySet.tasks.removeAt(currentindex);
    _todaySet.tasks.insert(newindex, task);
    // TODO update on db
  }

  /// Get a date-specific set of tasks
  DailySet loadSet(DateTime day) {
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
      DailySetDao().insert(_set, context).then((val) {
        //when new date is finished inserting, set its new controller
        print(val);
        _setController(_set);
      });

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

  void updateSet(DateTime day, List<Task> tasks) {
    var _set = loadSet(day); // get the corresponding set
    _set.tasks = tasks; // update tasks

    //TODO save to DB once set is updated
  }

  AppSettings getSettings() {
    return _settings;
  }

  void setDarkMode(val) {
    setState(()=>_settings.setDarkMode(val));
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
