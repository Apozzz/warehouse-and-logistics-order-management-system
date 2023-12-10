import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/pie_chart_container.dart';

class MultiplePieCharts extends StatelessWidget {
  final List<List<PieChartSectionData>> pieChartsData;
  final List<String> titles;

  const MultiplePieCharts({
    Key? key,
    required this.pieChartsData,
    required this.titles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> pieCharts = List.generate(
      pieChartsData.length,
      (index) => PieChartContainer(
        title: titles[index],
        sections: pieChartsData[index],
      ),
    );

    return Column(
      children: pieCharts,
    );
  }
}
