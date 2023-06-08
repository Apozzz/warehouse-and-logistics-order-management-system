import 'package:inventory_system/imports.dart';

class OverallMadeChart extends StatelessWidget {
  var provider;
  Map<double, double> coordinates = {0.0: 2.0};
  final String title;

  OverallMadeChart(this.provider, {super.key, required this.title});

  Future<List<Object>> getRecords() async {
    var records = await provider.getRecords();
    coordinates = await provider.getLineChartCoordinatesForGains(records);

    return records;
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

          var minYCoords = provider.getCoordinatesMinYByDate(
                                    coordinates.values.toList());

          return AspectRatio(
            aspectRatio: 1.2,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 35, top: 20, bottom: 20),
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
                        minY: (minYCoords > 0 ? minYCoords * 0.75 : minYCoords * 1.1)
                            .ceil()
                            .toDouble(),
                        maxY: (provider.getCoordinatesMaxYByDate(
                                    coordinates.values.toList()) *
                                1.25)
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
