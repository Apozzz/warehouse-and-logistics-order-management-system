import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/horizontal_scrolling_section.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/pie_chart_container.dart';

class PieChartsSection extends StatelessWidget {
  final DashboardData data;

  const PieChartsSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pieChartsData = _generatePieChartsData(data);
    return HorizontalScrollingSection(
      itemCount: pieChartsData.length,
      itemBuilder: (index) => PieChartContainer(
        title: 'Pie Chart $index',
        sections: pieChartsData[index],
      ),
    );
  }

  List<List<PieChartSectionData>> _generatePieChartsData(DashboardData data) {
    // Mock data generation logic for pie charts
    return [
      // First Pie Chart Data
      [
        PieChartSectionData(color: Colors.blue, value: 40, title: 'Section A'),
        PieChartSectionData(color: Colors.red, value: 30, title: 'Section B'),
        PieChartSectionData(color: Colors.green, value: 15, title: 'Section C'),
        // ... more sections as needed
      ],
      // Second Pie Chart Data
      // ... another set of data
    ];
  }
}
