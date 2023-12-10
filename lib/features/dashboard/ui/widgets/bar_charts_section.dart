import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/bar_chart_container.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/horizontal_scrolling_section.dart';

class BarChartsSection extends StatelessWidget {
  final DashboardData data;

  const BarChartsSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barChartsData = _generateBarChartData(data);
    return HorizontalScrollingSection(
      itemCount: barChartsData.length,
      itemBuilder: (index) => BarChartContainer(
        title: 'Bar Chart $index',
        barGroups: barChartsData[index],
      ),
    );
  }

  List<List<BarChartGroupData>> _generateBarChartData(DashboardData data) {
    // Mock data generation logic for bar charts
    return [
      // First Bar Chart Data
      [
        BarChartGroupData(x: 0, barRods: [
          BarChartRodData(toY: 10, color: Colors.blue),
          BarChartRodData(toY: 12, color: Colors.red),
        ]),
        // ... more groups as needed
      ],
      // Second Bar Chart Data
      // ... another set of data
    ];
  }
}
