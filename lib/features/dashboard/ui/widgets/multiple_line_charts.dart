import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/line_chart_container.dart';

class MultipleLineCharts extends StatelessWidget {
  final List<List<FlSpot>> dataSets;
  final List<String> titles;

  const MultipleLineCharts({
    Key? key,
    required this.dataSets,
    required this.titles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> lineCharts = List.generate(
      dataSets.length,
      (index) => LineChartContainer(
        title: titles[index],
        spots: dataSets[index],
      ),
    );

    return Column(
      children: lineCharts,
    );
  }
}
