import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  double? deviceHeight, deviceWidth;
  List glucoseValues;
  LineChartWidget(
      {required this.glucoseValues,
      required this.deviceHeight,
      required this.deviceWidth,
      super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tooltipBehavior = TooltipBehavior(enable: true, header: "Glucose");
    return Container(
      color: Colors.brown[900],
      width: widget.deviceWidth,
      height: widget.deviceHeight! * 0.3,
      child: SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            width: 4,
            enableTooltip: true,
            dataSource: widget.glucoseValues
                .map((glucTuple) => ChartData(glucTuple[1], glucTuple[0]))
                .toList(),
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.value,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.date, this.value);
  final String date;
  final int value;
}
