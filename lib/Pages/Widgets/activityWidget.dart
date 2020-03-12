import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ActivityWidget extends StatefulWidget {
  @override
  _ActivityWidget createState() => _ActivityWidget();
}

class _ActivityWidget extends State<ActivityWidget> {
  var today;

  var dropdownValue;

  var selected;

  var _date;

  var _tempMainColor;

  var _tempShadeColor;

  var _mainColor;

  var _shadeColor;

  var _expanded = false;

  var _trailWidth = 150.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExpansionTile(
      leading: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
      title: Text('Activity for today'),
      initiallyExpanded: false,
      onExpansionChanged: (changed) {
        setState(() {
          _expanded = changed;
          _trailWidth = _expanded ? 0.0 : 150.0;
        });
      },
      trailing: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: _trailWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('9h'),
            SizedBox(
              width: 25.0,
            ),
            CircleColor(color: Colors.green, circleSize: 30.0),
          ],
        ),
      ),
      children: <Widget>[
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text('Time assigned for the task'),
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
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Color'),
                CircleColor(
                  color: Colors.green,
                  circleSize: 40.0,
                  elevation: 5.0,
                  onColorChoose: () => selectColor(context),
                )
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Alarm'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Checkbox(value: false, onChanged: null),
                    Text('h:mm'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Priority'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
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
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Category'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.expand_more),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
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
        Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Plan Ahead'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Checkbox(value: false, onChanged: null),
                    Text('h:mm'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('Start date of the task'),
                    IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => selectDate(context))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('End date of the task'),
                    IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => selectDate(context))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Text('Max amount of time available (Daily)'),
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
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void selectColor(BuildContext context) async {
    final Color picked = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Color'),
          contentPadding: const EdgeInsets.all(6.0),
          content: MaterialColorPicker(
            onColorChange: (Color color) {
              print(color);
            },
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }
}
