import 'package:inventory_system/imports.dart';
import 'package:intl/intl.dart' as intl;

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Security'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        drawer: const NavigationWidget(mainWidget: ''),
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
          child: const CustomTabBar(selectedIndex: 2),
        ),
        body: const SecurityPageWidget(),
      ),
    );
  }
}

class SecurityPageWidget extends StatefulWidget {
  const SecurityPageWidget({super.key});

  @override
  State<SecurityPageWidget> createState() => SecurityPageWidgetState();
}

class SecurityPageWidgetState extends State<SecurityPageWidget> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool authenticationEnabled = false;
  final codeController = InputController();
  DataBaseService dbService = DataBaseService();
  var connection;
  Authentication authentication = Authentication(
    '',
    id: 0,
    status: 0,
    code: '',
  );
  var biometricAuthWidget;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> updateAuthentication() async {
    var record = await dbService.getRecord(connection, authentication, 0);

    if (record.isEmpty) {
      await dbService.insertRecord(connection, authentication);

      return;
    }

    authentication = Authentication(
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      id: 0,
      status: authenticationEnabled ? 1 : 0,
      code: codeController.confirmedInput,
    );

    await dbService.updateRecord(connection, authentication);
  }

  Future<String> loadAuthentication() async {
    connection ??= await dbService.getDatabaseConnection(authentication);
    authenticationEnabled =
        await AuthenticationProvider().isAuthenticationSet();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    biometricAuthWidget = biometricAuthenticationToggle(availableBiometrics);

    return '';
  }

  Widget biometricAuthenticationToggle(List<BiometricType> biometrics) {
    return Switch(
      activeColor: Colors.white,
      activeTrackColor: Colors.blue,
      inactiveThumbColor: Colors.blueGrey.shade600,
      inactiveTrackColor: Colors.grey.shade400,
      splashRadius: 50.0,
      value: authenticationEnabled,
      onChanged: (value) => setState(() {
        authenticationEnabled = value;
        updateAuthentication();
      }),
    );
  }

  Widget bodyBuilder(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 30),
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: const [
                  Text(
                      'There you can add security password that is required to enter when opening an application'),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    side: BorderSide(
                        color: Color(0x00000000),
                        width: 0,
                        style: BorderStyle.solid),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.only(left: 6, right: 6),
                ),
                onPressed: () {
                  screenLockCreate(
                    context: context,
                    inputController: codeController,
                    digits: 6,
                    onConfirmed: (matchedText) async {
                      updateAuthentication();
                      Navigator.of(context).pop();
                    },
                    footer: TextButton(
                      onPressed: () {
                        codeController.unsetConfirmed();
                      },
                      child: const Text('Reset input'),
                    ),
                  );
                },
                child: Text(
                  'Add PIN'.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(height: 100),
            Column(
              children: [
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: const [
                      Text('Enable Security'),
                    ],
                  ),
                ),
                biometricAuthWidget,
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadAuthentication(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return bodyBuilder(context);
        } else {
          return Center(
            child: CircularProgressIndicatorWithText('Connecting To Database'),
          );
        }
      },
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
