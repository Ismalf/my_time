import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/BL/taskManagement.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  var _gData;
  var _isDark = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StateContainerState _gData = StateContainer.of(context);
    Color _primaryColor = _gData.getSettings().isDark
        ? Theme.of(context).primaryColor
        : Colors.white;
    Color _accentColor = _gData.getSettings().isDark
        ? Theme.of(context).accentColor
        : Colors.teal;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: true,
        brightness:
            _gData.getSettings().isDark ? Brightness.dark : Brightness.light,
        backgroundColor: _primaryColor,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text(
            'Tasks Settings',
            style: TextStyle(color: _accentColor),
          )),
          ListTile(
            title: Text('Show Pending Tasks'),
            subtitle: Text(
                'Tasks that are not due the current day will be shown on an inner circle'),
            trailing: Switch(
                value: _gData.getSettings().showPendingTasks,
                onChanged: (_v) =>
                    setState(() => _gData.getSettings().setPendingTasks(_v))),
          ),
          _gData.getSettings().showPendingTasks
              ? ListTile(
                  title: Text('Show tasks of the next'),
                  trailing: DropdownButton<int>(
                    value: _gData.getSettings().daysToShow,
                    icon: Icon(Icons.expand_more),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: _accentColor,
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        _gData.getSettings().daysToShow = newValue;
                      });
                    },
                    items:
                        <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value days'),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          ListTile(
            title: Text('Reassing not finished tasks to the next day'),
            subtitle: Text(
                'Tasks not marked as finished on due date will be assigned to the next day'),
            trailing: Switch(
                value: _gData.getSettings().reassingTasks,
                onChanged: (_v) =>
                    setState(() => _gData.getSettings().reassingTasks)),
          ),
          ListTile(
            title: Text('Show assigned time on task summary'),
            trailing: Switch(
              value: _gData.getSettings().showAssignedTime,
              onChanged: (_v) =>
                  setState(() => _gData.getSettings().showAssignedTime = _v),
            ),
          ),
          ListTile(
            title: Text('Split daily routine from tasks'),
            subtitle: Text('Inner circle of the pie will show tasks, trying to fit them among daily routine activities'),
            trailing: Switch(
              value: _gData.getSettings().splitDailyRoutine,
              onChanged: (_v) =>
                  setState(() => _gData.getSettings().splitDailyRoutine = _v),
            ),
          ),
          Divider(),
          ListTile(
              title: Text(
            'Theme',
            style: TextStyle(color: _accentColor),
          )),
          ListTile(
            title: Text('Dark Theme'),
            trailing: Switch(
                value: _gData.getSettings().isDark,
                onChanged: (val) => setState(() => _gData.setDarkMode(val))),
          ),
          Divider(),
          ListTile(
              title: Text(
            'Storage',
            style: TextStyle(color: _accentColor),
          )),
          ListTile(
            title: Text('Clean past data'),
            subtitle: Text(
                'Remove data until ${DateFormat('EEE d, MMMM yyyy').format(DateTime.now().subtract(Duration(days: 1)))}'),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () => Commons()
                  .confirmCancel(
                context,
                'Errase data',
                'Removing past data will clear your history of done tasks, this action is not reversible',
                'Ok',
                'Cancel',
              )
                  .then(
                (_v) {
                  if (_v) {
                    TaskManagement.removeTasksUntil(
                      DateTime.now().subtract(
                        Duration(days: 1),
                      ),
                      StateContainer.of(context).getKeys(),
                      StateContainer.of(context).getSets(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
