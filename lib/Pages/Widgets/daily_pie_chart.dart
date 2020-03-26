import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';

class DailyPieChart extends StatefulWidget {
  final Stream taskController;
  final DailySet initData;
  const DailyPieChart({Key key, this.taskController, this.initData})
      : super(key: key);
  @override
  _DailyPieChart createState() => _DailyPieChart();
}

class _DailyPieChart extends State<DailyPieChart> {
  GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  var _chartSize;

  var value;
  var initdata;
  var _duration;
  Color labelColor = Colors.blue[200];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chartSize = Size(400.0, 400.0);

    initdata = widget.initData;
    print(widget.taskController.listen((data) {
      setState(() {
        this.initdata = data;
      });
      print(data);
    }));
    _duration = 1000;
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

  List<CircularStackEntry> _generateChartData(DailySet value) {
    List<Task> tasks = value.tasks ?? [];
    List<CircularStackEntry> data = <CircularStackEntry>[];
    if (tasks?.length == 0)
      data.add(
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              100,
              Colors.white10,
              rankKey: '_fill',
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
      entries.add(
        new CircularSegmentEntry(
          100.0,
          Colors.white10,
          rankKey: '_fill',
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

    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.error != null)
          return Center(child: Text('Something went wrong :c'));
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            value = snapshot.data;
            _chartKey = new GlobalKey<AnimatedCircularChartState>();

            print('waiting');
            print(value);
            return new AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: _generateChartData(value),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.flat,
              percentageValues: true,
              holeLabel: DateFormat('EEE d, MMMM yyyy').format(value.day),
              labelStyle: _labelStyle,
              duration: Duration(milliseconds: _duration),
            );
          case ConnectionState.active:
            value = snapshot.data;
            _chartKey = new GlobalKey<AnimatedCircularChartState>();

            print('active');
            print(value);
            return new AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: _generateChartData(value),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.flat,
              percentageValues: true,
              holeLabel: DateFormat('EEE d, MMMM yyyy').format(value.day),
              labelStyle: _labelStyle,
              duration: Duration(milliseconds: _duration),
            );
          case ConnectionState.done:
            var value = snapshot.data;
            return new AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: _generateChartData(value),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.flat,
              percentageValues: true,
              holeLabel: DateFormat('EEE d, MMMM yyyy').format(value.day),
              labelStyle: _labelStyle,
              duration: Duration(milliseconds: _duration),
            );
          default:
            return CircularProgressIndicator();
        }
      },
      initialData: initdata,
      stream: widget.taskController,
    );
  }
}
