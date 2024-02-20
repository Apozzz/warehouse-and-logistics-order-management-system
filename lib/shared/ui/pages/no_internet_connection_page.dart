import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/services/connectivity_service.dart';
import 'package:provider/provider.dart';

class NoInternetConnectionPage extends StatelessWidget {
  const NoInternetConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              size: 50.0,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops, it looks like you are not connected to the internet!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Use the ConnectivityService to check for connection
                bool connected = await connectivityService.isConnected();
                if (connected) {
                  // Navigate back to the last known state
                  if (connectivityService.lastRoute != null) {
                    navigator.pushReplacementNamed(
                      connectivityService.lastRoute!,
                      arguments: connectivityService.lastArguments,
                    );
                  } else if (connectivityService.lastWidget != null) {
                    navigator.pushReplacementWidgetNoTransition(
                        connectivityService.lastWidget!);
                  } else {
                    navigator.pushReplacementNamedNoTransition(RoutePaths.auth);
                  }
                } else {
                  // Optionally, show a snackbar if still not connected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Still not connected. Please check your internet settings.')),
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
