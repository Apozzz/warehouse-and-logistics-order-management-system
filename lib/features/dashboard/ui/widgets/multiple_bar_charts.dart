import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/bar_chart_container.dart';

class MultipleBarCharts extends StatelessWidget {
  final List<List<BarChartGroupData>> barChartsData;
  final List<String> titles;

  const MultipleBarCharts({
    Key? key,
    required this.barChartsData,
    required this.titles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> barCharts = List.generate(
      barChartsData.length,
      (index) => BarChartContainer(
        title: titles[index],
        barGroups: barChartsData[index],
      ),
    );

    return Column(
      children: barCharts,
    );
  }
}
