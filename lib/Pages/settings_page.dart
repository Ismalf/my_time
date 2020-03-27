import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/BL/dataholder.dart';

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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: true,
        brightness: _gData.getSettings().isDark() ? Brightness.dark : Brightness.light,
        backgroundColor: _gData.getSettings().isDark() ? Theme.of(context).primaryColor : Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text('Tasks Settings')),
          ListTile(
            title: Text('Show Pending Tasks'),
            subtitle: Text(
                'Tasks that are not due the current day will be shown on an inner circle'),
            trailing:
                Switch(value: _gData.getSettings().isDark(), onChanged: null),
          ),
          ListTile(
            title: Text('Reassing not finished tasks to the next day'),
            subtitle: Text(
                'Tasks not marked as finished on due date will be assigned to the next day'),
            trailing:
                Switch(value: _gData.getSettings().isDark(), onChanged: null),
          ),
          ListTile(
            title: Text('Show assigned time on task summary'),
            trailing: Switch(
              value: _gData.getSettings().isDark(),
              onChanged: null,
            ),
          ),
          Divider(),
          ListTile(title: Text('Theme')),
          ListTile(
            title: Text('Dark Theme'),
            trailing: Switch(
                value: _gData.getSettings().isDark(),
                onChanged: (val) =>
                    setState(() => _gData.setDarkMode(val))),
          ),
          Divider(),
          ListTile(title: Text('Storage')),
          ListTile(
            title: Text('Clean past data'),
            subtitle: Text(
                'Remove data until ${DateFormat('EEE d, MMMM yyyy').format(DateTime.now().subtract(Duration(days: 1)))}'),
            trailing: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () => Commons().confirmCancel(
                    context,
                    'Errase data',
                    'Removing past data will clear your history of done tasks, this action is not reversible',
                    'Ok',
                    'Cancel')),
          ),
        ],
      ),
    );
  }
}
