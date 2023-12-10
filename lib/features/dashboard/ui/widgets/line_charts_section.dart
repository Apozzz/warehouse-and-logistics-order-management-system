import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/horizontal_scrolling_section.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/line_chart_container.dart';

class LineChartsSection extends StatelessWidget {
  final DashboardData data;

  const LineChartsSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lineChartsData = _generateLineChartData(data);
    return HorizontalScrollingSection(
      itemCount: lineChartsData.length,
      itemBuilder: (index) => LineChartContainer(
        title: 'Line Chart $index',
        spots: lineChartsData[index],
      ),
    );
  }

  List<List<FlSpot>> _generateLineChartData(DashboardData data) {
    // Mock data generation logic for line charts
    // Replace with your actual data structure and logic
    return [
      // First Line Chart Data
      List.generate(
          10, (index) => FlSpot(index.toDouble(), (index * 10).toDouble())),
      // Second Line Chart Data
      List.generate(
          10, (index) => FlSpot(index.toDouble(), (index * 5).toDouble())),
      // Add more data sets for additional line charts
    ];
  }
}
