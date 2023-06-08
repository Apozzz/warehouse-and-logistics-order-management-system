import 'package:inventory_system/imports.dart';

class LineChartCount extends StatelessWidget {
  var provider;
  final String title;

  LineChartCount(this.provider, {super.key, required this.title});

  Future<List<Object>> getRecords() async {
    return await provider.getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: getRecords(),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasData) {
          var records = snapshot.data;

          if (records!.isEmpty) {
            return Container();
          }

          Map<double, double> coordinates = provider.getLineChartCoordinates(records);

          return AspectRatio(
            aspectRatio: 1.3,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: coordinates.keys.length.toDouble() - 1,
                        minY: 0,
                        maxY: (provider.getCoordinatesMaxYByDate(
                                    coordinates.values.toList()) *
                                1.5)
                            .ceil()
                            .toDouble(),
                        gridData: FlGridData(drawVerticalLine: false),
                        lineBarsData: [
                          LineChartBarData(
                            show: records.isEmpty
                                ? false
                                : true,
                            isStrokeCapRound: true,
                            spots: coordinates.entries
                                .map((e) => FlSpot(e.key, e.value))
                                .toList(),
                            isCurved: true,
                            dotData: FlDotData(
                              show: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade50,
                                  Colors.blue.shade100,
                                ],
                              ),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) =>
                                      provider.getBottomSideTitles(
                                          records, value, meta))),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          border: const Border(
                              bottom: BorderSide(),
                              left: BorderSide(color: Colors.transparent)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicatorWithText('Connecting To Database'),
          );
        }
      },
    );
  }
}
