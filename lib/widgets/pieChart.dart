import 'package:inventory_system/imports.dart';

class PieChartGraph extends StatelessWidget {
  List<String> pieNames;
  List<int> pieValues;

  PieChartGraph(this.pieNames, this.pieValues, {super.key});

  @override
  Widget build(BuildContext context) {
    return PieChartWidget(
      pieNames,
      pieValues,
    );
  }
}

class PieChartWidget extends StatefulWidget {
  List<String> pieNames;
  List<int> pieValues;

  PieChartWidget(this.pieNames, this.pieValues, {super.key});

  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  List<String> pieNames = [];
  List<int> pieValues = [];
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    pieNames = widget.pieNames;
    pieValues = widget.pieValues;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: <Widget>[
          const Text(
            'Deliveries Statuses',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: pieNames.mapIndexed<Widget>(
              (index, name) {
                return Indicator(
                  color: colors[index],
                  text: name,
                  isSquare: true,
                );
              },
            ).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;

                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(pieValues.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colors[i],
            value: pieValues[i].toDouble(),
            title: '${pieValues[i]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: colors[i],
            value: pieValues[i].toDouble(),
            title: '${pieValues[i]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: colors[i],
            value: pieValues[i].toDouble(),
            title: '${pieValues[i]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: colors[i],
            value: pieValues[i].toDouble(),
            title: '${pieValues[i]}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
