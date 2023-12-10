import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartContainer extends StatelessWidget {
  final String title;
  final List<PieChartSectionData> sections;

  const PieChartContainer({
    Key? key,
    required this.title,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Take the width of the Card
              height: 200, // Fixed height for the chart
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 0, // Adjust as needed
                  sectionsSpace: 0, // Adjust the space between sections
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
