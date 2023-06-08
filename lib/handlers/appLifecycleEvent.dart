import 'package:inventory_system/imports.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Function onResume;

  LifecycleEventHandler(this.onResume);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume.call();

        break;
      default:
        break;
    }
  }
}
