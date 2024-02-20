import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  String? lastRoute;
  dynamic lastArguments;
  Widget? lastWidget;

  ConnectivityService() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
      notifyListeners();
    });
  }

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void initConnectivity() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    notifyListeners();
  }

  void setLastRoute(String routeName, {dynamic arguments}) {
    lastRoute = routeName;
    lastArguments = arguments;
    lastWidget = null;
  }

  void setLastWidget(Widget lastWidget) {
    lastWidget = lastWidget;
    lastArguments = null;
    lastRoute = null;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  ConnectivityResult get connectionStatus => _connectionStatus;
}
