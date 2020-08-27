import 'package:flutter/material.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';
import 'package:my_time/Pages/Widgets/activityWidget.dart';

class NewActivity extends StatefulWidget {
  @override
  _NewActivity createState() => _NewActivity();
}

class _NewActivity extends State<NewActivity> {
  DailySet _ds;
  var _task;
  var _changed = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _gData = StateContainer.of(context);
    _ds = StateContainer.of(context).getTodaySet();
    var _tod = _gData.lastTaskEndTime;

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('New task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Commons()
              .confirmCancel(context, 'Exit without saving',
                  'No changes will be saved', 'Ok', 'Cancel')
              .then((value) {
            if (value) Navigator.of(context).pop();
          }),
        ),
        elevation: 0.0,
        brightness:
            _gData.getSettings().isDark ? Brightness.dark : Brightness.light,
        backgroundColor: _gData.getSettings().isDark
            ? Theme.of(context).primaryColor
            : Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          ActivityWidget(
            _tod != null ? Task(startDateTime: _tod) : Task(),
            onChanged: (task) => _updateTask(task),
            expanded: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor
            : Colors.white,
        child: Icon(
          Icons.save,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).accentColor
              : Colors.black,
        ),
      ),
    );
  }

  _save() async {
    await StateContainer.of(context).addTask(_task);

    Navigator.of(context).pop(_ds);
  }

  void _updateTask(Task task) {
    /*var _gData = StateContainer.of(context);
    if (_gData.doesOverlap(task.name)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Activity Name is already in use'),
        ),
      );
      return;
    }
    if (_gData.doesOverlap(task.taskColor)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Activity Color is already in use'),
        ),
      );
      return;
    }
    if (_gData.doesOverlap(task.startDateTime)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              'Other activity starts at ${task.startDateTime.format(context)}'),
        ),
      );

      return;
    }*/
    _changed = true;
    _task = task;
  }
}
