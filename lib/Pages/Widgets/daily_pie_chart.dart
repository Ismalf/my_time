import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DailyPieChart extends StatefulWidget {
  final DateTime dayRepresentation;

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
    _chartSize =  Size(400.0,400.0);
  }
  @override
  didUpdateWidget(oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.dayRepresentation != oldWidget.dayRepresentation){
      setState(() {
        
      });
    }
  }

  List<CircularStackEntry> _generateChartData(double value) {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            10,
            Colors.teal,
            rankKey: 'completed',
          ),
          new CircularSegmentEntry(
            50,
            Colors.green,
            rankKey: 'remain',
          ),
          new CircularSegmentEntry(
            100,
            Colors.grey[200],
            rankKey: 'left',
          )
        ],
        rankKey: 'percentage',
      ),
      
    ];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context).textTheme.title.merge(
        new TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w100));

    var formated =
        DateFormat('EEE d, MMMM yyyy').format(widget.dayRepresentation);

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
      onTap: () => print('tap'),
    );
  }
}
