import 'package:flutter/material.dart';
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

  List<int> _keys = [];

  /// have a copy of the todayset
  /// which must be accesible all time
  DailySet _todaySet;

  void setTodaySet(DailySet x) => _todaySet = x;

  DailySet getTodaySet() => this._todaySet;

  void addKey(int key) {
    _keys.add(key);
  }

  /// Read data from DB
  void loadData() async {
    // execute db read
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
      _set = _sets.dailysets.firstWhere((dSet) => dSet.day == day);
    } catch (_) {
      // as the firstWhere method throws an error if no match is found
      // catch it and make a new set with the corresponding date
      _set = DailySet(day: day, tasks: []);
    }
    return _set;
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
