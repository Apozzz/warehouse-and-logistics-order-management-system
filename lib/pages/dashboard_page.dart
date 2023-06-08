import 'package:inventory_system/imports.dart';
import 'package:inventory_system/widgets/lineChartCount.dart';

void runDashboard() {
  runApp(const DashboardPage());
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        drawer: const NavigationWidget(mainWidget: 'dashboard'),
        body: const DashboardHomePage(title: 'Dashboard Page'),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: const CustomTabBar(selectedIndex: 0),
        ),
      ),
    );
  }
}

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key, required this.title});
  final String title;

  @override
  State<DashboardHomePage> createState() => DashboardHomePageWidget();
}

class DashboardHomePageWidget extends State<DashboardHomePage> {
  var productProvider = ProductProvider();
  var dbService = DataBaseService();
  var connection;
  String scannedText = '';
  var piechart;
  var lineChartCounts = {};

  void runScanner(ScanMode scanMode, BuildContext context) async {
    ScannerProvider scannerProvider = ScannerProvider(scanMode: scanMode);
    String scannedCode = await scannerProvider.scanCode();
    String scanProductColumn = 'qrcode';

    if (scannedCode == '-1') {
      return;
    }

    switch (scanMode) {
      case ScanMode.QR:
        scannedText = scannedCode;
        print('SCANNED QR');
        print(scannedText);
        break;
      case ScanMode.BARCODE:
        scannedText = scannedCode;
        scanProductColumn = 'barcode';
        print('SCANNED BARCODE');
        print(scannedText);
        break;
      default:
        break;
    }

    await scannerResultsBuilder(context, scanProductColumn);
  }

  void scannerBuilder(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 120,
            ),
            child: SizedBox(
              height: 140,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Choose Scanner Type',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                side: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0,
                                    style: BorderStyle.solid),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                            ),
                            onPressed: () async {
                              runScanner(ScanMode.QR, context);
                            },
                            child: Text(
                              'QR Code'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                side: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0,
                                    style: BorderStyle.solid),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                            ),
                            onPressed: () async {
                              runScanner(ScanMode.BARCODE, context);
                            },
                            child: Text(
                              'Barcode'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> scannerResultsBuilder(
      BuildContext context, String scanProductColumn) async {
    await productProvider.getScannedProductInfo(
      scannedText,
      dbService,
      connection,
      context,
      scanProductColumn,
    );
  }

  Future<String> getDbConnection() async {
    connection ??= await productProvider.getDatabaseConnection(dbService);
    piechart = await DeliveryProvider().getDeliveryStatusPieChart(dbService);
    lineChartCounts[0] = [ProductProvider(), 'Daily New Product Increase'];
    lineChartCounts[1] = [WarehouseProvider(), 'Daily New Warehouse Increase'];
    lineChartCounts[2] = [OrderProvider(), 'Daily New Order Increase'];
    lineChartCounts[3] = [DeliveryProvider(), 'Daily New Delivery Increase'];

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getDbConnection(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Container(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 240,
                        height: 40,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              side: BorderSide(
                                  color: Color(0x00000000),
                                  width: 0,
                                  style: BorderStyle.solid),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                          ),
                          onPressed: () async {
                            scannerBuilder(context);
                          },
                          child: Text(
                            'Search Product By Scan'.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (context, index) => LineChartCount(
                                lineChartCounts[index][0],
                                title: lineChartCounts[index][1])),
                      ),
                      OverallMadeChart(DeliveryProvider(),
                          title: 'Overall Made Amount From Deliveries'),
                      const CountGraphs(),
                      piechart,
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicatorWithText(
                    'Connecting To Database'));
          }
        });
  }
}
