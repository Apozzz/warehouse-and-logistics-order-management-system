import 'package:inventory_system/imports.dart';

void main() {
  runApp(const MenuPage());
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuPageWidget(),
    );
  }
}

class MenuPageWidget extends StatefulWidget {
  const MenuPageWidget({super.key});

  @override
  State<StatefulWidget> createState() => MenuPageWidgetState();
}

class MenuPageWidgetState extends State<MenuPageWidget> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool authenticationRequired = false;
  String authenticationPassword = '';
  bool calledFlag = false;

  Future<void> authenticateWithPin(
      bool authenticationRequired, BuildContext context) async {
    if (!authenticationRequired) {
      return;
    }

    bool authenticated = false;

    try {
      setState(() {
        calledFlag = true;
        _isAuthenticating = true;
      });

      await screenLock(
        context: context,
        correctString: authenticationPassword,
        canCancel: false,
        onUnlocked: () async {
          authenticated = true;
          Navigator.of(context).pop();
        },
      );

      if (!authenticated) {
        authenticateWithPin(authenticationRequired, context);
      } else {
        _isAuthenticating = false;
      }

      setState(() {
        if (authenticated) {
          _isAuthenticating = false;
        }
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = true;
      });
      return;
    }

    if (!mounted) {
      return;
    }
  }

  void setAuthentication(bool authenticationRequired) {
    if (this.authenticationRequired == authenticationRequired) {
      return;
    }

    setState(() {
      this.authenticationRequired = authenticationRequired;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!calledFlag) {
      Future.delayed(
        Duration.zero,
        () async {
          authenticationRequired =
              await AuthenticationProvider().isAuthenticationSet();
          authenticationPassword =
              await AuthenticationProvider().getAuthenticationPin();

          if (authenticationRequired) {
            await authenticateWithPin(authenticationRequired, context);
            WidgetsBinding.instance.addObserver(
              LifecycleEventHandler(() async {
                await authenticateWithPin(authenticationRequired, context);
              }),
            );
          }
        },
      );
    }

    return _isAuthenticating ? const SizedBox() : const DashboardPage();
  }
}
