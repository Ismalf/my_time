import 'package:flutter/material.dart';

class TimeIndicator extends StatelessWidget {
  var zeroPad;

  var hour;

  var minute;

  TimeIndicator({this.zeroPad = true, this.hour = 0, this.minute = 0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              alignment: Alignment(1, 1),
              children: <Widget>[
                Text(
                  hour != 0
                      ? zeroPad && hour < 10 ? '0$hour' : '$hour'
                      : zeroPad && minute < 10 ? '0$minute' : '$minute',
                  style: TextStyle(fontSize: 50.0),
                ),
                Text(
                  hour != 0
                      ? hour < 2 ? 'hour' : 'hours'
                      : minute < 2 ? 'minute' : 'minutes',
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text(
                    hour == 0
                        ? zeroPad && hour < 10 ? '0$hour' : '$hour'
                        : zeroPad && minute < 10 ? '0$minute' : '$minute',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.av_timer,
                    size: 15.0,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
