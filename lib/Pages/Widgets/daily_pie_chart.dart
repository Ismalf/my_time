import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';

class DailyPieChart extends StatefulWidget {
  final DailySet dayRepresentation;

  const DailyPieChart({Key key, this.dayRepresentation}) : super(key: key);
  @override
  _DailyPieChart createState() => _DailyPieChart();
}

class _DailyPieChart extends State<DailyPieChart> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  var _chartSize;

  double value = 50.0;
  Color labelColor = Colors.blue[200];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chartSize = Size(400.0, 400.0);
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('should update');
    
  }

  double _calculatePercentage(TimeOfDay taskTime) {
    const minsPerDay = 24 * 60;
    var minsPerTask = taskTime.minute + taskTime.hour * 60;

    return (minsPerTask / minsPerDay) * 100;
  }

  List<CircularStackEntry> _generateChartData(double value) {
    List<Task> tasks = widget.dayRepresentation.tasks ?? [];
    List<CircularStackEntry> data = <CircularStackEntry>[];
    if (tasks?.length == 0)
      data.add(
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              100,
              Colors.grey[200],
              rankKey: 'left',
            )
          ],
          rankKey: 'percentage',
        ),
      );
    else {
      var entries = <CircularSegmentEntry>[];
      tasks.forEach(
        (task) => entries.add(
          new CircularSegmentEntry(
            _calculatePercentage(task.timeForTask),
            task.taskColor,
            rankKey: task.name,
          ),
        ),
      );
      data.add(
        new CircularStackEntry(
          entries,
          rankKey: 'percentage',
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context).textTheme.title.merge(
        new TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black38
                : Colors.white38,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w100));

    var formated =
        DateFormat('EEE d, MMMM yyyy').format(widget.dayRepresentation.day);

    return new GestureDetector(
      child: new AnimatedCircularChart(
        key: _chartKey,
        size: _chartSize,
        initialChartData: _generateChartData(value),
        chartType: CircularChartType.Radial,
        edgeStyle: SegmentEdgeStyle.flat,
        percentageValues: true,
        holeLabel: formated,
        labelStyle: _labelStyle,
        duration: Duration(milliseconds: 1500),
      ),
      onTap: () => print(widget.dayRepresentation.tasks.length),
    );
  }
}
