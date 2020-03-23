import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  StateContainer({
    Key key,
    this.child,
  }) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedContainer>())
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  DailySetList _sets;

  List<Map<int, DailySet>> _keys = [];

  List<Map<int, StreamController>> _controllers = [];

  /// have a copy of the todayset
  /// which must be accesible all time
  DailySet _todaySet;
  DailySet _yesterdaySet;
  DailySet _tomorrowSet;

  void setTodaySet(DailySet x) {
    _todaySet = x;
  }

  void setYesterdaySet(DailySet x) {
    //if (_yesterdaySet == null)
    _yesterdaySet = x;
    //else
//_updateSet(x, _yesterdaySet);
  }

  void setTomorrowSet(DailySet x) {
    //if (_tomorrowSet == null)
    _tomorrowSet = x;
    //else
    // _updateSet(x, _tomorrowSet);
  }

  _updateSet(DailySet _new, DailySet _old) {
    if (Commons().compareDates(_new.day, _old.day))
      _updateTask(_new.tasks, _old.tasks);
    else
      _old = _new;
  }

  _updateTask(_newT, _oldT) {
    _oldT = _newT;
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

  void addKey(var key) {
    _keys.add(key);
  }

  bool isLoaded() {
    return this._sets == null;
  }

  void addTask(task, date) {
    print(getTodaySet().day.toString());
    setState(() {
      var ds = _sets.dailysets
          .firstWhere((s) => Commons().compareDates(s.day, date));
      ds.tasks.add(task);
      streamKey(ds).add(ds);
    });
  }

  /// Read data from DB
  Future<DailySetList> loadData() async {
    // execute db read
    _sets = await DailySetDao().getAllData();
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

  updateDailySet(DailySet ds) {
    setState(() {
      this._todaySet = ds;
    });
  }

  /// Get a date-specific set of tasks
  DailySet loadSet(DateTime day) {
    var _set;
    try {
      // search the sets for a set matching the correspondig date
      _set = _sets.dailysets
          .firstWhere((dSet) => Commons().compareDates(dSet.day, day));
    } catch (_) {
      // as the firstWhere method throws an error if no match is found
      // catch it and make a new set with the corresponding date
      _set = DailySet(day: day, tasks: []);
      DailySetDao().insert(_set);
      _sets.dailysets.add(_set);
    }
    _setController(_set);
    return _set;
  }

  _setController(DailySet _set) {
    var key = _sets.dailysets.indexOf(_set);
    var controller;
    try {
      controller = _controllers.firstWhere((c) => c.containsKey(key))[key];
    } catch (_) {
      controller = new StreamController.broadcast(onListen: ()=>print('listening'));
      _controllers.add({key: controller});
    }
    return controller;
  }

  StreamController streamKey(DailySet _set) {
    var key = _sets.dailysets.indexOf(_set);
    try {
      return _controllers.firstWhere((c) => c.containsKey(key))[key];
    } catch (e) {
      return null;
    }
  }

  void updateSet(DateTime day, List<Task> tasks) {
    var _set = loadSet(day); // get the corresponding set
    _set.tasks = tasks; // update tasks

    //TODO save to DB once set is updated
  }

  @override
  void initState() {
    super.initState();
    //load sets from db
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
