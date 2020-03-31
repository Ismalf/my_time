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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _gData = StateContainer.of(context);
    _ds = StateContainer.of(context).getTodaySet();
    // TODO: implement build
    return Scaffold(
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
            Task(),
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
    print(task.name);
    _changed = true;
    _task = task;
  }
}
